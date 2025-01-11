/* number of runnable tasks, the lower the better. A high number of runnable tasks, like a high signal wait time, indicate that there is not enough CPU for the current query load */
SELECT scheduler_id ,
current_tasks_count ,
runnable_tasks_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255

/* Identify Visible Online Cores Count */
SELECT COUNT(*) as vCores
FROM sys.dm_os_schedulers
WHERE status = N'VISIBLE ONLINE';
GO

/* how many threads are currently exist in the instance */
select count (*) '#of_worker_threads ' from sys.dm_os_workers
/* #OF_active_sessions */
SELECT COUNT(*) '#of_active_sessions' FROM sys.dm_exec_requests
/* the possible maximum workers */
select max_workers_count from sys.dm_os_sys_info

/* If the Number of active sessions in SQL Server equal to the number of worker threads, decrease the number of connections or increase the max worker threads value
https://www.sqlskills.com/help/waits/threadpool/
*/