DECLARE @NumPagesPerGB float = 128 * 1024;
SELECT file_id AS FileId 
 , size / @NumPagesPerGB AS AllocatedSpaceGB  
 , ROUND(CAST(FILEPROPERTY(name, 'SpaceUsed') AS float)/@NumPagesPerGB,3) AS UsedSpaceGB 
 , ROUND((size-CAST(FILEPROPERTY(name, 'SpaceUsed') AS float))/@NumPagesPerGB,3) AS FreeSpaceGB 
 , ROUND(max_size / @NumPagesPerGB,3) AS MaxSizeGB
 , ROUND(CAST(size - FILEPROPERTY(name, 'SpaceUsed') AS float)*100/size,3) AS UnusedSpacePercent
FROM sys.database_files
WHERE type_desc = 'ROWS' 
ORDER BY file_id