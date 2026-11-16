/*
SQL Server 2022 troubleshooting query pack
Run with VIEW SERVER STATE (SQL Server 2022); Query Store sections need VIEW DATABASE STATE.
Run database-scoped sections in the target database. Requires appropriate msdb/XE/log access.
No query in this file changes configuration or data.
*/
SET NOCOUNT ON;

/* 1. Active requests, SQL text, waits, blockers */
SELECT r.session_id, s.login_name, s.host_name, s.program_name,
       DB_NAME(r.database_id) AS database_name, r.status, r.command,
       r.start_time, r.total_elapsed_time/1000.0 AS elapsed_s,
       r.cpu_time/1000.0 AS cpu_s, r.logical_reads, r.reads, r.writes,
       r.wait_type, r.wait_time/1000.0 AS wait_s, r.last_wait_type,
       r.wait_resource, r.blocking_session_id,
       SUBSTRING(txt.text,
         (r.statement_start_offset/2)+1,
         (CASE r.statement_end_offset WHEN -1 THEN DATALENGTH(txt.text)
               ELSE r.statement_end_offset END-r.statement_start_offset)/2+1) AS running_statement,
       txt.text AS batch_text
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s ON s.session_id=r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS txt
WHERE r.session_id <> @@SPID
ORDER BY CASE WHEN r.blocking_session_id<>0 THEN 0 ELSE 1 END,
         r.total_elapsed_time DESC;

/* 2. Blocking chains: root blocker and each blocked request */
;WITH b AS (
 SELECT r.session_id, r.blocking_session_id, r.database_id, r.wait_type,
        r.wait_time, r.wait_resource, r.status, r.start_time, r.sql_handle,
        CONVERT(varchar(max), CONCAT('/',r.session_id,'/')) AS chain,
        r.blocking_session_id AS root_candidate
 FROM sys.dm_exec_requests r WHERE r.session_id<>@@SPID
), roots AS (
 SELECT b.session_id AS blocked_session_id, b.blocking_session_id,
        b.database_id,b.wait_type,b.wait_time,b.wait_resource,b.status,b.start_time,b.sql_handle,
        b.blocking_session_id AS root_blocker
 FROM b WHERE b.blocking_session_id>0
)
SELECT x.root_blocker, x.blocked_session_id, s.login_name, s.host_name, s.program_name,
       DB_NAME(x.database_id) AS database_name, x.wait_type, x.wait_time/1000.0 AS wait_s,
       x.wait_resource,x.status,x.start_time,t.text AS blocked_batch
FROM roots x
LEFT JOIN sys.dm_exec_sessions s ON s.session_id=x.blocked_session_id
OUTER APPLY sys.dm_exec_sql_text(x.sql_handle) t
ORDER BY x.root_blocker,x.wait_time DESC;
-- Root blocker details (includes sleeping blockers with no active request)
SELECT DISTINCT r.blocking_session_id AS blocker_session_id,
       s.login_name,s.host_name,s.program_name,s.status AS session_status,
       s.open_transaction_count, r.wait_type,r.wait_time/1000.0 AS wait_s,
       ib.event_info AS most_recent_input
FROM sys.dm_exec_requests r
LEFT JOIN sys.dm_exec_sessions s ON s.session_id=r.blocking_session_id
OUTER APPLY sys.dm_exec_input_buffer(r.blocking_session_id,NULL) ib
WHERE r.blocking_session_id>0;

/* 3. Open/long-running transactions in this database context */
SELECT s.session_id,s.login_name,s.host_name,s.program_name,
       at.transaction_id, at.transaction_begin_time,
       DATEDIFF(second,at.transaction_begin_time,SYSUTCDATETIME()) AS age_s,
       at.transaction_type,at.transaction_state,
       dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved,
       r.status,r.command,r.wait_type,r.blocking_session_id,
       ib.event_info AS last_input
FROM sys.dm_tran_active_transactions at
JOIN sys.dm_tran_session_transactions st ON st.transaction_id=at.transaction_id
JOIN sys.dm_exec_sessions s ON s.session_id=st.session_id
LEFT JOIN sys.dm_tran_database_transactions dt
  ON dt.transaction_id=at.transaction_id AND dt.database_id=DB_ID()
