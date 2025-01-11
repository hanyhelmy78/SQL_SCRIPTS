SELECT SUM(user_object_reserved_page_count)/128.0 AS HowMuchMB
		FROM sys.dm_db_file_space_usage;