USE master
GO
SET NOCOUNT ON
GO

SELECT 
  SERVERPROPERTY('SERVERNAME')[Server]
  ,vs.volume_mount_point AS [Drive]
  ,vs.logical_volume_name AS [Drive Name]
  ,(vs.total_bytes/1024/1024/1024) AS [Drive Size GB]
  ,(vs.available_bytes/1024/1024/1024) AS [Drive Free Space GB]
  ,SUM(CASE WHEN f.type = 0 then 1 else 0 END) [Number of Data Files]
  ,SUM(CASE WHEN f.type = 1 then 1 else 0 END) [Number of Logs Files]
  ,CONVERT(VARCHAR(25),GETDATE(),22) [Sample Time]
FROM sys.master_files AS f
CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id) AS vs
GROUP BY vs.volume_mount_point
  ,vs.logical_volume_name
  ,(vs.total_bytes/1024/1024/1024)
  ,(vs.available_bytes/1024/1024/1024)

ORDER BY [Drive Free Space GB] --vs.volume_mount_point;
GO