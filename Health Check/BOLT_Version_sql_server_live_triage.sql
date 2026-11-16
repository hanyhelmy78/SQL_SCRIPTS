/*=====================================================================
  SQL Server 2022 / Azure SQL - Live session and blocking triage
  Sections:
    1. Active requests (get_active_sessions)
    2. Idle sessions holding open transactions
    3. Blocking chains with head blocker (get_blocking_chains)
    4. Long-running transactions and log reuse blockers (get_long_running_transactions)
    5. Post-incident capture: sp_WhoIsActive minute-by-minute history (get_hiq)
    6. Availability groups: replicas, database sync, listeners, current primary
    7. Memory dumps, loaded modules, error log
    8. Deadlocks (system_health + RCA session), login failures, SQL Agent jobs
    9. Backup age per database and preferred backup replica
   10. Instance baseline: services, IFI, LPIM/memory model, tempdb, page verify
  Requires VIEW SERVER STATE (VIEW DATABASE STATE on Azure SQL DB).
  Section 5 requires sp_WhoIsActive installed in the current database.
  Sections 6-8 are on-premises / SQL Server only (no AG, dumps, error log, default trace, or Agent on Azure SQL DB).
=====================================================================*/

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @min_tran_age_seconds int = 60;

/*---------------------------------------------------------------
  1. Active requests
---------------------------------------------------------------*/
SELECT
    r.session_id,
    r.request_id,
    s.login_name,
    s.host_name,
    s.program_name,
    DB_NAME(r.database_id)                  AS database_name,
    r.status,
    r.command,
    r.wait_type,
    r.wait_time                             AS wait_time_ms,
    r.wait_resource,
    r.blocking_session_id,
    r.last_wait_type,
    r.cpu_time                              AS cpu_time_ms,
    r.logical_reads,
    r.reads                                 AS physical_reads,
    r.writes,
    r.total_elapsed_time                    AS elapsed_ms,
    r.open_transaction_count,
    r.percent_complete,
    st.text                                 AS batch_text,
    SUBSTRING(st.text,
        (r.statement_start_offset / 2) + 1,
        ((CASE r.statement_end_offset
              WHEN -1 THEN DATALENGTH(st.text)
              ELSE r.statement_end_offset
          END - r.statement_start_offset) / 2) + 1) AS statement_text
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s
    ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE s.is_user_process = 1
  AND r.session_id <> @@SPID
ORDER BY r.total_elapsed_time DESC;

/*---------------------------------------------------------------
  2. Sessions idle in an open transaction (invisible to request-based blocking views)
---------------------------------------------------------------*/
SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    s.open_transaction_count,
    s.last_request_end_time,
    DATEDIFF(SECOND, s.last_request_end_time, SYSDATETIME()) AS idle_seconds,
    c.client_net_address,
    st.text                                 AS last_batch_text
FROM sys.dm_exec_sessions AS s
LEFT JOIN sys.dm_exec_connections AS c
    ON c.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS st
WHERE s.is_user_process = 1
  AND s.status = N'sleeping'
  AND s.open_transaction_count > 0
ORDER BY idle_seconds DESC;

/*---------------------------------------------------------------
  3. Blocking chains: head blockers first, then every waiter beneath them
---------------------------------------------------------------*/
;WITH waiters AS
(
    SELECT r.session_id, r.blocking_session_id
    FROM sys.dm_exec_requests AS r
    WHERE r.blocking_session_id > 0
),
chain AS
(
    -- Anchor: sessions that block others but are not themselves blocked
    SELECT
        w.blocking_session_id                AS session_id,
        CAST(NULL AS int)                    AS blocked_by,
        0                                    AS depth,
        CAST(RIGHT(N'000000' + CAST(w.blocking_session_id AS varchar(6)), 6) AS varchar(900)) AS chain_path
    FROM waiters AS w
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM waiters AS w2
        WHERE w2.session_id = w.blocking_session_id
    )
    GROUP BY w.blocking_session_id

    UNION ALL

    -- Recurse: waiters blocked by the session in the previous level
    SELECT
        w.session_id,
        w.blocking_session_id,
        c.depth + 1,
        CAST(c.chain_path + N'>' + RIGHT(N'000000' + CAST(w.session_id AS varchar(6)), 6) AS varchar(900))
    FROM waiters AS w
    JOIN chain AS c
        ON c.session_id = w.blocking_session_id
    WHERE c.depth < 32
)
SELECT
    c.depth,
    c.chain_path,
    c.session_id,
    c.blocked_by,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    r.wait_type,
    r.wait_time                             AS wait_time_ms,
    r.wait_resource,
    DB_NAME(COALESCE(r.database_id, cn.database_id)) AS database_name,
    st.text                                 AS current_or_last_batch
