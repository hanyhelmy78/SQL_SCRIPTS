-- Get total buffer usage by database for current instance

SELECT DB_NAME(database_id) AS [Database Name],
COUNT(*) * 8/1024.0 AS [Cached Size (MB)]
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4 -- system databases
AND database_id <> 32767 -- ResourceDB
GROUP BY DB_NAME(database_id)    
ORDER BY [Cached Size (MB)] DESC OPTION (RECOMPILE);

SELECT db = DB_NAME(t.dbid), plan_cache_MB = SUM(size_in_bytes/1024)/1024
FROM sys.dm_exec_cached_plans AS p
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) AS t
WHERE t.dbid < 32767
GROUP BY t.dbid
ORDER BY plan_cache_MB DESC;