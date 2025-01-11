-- SQL Server Performance Tuning Fast Track Video Course
-- https://www.SQLMaestros.com

-- 3_Module_3_The_Awesome_Foursome_CPU_Memory_IO_Tempdb
--- 3_1_CPU_Troubleshooting
---- 3_Reactive
----- 2_CPU_Usage_History.sql

SELECT TOP 20
SUBSTRING(st.text, ( qs.statement_start_offset / 2 ) + 1, ( ( CASE qs.statement_end_offset
		WHEN -1 THEN DATALENGTH(st.text)
		ELSE qs.statement_end_offset
		END - qs.statement_start_offset ) / 2 ) + 1) AS QueryText, 
		query_plan,
total_worker_time / execution_count AS AvgCPUCost ,
	total_worker_time AS TotalCPUcost ,
	total_elapsed_time / execution_count AS AvgDuration ,
	total_elapsed_time AS TotalDuration ,
	total_logical_reads / execution_count AS AvgReads ,
	total_logical_reads AS TotalReads ,
	execution_count ,
	qs.creation_time AS plan_creation_time,
	qs.last_execution_time
    FROM sys.dm_exec_query_stats AS qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
        CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
	/* Sorting options - uncomment the one you'd like to use: */
    --ORDER BY TotalReads DESC;
    --ORDER BY TotalCPU DESC;
    ORDER BY TotalDuration DESC;
    --ORDER BY execution_count DESC;
GO
-- Thank you :)
-- SQL Server Performance Tuning Fast Track Video Course
-- https://www.SQLMaestros.com