FROM chain AS c
LEFT JOIN sys.dm_exec_sessions AS s
    ON s.session_id = c.session_id
LEFT JOIN sys.dm_exec_requests AS r
    ON r.session_id = c.session_id
LEFT JOIN sys.dm_exec_connections AS cn
    ON cn.session_id = c.session_id
OUTER APPLY sys.dm_exec_sql_text(COALESCE(r.sql_handle, cn.most_recent_sql_handle)) AS st
ORDER BY c.chain_path, c.depth
OPTION (MAXRECURSION 100);

/*---------------------------------------------------------------
  4. Long-running transactions and what is preventing log reuse
---------------------------------------------------------------*/
SELECT
    at.transaction_id,
    at.name                                 AS transaction_name,
    at.transaction_begin_time,
    DATEDIFF(SECOND, at.transaction_begin_time, SYSDATETIME()) AS age_seconds,
    st.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status                                AS session_status,
    DB_NAME(dt.database_id)                 AS database_name,
    dt.database_transaction_log_bytes_used  AS log_bytes_used,
    dt.database_transaction_log_bytes_reserved AS log_bytes_reserved
FROM sys.dm_tran_active_transactions AS at
JOIN sys.dm_tran_session_transactions AS st
    ON st.transaction_id = at.transaction_id
JOIN sys.dm_exec_sessions AS s
    ON s.session_id = st.session_id
LEFT JOIN sys.dm_tran_database_transactions AS dt
    ON dt.transaction_id = at.transaction_id
   AND dt.database_id > 0
WHERE at.transaction_begin_time < DATEADD(SECOND, -@min_tran_age_seconds, SYSDATETIME())
ORDER BY age_seconds DESC;

SELECT
    d.name                                  AS database_name,
    d.log_reuse_wait_desc
FROM sys.databases AS d
WHERE d.log_reuse_wait_desc <> N'NOTHING'
ORDER BY d.name;

/*---------------------------------------------------------------
  5. Post-incident capture (run once to create, then schedule the collector every minute)
---------------------------------------------------------------*/
IF OBJECT_ID(N'dbo.WhoIsActive_Log', N'U') IS NULL
BEGIN
    DECLARE @create_sql nvarchar(max);
    EXEC dbo.sp_WhoIsActive
        @return_schema = 1,
        @schema = @create_sql OUTPUT;
    SET @create_sql = REPLACE(@create_sql, N'<table_name>', N'dbo.WhoIsActive_Log');
    EXEC (@create_sql);
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.WhoIsActive_Log') AND name = N'IX_WhoIsActive_Log_collection_time')
    CREATE CLUSTERED INDEX IX_WhoIsActive_Log_collection_time
        ON dbo.WhoIsActive_Log (collection_time);

/* Collector: schedule as a SQL Agent job step running every 1 minute */
-- EXEC dbo.sp_WhoIsActive
--     @get_plans = 1,
--     @get_task_info = 2,
--     @destination_table = N'dbo.WhoIsActive_Log';

/* Retention: schedule daily, keeps 14 days */
-- DELETE FROM dbo.WhoIsActive_Log
-- WHERE collection_time < DATEADD(DAY, -14, SYSDATETIME());

/* Point-in-time lookup: what was running at 02:32 on the given date */
DECLARE @incident_time datetime = '2026-11-15T02:32:00';