LEFT JOIN sys.dm_exec_requests r ON r.session_id=s.session_id
OUTER APPLY sys.dm_exec_input_buffer(s.session_id,NULL) ib
WHERE at.transaction_begin_time < DATEADD(minute,-5,SYSUTCDATETIME())
ORDER BY at.transaction_begin_time;

/* 4. Query Store status (run in target database before interpreting zero rows) */
SELECT actual_state_desc,desired_state_desc,readonly_reason,
       current_storage_size_mb,max_storage_size_mb,query_capture_mode_desc,
       interval_length_minutes,flush_interval_seconds,stale_query_threshold_days
FROM sys.database_query_store_options;
-- Top queries in the last 24h, including aborted (typically client timeout/cancel) executions
DECLARE @since datetimeoffset = DATEADD(hour,-24,SYSDATETIMEOFFSET());
SELECT TOP (100) q.query_id, p.plan_id, qt.query_sql_text,
       SUM(rs.count_executions) AS executions,
       SUM(CASE WHEN rs.execution_type_desc='Aborted' THEN rs.count_executions ELSE 0 END) AS aborted,
       SUM(CASE WHEN rs.execution_type_desc='Exception' THEN rs.count_executions ELSE 0 END) AS exceptions,
       CAST(SUM(rs.avg_duration*rs.count_executions)/NULLIF(SUM(rs.count_executions),0)/1000.0 AS decimal(18,2)) AS weighted_avg_duration_ms,
       MAX(rs.max_duration)/1000.0 AS max_duration_ms,
       CAST(SUM(rs.avg_cpu_time*rs.count_executions)/NULLIF(SUM(rs.count_executions),0)/1000.0 AS decimal(18,2)) AS weighted_avg_cpu_ms,
       SUM(rs.avg_logical_io_reads*rs.count_executions) AS approx_logical_reads
FROM sys.query_store_query q
JOIN sys.query_store_query_text qt ON qt.query_text_id=q.query_text_id
JOIN sys.query_store_plan p ON p.query_id=q.query_id
JOIN sys.query_store_runtime_stats rs ON rs.plan_id=p.plan_id
JOIN sys.query_store_runtime_stats_interval i ON i.runtime_stats_interval_id=rs.runtime_stats_interval_id
WHERE i.start_time >= @since
GROUP BY q.query_id,p.plan_id,qt.query_sql_text
ORDER BY weighted_avg_duration_ms DESC;
-- Plan changes/regressions: compare per-plan interval averages; inspect query text and plans before action
DECLARE @reg_since datetimeoffset = DATEADD(day,-7,SYSDATETIMEOFFSET());
WITH per_plan AS (
 SELECT p.query_id,p.plan_id,MIN(i.start_time) first_seen,MAX(i.end_time) last_seen,
        SUM(rs.count_executions) executions,
        SUM(rs.avg_duration*rs.count_executions)/NULLIF(SUM(rs.count_executions),0) avg_duration_us,
        SUM(rs.avg_cpu_time*rs.count_executions)/NULLIF(SUM(rs.count_executions),0) avg_cpu_us,
        SUM(rs.avg_logical_io_reads*rs.count_executions)/NULLIF(SUM(rs.count_executions),0) avg_reads
 FROM sys.query_store_plan p
 JOIN sys.query_store_runtime_stats rs ON rs.plan_id=p.plan_id
 JOIN sys.query_store_runtime_stats_interval i ON i.runtime_stats_interval_id=rs.runtime_stats_interval_id
 WHERE i.start_time>=@reg_since AND rs.execution_type_desc='Regular'
 GROUP BY p.query_id,p.plan_id
 HAVING SUM(rs.count_executions)>0
), ranked AS (
 SELECT *,ROW_NUMBER() OVER(PARTITION BY query_id ORDER BY avg_duration_us) AS fastest,
          ROW_NUMBER() OVER(PARTITION BY query_id ORDER BY avg_duration_us DESC) AS slowest
 FROM per_plan
)
SELECT f.query_id,f.plan_id AS faster_plan_id,s.plan_id AS slower_plan_id,
       f.avg_duration_us/1000.0 AS faster_avg_ms,s.avg_duration_us/1000.0 AS slower_avg_ms,
       s.avg_duration_us/NULLIF(f.avg_duration_us,0) AS duration_ratio,
       f.executions AS faster_executions,s.executions AS slower_executions,
       qt.query_sql_text
