-- Get VLF Counts for all databases on the instance (Query 34) (VLF Counts)
SELECT db.[name] AS [Database Name], li.[VLF Count]
FROM sys.databases AS db WITH (NOLOCK)
CROSS APPLY (SELECT file_id, COUNT(*) AS [VLF Count]
		     FROM sys.dm_db_log_info (db.database_id)
			 GROUP BY file_id) AS li
ORDER BY li.[VLF Count] DESC OPTION (RECOMPILE);
/*
 High VLF counts can affect write performance to the log file
 and they can make full database restores and crash recovery take much longer
 Try to keep your VLF counts under 200 in most cases (depending on log file size)

 sys.dm_db_log_info (Transact-SQL)
 https://bit.ly/3jpmqsd

 sys.databases (Transact-SQL)
 https://bit.ly/2G5wqaX

 SQL Server Transaction Log Architecture and Management Guide
 https://bit.ly/2JjmQRZ

 VLF Growth Formula (SQL Server 2014 and newer)
 If the log growth increment is less than 1/8th the current size of the log
		Then:            1 new VLF
 Otherwise:
		Up to 64MB:      4 new VLFs
		64MB to 1GB:     8 new VLFs
		More than 1GB:  16 new VLFs	
*/