SELECT *
FROM dbo.WhoIsActive_Log
WHERE collection_time BETWEEN DATEADD(MINUTE, -1, @incident_time) AND DATEADD(MINUTE, 1, @incident_time)
ORDER BY collection_time, session_id;

/*---------------------------------------------------------------
  6. Availability groups
---------------------------------------------------------------*/
SELECT
    ag.name                                 AS group_name,
    ag.failure_condition_level,
    ag.health_check_timeout,
    ar.replica_server_name,
    ar.availability_mode_desc,
    ar.failover_mode_desc,
    ar.session_timeout,
    ars.role_desc,
    ars.operational_state_desc,
    ars.connected_state_desc,
    ars.synchronization_health_desc,
    ars.last_connect_error_description,
    ars.last_connect_error_timestamp
FROM sys.availability_groups AS ag
JOIN sys.availability_replicas AS ar
    ON ar.group_id = ag.group_id
LEFT JOIN sys.dm_hadr_availability_replica_states AS ars
    ON ars.replica_id = ar.replica_id
ORDER BY group_name, ar.replica_server_name;

SELECT
    ag.name                                 AS group_name,
    DB_NAME(drs.database_id)                AS database_name,
    ar.replica_server_name,
    drs.is_primary_replica,
    drs.synchronization_state_desc,
    drs.synchronization_health_desc,
    drs.database_state_desc,
    drs.log_send_queue_size                 AS log_send_queue_kb,
    drs.redo_queue_size                     AS redo_queue_kb,
    drs.log_send_rate                       AS log_send_rate_kb_s,
    drs.redo_rate                           AS redo_rate_kb_s,
    drs.last_commit_time
FROM sys.dm_hadr_database_replica_states AS drs
JOIN sys.availability_replicas AS ar
    ON ar.replica_id = drs.replica_id
JOIN sys.availability_groups AS ag
    ON ag.group_id = ar.group_id
ORDER BY group_name, database_name, ar.replica_server_name;

SELECT
    ag.name                                 AS group_name,
    l.dns_name,
    l.port,
    l.is_conformant,
    l.ip_configuration_string_from_cluster
FROM sys.availability_group_listeners AS l
JOIN sys.availability_groups AS ag
    ON ag.group_id = l.group_id;

SELECT
    ag.name                                 AS group_name,
    ar.replica_server_name                  AS current_primary
FROM sys.availability_groups AS ag
JOIN sys.dm_hadr_availability_replica_states AS ars
    ON ars.group_id = ag.group_id
   AND ars.role_desc = N'PRIMARY'
JOIN sys.availability_replicas AS ar
    ON ar.replica_id = ars.replica_id;

/*---------------------------------------------------------------
  7. Memory dumps, loaded modules, error log
---------------------------------------------------------------*/
SELECT
    creation_time,
    filename,
    size_in_bytes
FROM sys.dm_server_memory_dumps
ORDER BY creation_time DESC;

SELECT
    name,
    file_version,
    product_version,
    company,
    description
FROM sys.dm_os_loaded_modules
ORDER BY name;

EXEC master.dbo.xp_readerrorlog 0, 1, N'Error', NULL, NULL, NULL, N'desc';

-- SQLDump*.txt contents are read through the DBA-owned signed procedure; path is installation-specific.
-- EXEC master.dbo.ReadSqlDump @DumpFile = N'<approved dump path>';