FROM ranked f JOIN ranked s ON s.query_id=f.query_id AND f.fastest=1 AND s.slowest=1
JOIN sys.query_store_query q ON q.query_id=f.query_id
JOIN sys.query_store_query_text qt ON qt.query_text_id=q.query_text_id
WHERE s.avg_duration_us>f.avg_duration_us*1.5
ORDER BY duration_ratio DESC;

/* 5. Wait stats: since startup/reset; subtract a saved baseline for interval deltas */
SELECT TOP(50) wait_type,waiting_tasks_count,wait_time_ms,signal_wait_time_ms,
       wait_time_ms-signal_wait_time_ms AS resource_wait_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE 'SLEEP%' AND wait_type NOT IN
 ('BROKER_EVENTHANDLER','BROKER_RECEIVE_WAITFOR','BROKER_TASK_STOP','BROKER_TO_FLUSH',
  'CHECKPOINT_QUEUE','CLR_AUTO_EVENT','CLR_MANUAL_EVENT','DIRTY_PAGE_POLL','DISPATCHER_QUEUE_SEMAPHORE',
  'FT_IFTS_SCHEDULER_IDLE_WAIT','HADR_FILESTREAM_IOMGR_IOCOMPLETION','LAZYWRITER_SLEEP','LOGMGR_QUEUE','ONDEMAND_TASK_QUEUE',
  'REQUEST_FOR_DEADLOCK_SEARCH','RESOURCE_QUEUE','SERVER_IDLE_CHECK','SQLTRACE_BUFFER_FLUSH',
  'WAITFOR','XE_TIMER_EVENT','XE_DISPATCHER_WAIT')
ORDER BY wait_time_ms DESC;
-- Latch waits (cumulative); corroborate with latch_class and workload interval
SELECT TOP(30) latch_class,waiting_requests_count,wait_time_ms,
       wait_time_ms/NULLIF(waiting_requests_count,0) AS avg_wait_ms
FROM sys.dm_os_latch_stats WHERE waiting_requests_count>0 ORDER BY wait_time_ms DESC;
-- File I/O since startup: compare deltas across samples, not raw lifetime totals
SELECT DB_NAME(vfs.database_id) database_name,mf.name logical_name,mf.type_desc,mf.physical_name,
       vfs.num_of_reads,vfs.num_of_writes,vfs.io_stall_read_ms,vfs.io_stall_write_ms,
       vfs.io_stall_read_ms/NULLIF(vfs.num_of_reads,0) AS avg_read_stall_ms,
       vfs.io_stall_write_ms/NULLIF(vfs.num_of_writes,0) AS avg_write_stall_ms,
       vfs.num_of_bytes_read,vfs.num_of_bytes_written
FROM sys.dm_io_virtual_file_stats(NULL,NULL) vfs
JOIN sys.master_files mf ON mf.database_id=vfs.database_id AND mf.file_id=vfs.file_id
ORDER BY vfs.io_stall_read_ms+vfs.io_stall_write_ms DESC;
-- Scheduler pressure snapshot
SELECT scheduler_id,cpu_id,status,runnable_tasks_count,work_queue_count,
       current_tasks_count,active_workers_count,pending_disk_io_count
FROM sys.dm_os_schedulers WHERE status='VISIBLE ONLINE' ORDER BY runnable_tasks_count DESC;
-- CPU history from system_health scheduler-monitor ring buffer
;WITH rb AS (
 SELECT CONVERT(xml,record) x
 FROM sys.dm_xe_session_targets t JOIN sys.dm_xe_sessions s ON s.address=t.event_session_address
 WHERE s.name='system_health' AND t.target_name='ring_buffer'
), nodes AS (
 SELECT n.value('@timestamp','datetime2') AS utc_time,
        n.query('.') AS rec
 FROM rb CROSS APPLY x.nodes('/RingBufferTarget/event[@name="scheduler_monitor"]') q(n)
)
SELECT TOP(120) utc_time,
       rec.value('(event/data[@name="SystemHealth"]/value/./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]','int') AS sql_process_cpu_pct,
       rec.value('(event/data[@name="SystemHealth"]/value/./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]','int') AS system_idle_pct
