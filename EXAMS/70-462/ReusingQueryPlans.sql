SELECT CAST(([num_of_bytes_written] / 1048576.0) AS NUMERIC(10,2)) AS [MBs]
FROM sys.dm_io_virtual_file_stats(DB_ID('TestML'),2);

select * from sys.dm_exec_query_stats

-- query to determine which statements are not reusing query plans
SELECT b.[cacheobjtype], b.[objtype], b.[usecounts],a.[dbid], a.[objectid], b.[size_in_bytes], a.[text]
FROM sys.dm_exec_cached_plans as b
CROSS APPLY sys.dm_exec_sql_text(b.[plan_handle]) AS a
ORDER BY [usecounts] DESC