/*---------------------------------------------------------------
  8. Deadlocks, login failures, SQL Agent jobs
---------------------------------------------------------------*/
DECLARE @errorlog_path nvarchar(4000) = CAST(SERVERPROPERTY(N'ErrorLogFileName') AS nvarchar(4000));
DECLARE @log_dir nvarchar(4000) = LEFT(@errorlog_path, LEN(@errorlog_path) - CHARINDEX(N'\', REVERSE(@errorlog_path)) + 1);
DECLARE @system_health_xel nvarchar(4000) = @log_dir + N'system_health*.xel';

SELECT
    x.timestamp_utc,
    CAST(x.event_data AS xml)               AS deadlock_event_xml
FROM sys.fn_xe_file_target_read_file(@system_health_xel, NULL, NULL, NULL) AS x
WHERE x.object_name = N'xml_deadlock_report'
ORDER BY x.timestamp_utc DESC;

-- Set to the RCA session's event file wildcard to read it the same way.
DECLARE @rca_xel nvarchar(4000) = NULL;
IF @rca_xel IS NOT NULL
    SELECT
        x.timestamp_utc,
        CAST(x.event_data AS xml)           AS event_xml
    FROM sys.fn_xe_file_target_read_file(@rca_xel, NULL, NULL, NULL) AS x
    ORDER BY x.timestamp_utc DESC;

DECLARE @trace_path nvarchar(260) = (SELECT path FROM sys.traces WHERE is_default = 1);
IF @trace_path IS NOT NULL
    SELECT
        StartTime,
        LoginName,
        HostName,
        ApplicationName,
        TextData,
        Error
    FROM sys.fn_trace_gettable(@trace_path, DEFAULT)
    WHERE EventClass = 20          -- Audit Login Failed
    ORDER BY StartTime DESC;

SELECT
    j.name                                  AS job_name,
    h.step_id,
    h.step_name,
    h.run_status,
    msdb.dbo.agent_datetime(h.run_date, h.run_time) AS run_datetime,
    h.run_duration,
    h.message
FROM msdb.dbo.sysjobhistory AS h
JOIN msdb.dbo.sysjobs AS j
    ON j.job_id = h.job_id
WHERE h.step_id = 0
ORDER BY h.instance_id DESC;

SELECT
    j.name                                  AS job_name,
    s.step_id,
    s.step_name,
    s.subsystem,
    s.database_name,
    s.command
FROM msdb.dbo.sysjobsteps AS s
JOIN msdb.dbo.sysjobs AS j
    ON j.job_id = s.job_id
ORDER BY j.name, s.step_id;

/*---------------------------------------------------------------
  9. Backup age per database and preferred backup replica
---------------------------------------------------------------*/
SELECT
    d.name                                  AS database_name,
    p.is_preferred_backup_replica,
    MAX(CASE WHEN b.type = N'D' THEN b.backup_finish_date END) AS last_full_backup,
    MAX(CASE WHEN b.type = N'I' THEN b.backup_finish_date END) AS last_diff_backup,
    MAX(CASE WHEN b.type = N'L' THEN b.backup_finish_date END) AS last_log_backup
FROM sys.databases AS d
CROSS APPLY (SELECT sys.fn_hadr_backup_is_preferred_replica(d.name) AS is_preferred_backup_replica) AS p
LEFT JOIN msdb.dbo.backupset AS b
    ON b.database_name = d.name
WHERE d.database_id > 4
GROUP BY d.name, p.is_preferred_backup_replica
ORDER BY d.name;

/*---------------------------------------------------------------
  10. Instance baseline
---------------------------------------------------------------*/
SELECT
    servicename,
    startup_type_desc,
    status_desc,
    instant_file_initialization_enabled,
    last_startup_time,
    service_account,
    filename
FROM sys.dm_server_services;

SELECT
    cpu_count,
    hyperthread_ratio,
    physical_memory_kb / 1024               AS physical_memory_mb,
    committed_kb / 1024                     AS committed_memory_mb,
    sql_memory_model_desc,                  -- LOCK_PAGES = Lock Pages in Memory in effect
    sqlserver_start_time
FROM sys.dm_os_sys_info;

SELECT
    name,
    type_desc,
    size / 128.0                            AS size_mb,
    CASE WHEN max_size = -1 THEN NULL ELSE max_size / 128.0 END AS max_size_mb,
    growth,
    is_percent_growth,
    physical_name
FROM tempdb.sys.database_files
ORDER BY file_id;

SELECT
    name,
    page_verify_option_desc
FROM sys.databases
WHERE database_id > 4
ORDER BY name;