FROM nodes ORDER BY utc_time DESC;
-- Performance counter CPU fallback (sample twice externally for rate counters)
SELECT object_name,counter_name,instance_name,cntr_value,cntr_type
FROM sys.dm_os_performance_counters
WHERE counter_name IN ('Process Utilization','System Idle','Batch Requests/sec','SQL Compilations/sec','SQL Re-Compilations/sec');

/* 6. Availability Groups */
SELECT ag.name group_name,ar.replica_server_name,ar.availability_mode_desc,ar.failover_mode_desc,
       ar.failure_condition_level,ar.session_timeout,ars.role_desc,ars.operational_state_desc,
       ars.connected_state_desc,ars.synchronization_health_desc,ars.last_connect_error_description,
       ars.last_connect_error_timestamp
FROM sys.availability_groups ag
JOIN sys.availability_replicas ar ON ar.group_id=ag.group_id
LEFT JOIN sys.dm_hadr_availability_replica_states ars ON ars.replica_id=ar.replica_id
ORDER BY ag.name,ar.replica_server_name;
SELECT ag.name group_name,DB_NAME(drs.database_id) database_name,
       ar.replica_server_name,drs.is_primary_replica,drs.synchronization_state_desc,
       drs.synchronization_health_desc,drs.database_state_desc,
       drs.log_send_queue_size,drs.redo_queue_size,drs.log_send_rate,drs.redo_rate,
       drs.last_commit_time
FROM sys.dm_hadr_database_replica_states drs
JOIN sys.availability_replicas ar ON ar.replica_id=drs.replica_id
JOIN sys.availability_groups ag ON ag.group_id=ar.group_id
ORDER BY ag.name,database_name,ar.replica_server_name;
SELECT ag.name group_name,l.dns_name,l.port,l.is_conformant,l.ip_configuration_string_from_cluster
FROM sys.availability_group_listeners l JOIN sys.availability_groups ag ON ag.group_id=l.group_id;
-- Current primary mapping (execute on any replica; may be NULL if not joined/available)
SELECT ag.name group_name,ar.replica_server_name current_primary
FROM sys.availability_groups ag
JOIN sys.dm_hadr_availability_replica_states ars ON ars.group_id=ag.group_id AND ars.role_desc='PRIMARY'
JOIN sys.availability_replicas ar ON ar.replica_id=ars.replica_id;

/* 7. Dumps, loaded modules, error log. Dump text is on disk; use approved signed reader proc. */
SELECT creation_time,dump_type,dump_type_desc,filename, size_in_bytes
FROM sys.dm_server_memory_dumps ORDER BY creation_time DESC;
SELECT name,file_version,product_version,company,description
FROM sys.dm_os_loaded_modules ORDER BY name;
-- SQL error log (0=current log, 1=archive); xp_readerrorlog requires elevated permission
EXEC master.dbo.xp_readerrorlog 0,1,N'Error',NULL,NULL,NULL,N'desc';
-- Example only: invoke your DBA-owned signed procedure for SQLDump*.txt; path is installation-specific.
-- EXEC master.dbo.ReadSqlDump @DumpFile = N'<approved dump path>';

/* 8. XE deadlocks: system_health and optional RCA session. Inspect event payload XML. */
SELECT 'system_health' session_name,CAST(event_data AS xml) event_xml,
       object_name,event_file
FROM sys.fn_xe_file_target_read_file(
  (SELECT TOP(1) CAST(t.target_data AS xml).value('(EventFileTarget/File/@name)[1]','nvarchar(4000)')
   FROM sys.dm_xe_sessions s JOIN sys.dm_xe_session_targets t ON t.event_session_address=s.address
   WHERE s.name='system_health' AND t.target_name='event_file'),NULL,NULL,NULL)
