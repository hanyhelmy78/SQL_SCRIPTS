-- http://answers.flyppdevportal.com/categories/sqlserver/sqldisasterrecovery.aspx?ID=7b5d7d7d-1dc0-4ed5-a7ad-49bb913db74a 

WITH Waits
AS (SELECT wait_type, CAST(wait_time_ms / 1000. AS DECIMAL(12, 2)) AS [wait_time_s],
	CAST(100. * wait_time_ms / SUM(wait_time_ms) OVER () AS decimal(12,2)) AS [pct],
	ROW_NUMBER() OVER (ORDER BY wait_time_ms DESC) AS rn
	FROM sys.dm_os_wait_stats WITH (NOLOCK)
	WHERE wait_type NOT IN (N'CLR_SEMAPHORE', N'LAZYWRITER_SLEEP', N'RESOURCE_QUEUE',N'SLEEP_TASK',
			                N'SLEEP_SYSTEMTASK', N'SQLTRACE_BUFFER_FLUSH', N'WAITFOR', N'LOGMGR_QUEUE',
			                N'CHECKPOINT_QUEUE', N'REQUEST_FOR_DEADLOCK_SEARCH', N'XE_TIMER_EVENT',
			                N'BROKER_TO_FLUSH', N'BROKER_TASK_STOP', N'CLR_MANUAL_EVENT', N'CLR_AUTO_EVENT',
			                N'DISPATCHER_QUEUE_SEMAPHORE' ,N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'XE_DISPATCHER_WAIT',
			                N'XE_DISPATCHER_JOIN', N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', N'ONDEMAND_TASK_QUEUE',
			                N'BROKER_EVENTHANDLER', N'SLEEP_BPOOL_FLUSH', N'SLEEP_DBSTARTUP', N'DIRTY_PAGE_POLL',
			                N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',N'SP_SERVER_DIAGNOSTICS_SLEEP')),
Running_Waits 
AS (SELECT W1.wait_type, wait_time_s, pct,
	SUM(pct) OVER(ORDER BY pct DESC ROWS UNBOUNDED PRECEDING) AS [running_pct]
	FROM Waits AS W1)
SELECT wait_type, wait_time_s, pct, running_pct
FROM Running_Waits
WHERE running_pct - pct <= 99
ORDER BY running_pct
OPTION (RECOMPILE);

select COUNT(*) from sys.dm_os_workers

select max_workers_count from sys.dm_os_sys_info;

select AVG(work_queue_count) from sys.dm_os_schedulers 
where status = 'VISIBLE ONLINE'