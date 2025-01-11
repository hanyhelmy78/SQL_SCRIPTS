USE tempdb
SELECT SUM((allocated_extent_page_count)*1.0/128) AS TempDB_used_data_space_inMB, 
	SUM((unallocated_extent_page_count)*1.0/128) AS TempDB_free_data_space_inMB, 
	SUM(total_page_count*1.0/128) AS Total_TempDB_data_size_inMB 
FROM sys.dm_db_file_space_usage

USE tempdb
SELECT used_log_space_in_bytes*1.0/1024/1024 AS TempDB_used_log_space_inMB,
     (total_log_size_in_bytes- used_log_space_in_bytes)*1.0/1024/1024 AS TempDB_free_log_space_inMB,
     total_log_size_in_bytes*1.0/1024/1024 AS Total_TempDB_log_size_inMB
FROM sys.dm_db_log_space_usage