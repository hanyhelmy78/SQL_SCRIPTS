USE [master]
GO
CREATE FUNCTION [dbo].[ufn_LogicalDiskDrives]()
RETURNS @DriveList Table
  (
   [DriveLetter]  CHAR(1)
  ,[VolumeName]  VARCHAR(255)
  ,[FileSystem]  VARCHAR(50)
  ,[TotalSize] BIGINT
  ,[AvailableSpace]   BIGINT
  ,[FreeSpace] BIGINT 
  )
AS
BEGIN
  DECLARE @DriveLetter_ASCII_Code  INT
  DECLARE @FileSystemInstance  INT
  DECLARE @DriveCount  INT
  DECLARE @DriveCollection  INT
  DECLARE @Drive  INT
  DECLARE @Property  NVARCHAR(100)    
  DECLARE @DriveLetter  VARCHAR(1)  
  DECLARE @TotalSize BIGINT
  DECLARE @AvailableSpace  BIGINT
  DECLARE @FreeSpace  BIGINT  
  DECLARE @FileSystem VARCHAR(128)
  DECLARE @VolumeName VARCHAR(128)
  DECLARE @IsReady VARCHAR(5)
  
  --Creating a File System Object for getting files or disk info.
  exec sp_OACreate 'Scripting.FileSystemObject', @FileSystemInstance OUT
  --Getting the collection of drives
  exec sp_OAGetProperty @FileSystemInstance,'Drives', @DriveCollection OUT
  --Getting the count of drives from collection
  exec sp_OAGetProperty @DriveCollection,'Count', @DriveCount OUT

  --starting from Drive "A" (ASCII 65) 
  SET @DriveLetter_ASCII_Code = 65
  --to "Z" (ASCII 90)
  WHILE @DriveLetter_ASCII_Code <= 90
  BEGIN
  ---Creating the instance drive from Drive Collection 
        SET @Property = 'item("'+CHAR(@DriveLetter_ASCII_Code)+'")'
        exec sp_OAGetProperty @DriveCollection,@Property, @Drive OUT
  -- Getting the drive letter property
        exec sp_OAGetProperty @Drive,'DriveLetter', @DriveLetter OUT

  IF @DriveLetter = CHAR(@DriveLetter_ASCII_Code)
        BEGIN   
        -- Getting more properties from each drive   
     exec sp_OAGetProperty @Drive,'VolumeName', @VolumeName OUT 
     exec sp_OAGetProperty @Drive,'FileSystem', @FileSystem OUT
     exec sp_OAGetProperty @Drive,'TotalSize', @TotalSize OUT 
              exec sp_OAGetProperty @Drive,'AvailableSpace', @AvailableSpace OUT
              exec sp_OAGetProperty @Drive,'FreeSpace', @FreeSpace OUT          
              exec sp_OAGetProperty @Drive,'IsReady'  , @IsReady OUT; 
            
   IF @IsReady='True'
     INSERT INTO @DriveList ( [DriveLetter],[TotalSize], [AvailableSpace],[FreeSpace],[FileSystem] ,[VolumeName] )
     VALUES( @DriveLetter,@TotalSize,@AvailableSpace,@FreeSpace,@FileSystem,@VolumeName)
                             
            END
   -- forward next drive
            SET @DriveLetter_ASCII_Code = @DriveLetter_ASCII_Code +1
  END 
  
  EXEC sp_OADestroy @Drive 
  EXEC sp_OADestroy @DriveCollection

  RETURN
END