SELECT TOP 10 
       qt.TEXT AS 'SP Name',
       SUBSTRING(qt.text, qs.statement_start_offset/2, CASE WHEN (qs.statement_end_offset = -1) THEN LEN(qt.text) ELSE (qs.statement_end_offset - qs.statement_start_offset)/2 END) AS actual_query,
       qs.execution_count AS 'Execution Count',
       qs.total_worker_time/qs.execution_count AS 'AvgWorkerTime',
       qs.total_worker_time AS 'TotalWorkerTime',
       qs.total_physical_reads AS 'PhysicalReads',
       qs.creation_time 'CreationTime',
       qs.execution_count/DATEDIFF(Second, qs.creation_time, GETDATE()) AS 'Calls/Second'
  FROM sys.dm_exec_query_stats AS qs
  CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
 WHERE qt.dbid = (SELECT dbid
                  FROM sys.sysdatabases
                  WHERE name = 'ABP_SFA_BMB')
ORDER BY qs.total_physical_reads DESC