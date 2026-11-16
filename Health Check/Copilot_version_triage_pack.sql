/******************************************************************************
SQL Server 2022 - Incident Response & Health Check
Version: 1.0

Returns:
1. Instance Information
2. Active Requests
3. Blocking Chains
4. Long Running Transactions
5. Wait Statistics
6. Scheduler / CPU Pressure
7. File I/O Latency
8. Query Store Status
9. Query Store Regressions
10. Query Store Aborted Executions
11. Availability Group Health
12. Current Primary Replica
13. Availability Group Listeners
14. Memory Dumps
15. Loaded Modules
16. Deadlocks (system_health)
17. SQL Agent Failures
18. Configuration Review
19. Backup Status
******************************************************************************/

SET NOCOUNT ON;

PRINT '==== INSTANCE INFORMATION ====';
SELECT
    @@SERVERNAME AS ServerName,
    @@VERSION AS VersionInfo,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('EngineEdition') AS EngineEdition;

-------------------------------------------------------------------------------
-- ACTIVE REQUESTS
-------------------------------------------------------------------------------

PRINT '==== ACTIVE REQUESTS ====';
SELECT
    r.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    DB_NAME(r.database_id) AS database_name,
    r.status,
    r.command,
    r.wait_type,
    r.wait_time,
    r.wait_resource,
    r.blocking_session_id,
    r.cpu_time,
    r.logical_reads,
    r.reads,
    r.writes,
    r.total_elapsed_time / 1000.0 AS elapsed_seconds,
    SUBSTRING(
        st.text,
        (r.statement_start_offset/2)+1,
        (
            CASE r.statement_end_offset
                WHEN -1 THEN DATALENGTH(st.text)
                ELSE r.statement_end_offset
            END - r.statement_start_offset
        )/2 + 1
    ) AS current_statement
FROM sys.dm_exec_requests r
INNER JOIN sys.dm_exec_sessions s
    ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st
WHERE r.session_id <> @@SPID
ORDER BY r.total_elapsed_time DESC;

-------------------------------------------------------------------------------
-- BLOCKING
-------------------------------------------------------------------------------

PRINT '==== BLOCKING CHAINS ====';

;WITH BlockingTree AS
(
    SELECT
        session_id,
        blocking_session_id,
        CAST(session_id AS VARCHAR(4000)) AS Chain,
        0 AS Lvl
    FROM sys.dm_exec_requests
    WHERE blocking_session_id = 0

    UNION ALL

    SELECT
        r.session_id,
        r.blocking_session_id,
        CAST(bt.Chain + ' -> ' +
             CAST(r.session_id AS VARCHAR(20)) AS VARCHAR(4000)),
        bt.Lvl + 1
    FROM sys.dm_exec_requests r
    JOIN BlockingTree bt
        ON r.blocking_session_id = bt.session_id
)
SELECT *
FROM BlockingTree
ORDER BY Chain;

-------------------------------------------------------------------------------
-- LONG TRANSACTIONS
-------------------------------------------------------------------------------

PRINT '==== LONG RUNNING TRANSACTIONS ====';

SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    at.transaction_id,
    at.name,
    at.transaction_begin_time,
    DATEDIFF(MINUTE,
             at.transaction_begin_time,
             SYSDATETIME()) AS age_minutes
FROM sys.dm_tran_active_transactions at
INNER JOIN sys.dm_tran_session_transactions st
    ON at.transaction_id = st.transaction_id
INNER JOIN sys.dm_exec_sessions s
    ON st.session_id = s.session_id
ORDER BY age_minutes DESC;

-------------------------------------------------------------------------------
-- WAIT STATS
-------------------------------------------------------------------------------

PRINT '==== WAIT STATISTICS ====';

SELECT TOP (50)
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    signal_wait_time_ms,
    wait_time_ms /
        NULLIF(waiting_tasks_count,0) AS avg_wait_ms
FROM sys.dm_os_wait_stats
WHERE waiting_tasks_count > 0
AND wait_type NOT LIKE 'SLEEP%'
ORDER BY wait_time_ms DESC;

-------------------------------------------------------------------------------
-- CPU / SCHEDULERS
-------------------------------------------------------------------------------

PRINT '==== SCHEDULERS ====';

SELECT
    scheduler_id,
    cpu_id,
    current_tasks_count,
    runnable_tasks_count,
    active_workers_count,
    current_workers_count,
    load_factor
FROM sys.dm_os_schedulers
WHERE status = 'VISIBLE ONLINE'
ORDER BY runnable_tasks_count DESC;

-------------------------------------------------------------------------------
-- FILE IO STATS
-------------------------------------------------------------------------------

PRINT '==== FILE I/O ====';

SELECT
    DB_NAME(vfs.database_id) AS database_name,
    mf.file_id,
    mf.type_desc,
    mf.physical_name,
    vfs.num_of_reads,
    vfs.num_of_writes,
    vfs.io_stall_read_ms,
    vfs.io_stall_write_ms,
    vfs.io_stall_read_ms /
      NULLIF(vfs.num_of_reads,0) AS avg_read_ms,
    vfs.io_stall_write_ms /
      NULLIF(vfs.num_of_writes,0) AS avg_write_ms
FROM sys.dm_io_virtual_file_stats(NULL,NULL) vfs
INNER JOIN sys.master_files mf
    ON mf.database_id = vfs.database_id
   AND mf.file_id = vfs.file_id
ORDER BY avg_read_ms DESC;

-------------------------------------------------------------------------------
-- QUERY STORE
-------------------------------------------------------------------------------

PRINT '==== QUERY STORE STATUS ====';

SELECT *
FROM sys.database_query_store_options;

-------------------------------------------------------------------------------
-- QUERY STORE REGRESSIONS
-------------------------------------------------------------------------------

