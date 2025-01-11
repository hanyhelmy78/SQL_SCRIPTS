USE [master]
GO
CREATE PROC dbo.sp_fixeddrives
WITH ENCRYPTION
AS
BEGIN
 SET NOCOUNT ON 
 -----Reporting Drive details ....
 select LDD.DriveLetter ,[VolumeName] ,[FileSystem]  
 ,CAST(TotalSize/1024.0/1024/1024.0 AS DECIMAL(10,2)) [Capacity_GB]
 ,CAST(FreeSpace/1024.0/1024/1024.0 AS DECIMAL(10,2)) [FreeSpace_GB]
 ,CAST((CAST(FreeSpace/1024.0/1024/1024.0 AS DECIMAL(10,2))/CAST(TotalSize/1024.0/1024/1024.0 AS DECIMAL(10,2)) ) *100 AS DECIMAL(10,2)) [Free %]
 , ISNULL( DBFiles.DataSize_GB,0) DataSize_GB,ISNULL( DBFiles.LogSize_GB,0) LogSize_GB
 from master.[dbo].[ufn_LogicalDiskDrives]() LDD
 full outer join 
 (
 select ISNULL(DF.DriveLetter, LF.DriveLetter) DriveLetter,  DF.DataSize_GB, LF.LogSize_GB from
  (
   select left(physical_name, 1) DriveLetter, CAST(sum(size)/128.0/1024 AS DECIMAL(10,2)) DataSize_GB
   from sys.master_files
   where type_desc='ROWS'
   group by left(physical_name, 1), type_desc 
   ) DF
  full outer join 
  (
   select left(physical_name, 1) DriveLetter, CAST(sum(size)/128.0/1024  AS DECIMAL(10,2)) LogSize_GB
   from sys.master_files 
   where type_desc='LOG'
   group by left(physical_name, 1), type_desc
   ) LF
  on DF.DriveLetter=LF.DriveLetter
  
 )  DBFiles
 ON DBFiles.DriveLetter =LDD.DriveLetter
 SET NOCOUNT OFF
END
go

USE [master]
GO
EXEC sys.sp_MS_marksystemobject 'sp_fixeddrives'