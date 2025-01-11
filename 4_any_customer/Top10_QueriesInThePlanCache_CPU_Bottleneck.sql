SELECT TOP 10
qs.total_worker_time / execution_count AS avg_worker_time,
execution_count,
qs.total_logical_reads,
qs.total_logical_writes,
--substring (st.text, (qs.statement_start_offset / 2) + 1,--( ( CASE qs.statement_end_offset WHEN -1--THEN datalength (st.text)--ELSE qs.statement_end_offset END--- qs.statement_start_offset)/ 2)+ 1)--AS statement_text,
 text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text (qs.sql_handle) AS st
ORDER BY avg_worker_time DESC
--ORDER BY qs.total_logical_reads DESC -- logical reads
--ORDER BY qs.total_logical_writes DESC -- logical writes