PRINT '==== QUERY STORE REGRESSIONS ====';

IF EXISTS
(
    SELECT 1
    FROM sys.database_query_store_options
    WHERE actual_state_desc = 'READ_WRITE'
)
BEGIN

    WITH PlanStats AS
    (
        SELECT
            q.query_id,
            p.plan_id,
            rs.avg_duration
        FROM sys.query_store_query q
        JOIN sys.query_store_plan p
            ON q.query_id = p.query_id
        JOIN sys.query_store_runtime_stats rs
            ON p.plan_id = rs.plan_id
    )
    SELECT TOP (50)
        query_id,
        COUNT(DISTINCT plan_id) AS plans,
        MIN(avg_duration) AS best_duration,
        MAX(avg_duration) AS worst_duration,
        MAX(avg_duration) /
        NULLIF(MIN(avg_duration),0) AS regression_factor
    FROM PlanStats
    GROUP BY query_id
    HAVING COUNT(DISTINCT plan_id) > 1
    ORDER BY regression_factor DESC;

END

-------------------------------------------------------------------------------
-- QUERY STORE ABORTS
-------------------------------------------------------------------------------

PRINT '==== QUERY STORE ABORTED EXECUTIONS ====';

IF EXISTS
(
    SELECT 1
    FROM sys.database_query_store_options
    WHERE actual_state_desc = 'READ_WRITE'
)
BEGIN

    SELECT TOP (100)
        q.query_id,
        p.plan_id,
        rs.execution_type_desc,
        rs.count_executions,
        rs.avg_duration
    FROM sys.query_store_runtime_stats rs
    INNER JOIN sys.query_store_plan p
        ON rs.plan_id = p.plan_id
    INNER JOIN sys.query_store_query q
        ON p.query_id = q.query_id
    WHERE rs.execution_type_desc = 'Aborted'
    ORDER BY rs.count_executions DESC;

END

-------------------------------------------------------------------------------
-- AVAILABILITY GROUP HEALTH
-------------------------------------------------------------------------------

IF SERVERPROPERTY('IsHadrEnabled') = 1
BEGIN

    PRINT '==== AG HEALTH ====';
    
    SELECT
        DB_NAME(database_id) AS database_name,
        synchronization_state_desc,
        synchronization_health_desc,
        log_send_queue_size,
        redo_queue_size,
        is_commit_participant
    FROM sys.dm_hadr_database_replica_states;

    PRINT '==== CURRENT PRIMARY ====';
    
    SELECT
        ag.name,
        ar.replica_server_name,
        ars.role_desc
    FROM sys.availability_groups ag
    JOIN sys.availability_replicas ar
        ON ag.group_id = ar.group_id
    JOIN sys.dm_hadr_availability_replica_states ars
        ON ar.replica_id = ars.replica_id
    WHERE ars.role_desc = 'PRIMARY';

    PRINT '==== AG LISTENERS ====';
    
    SELECT *
    FROM sys.availability_group_listeners;

END

-------------------------------------------------------------------------------
-- MEMORY DUMPS
-------------------------------------------------------------------------------

PRINT '==== MEMORY DUMPS ====';

SELECT *
FROM sys.dm_server_memory_dumps
ORDER BY creation_time DESC;

-------------------------------------------------------------------------------
-- LOADED MODULES
-------------------------------------------------------------------------------

PRINT '==== LOADED MODULES ====';

SELECT
    name,
    company,
    version
FROM sys.dm_os_loaded_modules
ORDER BY company,name;

-------------------------------------------------------------------------------
-- DEADLOCKS
-------------------------------------------------------------------------------

PRINT '==== SYSTEM HEALTH DEADLOCKS ====';

BEGIN TRY

    SELECT TOP (20)
        CAST(event_data AS XML) AS deadlock_graph
    FROM sys.fn_xe_file_target_read_file
    (
        'system_health*.xel',
        NULL,
        NULL,
        NULL
    )
    WHERE object_name = 'xml_deadlock_report';

END TRY
BEGIN CATCH

    SELECT ERROR_MESSAGE() AS XeReadError;

END CATCH;

-------------------------------------------------------------------------------
-- SQL AGENT FAILURES
-------------------------------------------------------------------------------

PRINT '==== JOB FAILURES ====';

SELECT TOP (100)
    j.name,
    h.step_id,
    h.run_date,
    h.run_time,
    h.run_status,
    h.message
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobhistory h
    ON j.job_id = h.job_id
WHERE h.run_status <> 1
ORDER BY h.instance_id DESC;

-------------------------------------------------------------------------------
-- CONFIGURATION REVIEW
-------------------------------------------------------------------------------

PRINT '==== INSTANCE CONFIGURATION ====';

SELECT
    name,
    value_in_use
FROM sys.configurations
WHERE name IN
(
    'max degree of parallelism',
    'cost threshold for parallelism',
    'max server memory (MB)',
    'optimize for ad hoc workloads'
)
ORDER BY name;

-------------------------------------------------------------------------------
-- FILE INITIALIZATION
-------------------------------------------------------------------------------

PRINT '==== INSTANT FILE INITIALIZATION ====';

SELECT
    servicename,
    startup_type_desc,
    instant_file_initialization_enabled
FROM sys.dm_server_services;

-------------------------------------------------------------------------------
-- BACKUP AGE
-------------------------------------------------------------------------------

PRINT '==== BACKUP AGE ====';

SELECT
    d.name,
    d.state_desc,
    MAX(bs.backup_finish_date) AS LastBackup
FROM sys.databases d
LEFT JOIN msdb.dbo.backupset bs
    ON d.name = bs.database_name
GROUP BY
    d.name,
    d.state_desc
ORDER BY LastBackup;

PRINT '==== SCRIPT COMPLETE ====';