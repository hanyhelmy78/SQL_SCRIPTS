SELECT CAST(SUM(CASE WHEN blocking_session_id <> 0 
					 THEN 100.00 
				     ELSE 0.00
					 END) / COUNT(*) AS NUMERIC(10, 2)) 
FROM sys.dm_exec_requests 
WHERE database_id = DB_ID();