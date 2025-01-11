-- ================================================================
-- Description: Check if drive has enough space for DB backup
-- ================================================================
/*DECLARE @enoughSpaceForBackupFlag bit
EXEC dbo.DoesDBBackupHaveSpace 'L', @enoughSpaceForBackupFlag OUTPUT

PRINT @enoughSpaceForBackupFlag
IF @enoughSpaceForBackupFlag = 1
   PRINT 'Continue to Backup...'
ELSE 
   PRINT 'Drive Space Problem...'
GO*/
ALTER PROCEDURE dbo.DoesDBBackupHaveSpace (
   @drvLetter VARCHAR (5),
   @enoughSpaceForBackupFlag BIT OUTPUT
   )
AS
BEGIN
   DECLARE @estimatedBackSizeGB INT
   DECLARE @estimatedDriveFreeSpaceMB INT
   DECLARE @dbCheckMessage varchar(80)

   SET NOCOUNT ON

   SET @dbCheckMessage = concat ('Checking database ', DB_NAME ())
   PRINT @dbCheckMessage

   SELECT @estimatedBackSizeGB = round (sum (a.total_pages) * 8192 / SQUARE (1024.0) / 1024, 2)
   FROM sys.partitions p
   JOIN sys.allocation_units a
      ON p.partition_id = a.container_id
   LEFT JOIN sys.internal_tables it
      ON p.object_id = it.object_id

   CREATE TABLE #freespace (drive VARCHAR (5), MBFree DECIMAL (8, 2))

   INSERT INTO #freespace (
      Drive,
      MBFree) EXEC xp_fixeddrives

   SELECT @estimatedDriveFreeSpaceMB = MBFree 
   FROM #freespace
   WHERE drive = @drvLetter

   IF @estimatedBackSizeGB *1024 * 1.1 < @estimatedDriveFreeSpaceMB
      SET @enoughSpaceForBackupFlag = 1
   ELSE
      SET @enoughSpaceForBackupFlag = 0

   SELECT DatabaseName = db_name(),	
      Estimated_Back_Size_GB = @estimatedBackSizeGB,
      Estimated_Drive_Free_Space_MB = @estimatedDriveFreeSpaceMB,
      EnoughSpaceForBackupFlag = @enoughSpaceForBackupFlag

   DROP TABLE #freespace
   SET NOCOUNT OFF
END
GO