WHERE object_name='xml_deadlock_report';
-- Replace path with the RCA session's configured event file wildcard.
-- SELECT CAST(event_data AS xml) FROM sys.fn_xe_file_target_read_file(N'<RCA-file-wildcard>',NULL,NULL,NULL);
-- Default trace login failure events (event  Audit Login Failed = 20); trace may be disabled/rolled over.
DECLARE @trace nvarchar(4000)=(SELECT path FROM sys.traces WHERE is_default=1);
IF @trace IS NOT NULL
 SELECT StartTime,LoginName,HostName,ApplicationName,TextData,Error
 FROM sys.fn_trace_gettable(@trace,DEFAULT) WHERE EventClass=20 ORDER BY StartTime DESC;
-- SQL Agent job outcomes (msdb)
SELECT j.name job_name,h.step_id,h.step_name,h.run_status,h.run_date,h.run_time,h.run_duration,h.message
FROM msdb.dbo.sysjobhistory h JOIN msdb.dbo.sysjobs j ON j.job_id=h.job_id
WHERE h.step_id=0 ORDER BY h.instance_id DESC;
SELECT j.name job_name,s.step_id,s.step_name,s.subsystem,s.database_name,s.command
FROM msdb.dbo.sysjobsteps s JOIN msdb.dbo.sysjobs j ON j.job_id=s.job_id ORDER BY j.name,s.step_id;

/* 9. Backup age: run in each database on the replica preferred for backup */
SELECT DB_NAME() database_name,sys.fn_hadr_backup_is_preferred_replica(DB_NAME()) is_preferred_replica,
       MAX(CASE WHEN type='D' THEN backup_finish_date END) last_full_backup,
       MAX(CASE WHEN type='I' THEN backup_finish_date END) last_diff_backup,
       MAX(CASE WHEN type='L' THEN backup_finish_date END) last_log_backup
FROM msdb.dbo.backupset WHERE database_name=DB_NAME();

/* 10. DMV signals useful for an instance baseline */
SELECT servicename,startup_type_desc,status_desc,instant_file_initialization_enabled,
       last_startup_time,service_account,filename
FROM sys.dm_server_services;
SELECT cpu_count,hyperthread_ratio,physical_memory_kb/1024 AS physical_memory_mb,
       committed_kb/1024 AS committed_memory_mb,sqlserver_start_time
FROM sys.dm_os_sys_info;
SELECT name,type_desc,size/128.0 AS size_mb,
       CASE WHEN max_size=-1 THEN NULL ELSE max_size/128.0 END AS max_size_mb,
       physical_name,growth,is_percent_growth
FROM tempdb.sys.database_files ORDER BY file_id;
SELECT name,page_verify_option_desc FROM sys.databases WHERE database_id>4 ORDER BY name;
SELECT d.name,MAX(CASE WHEN h.type='D' THEN h.backup_finish_date END) AS latest_full_backup,
       MAX(CASE WHEN h.type='I' THEN h.backup_finish_date END) AS latest_diff_backup,
       MAX(CASE WHEN h.type='L' THEN h.backup_finish_date END) AS latest_log_backup
FROM sys.databases d LEFT JOIN msdb.dbo.backupset h ON h.database_name=d.name
WHERE d.database_id>4 GROUP BY d.name ORDER BY d.name;
-- dbatools Test-Dba* / Get-Dba* checks and sp_BlitzIndex are operator-run companion checks.

/* 11. Historical activity (post-incident)
   Capture sp_WhoIsActive output once per minute into a DBA-owned table. Include
   capture_time_utc datetime2(3) NOT NULL, plus the installed proc's output columns.
   Exact insert statement depends on the sp_WhoIsActive version/output schema.
   SELECT * FROM DBA.dbo.WhoIsActiveCapture
   WHERE capture_time_utc >= '2026-11-16T02:32:00'
     AND capture_time_utc <  '2026-11-16T02:33:00' ORDER BY capture_time_utc;
*/

/* 12. Capability boundaries
   fan_out_query and <region>-primary endpoint resolution belong in an orchestrator
   (PowerShell/SQL client/connection routing), not a single T-SQL batch.
   run_health_check's dbatools checks are PowerShell checks; retain outputs with host,
   timestamp, check name, severity, and details. read_sql_dump must be a DBA-owned
   signed procedure with tightly constrained file access.
*/
