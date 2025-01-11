SELECT 
      database_name = DB_NAME(database_id)
	, total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
    , log_size_mb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
FROM sys.master_files WITH(NOWAIT)
--WHERE DB_NAME(database_id) not in ('tempdb','msdb','master','model')
GROUP BY DB_NAME(database_id)
ORDER BY total_size_mb DESC -- log_size_mb total_size_mb