SELECT DISTINCT dovs.logical_volume_name AS LogicalName,
 dovs.volume_mount_point AS Drive,
 Round(CONVERT(float,dovs.available_bytes/1048576.0/1024.0),2) AS FreeSpaceInGB,
 Round(CONVERT(float,dovs.total_bytes/1024.0/1024.0/1024.0),0) AS TotalSpaceGB
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInGB 
GO

-- sp_fixeddrives

--SP_CONFIGURE 'Ole Automation Procedures',1
--GO
--RECONFIGURE WITH OVERRIDE
--GO