DECLARE @databaseName sysname 
DECLARE @backupStartDate datetime 
DECLARE @backup_set_id_start INT 
DECLARE @backup_set_id_end INT 
DECLARE @dbname varchar(50)
DECLARE C CURSOR FOR SELECT name FROM master..sysdatabases WHERE name NOT IN ('master','tempdb','model','msdb')

OPEN C
FETCH NEXT FROM C INTO @dbname
WHILE @@FETCH_STATUS = 0
BEGIN
 ---PRINT 'EXECUTE YOUR PROCEDURE HERE WITH THE db NAME ' + @dbname
-- set database to be used 
SET @databaseName = '@dbname'  

FETCH NEXT FROM C INTO @dbname

SELECT @backup_set_id_start = MAX(backup_set_id)  
FROM  msdb.dbo.backupset  
WHERE database_name = @dbname AND type = 'D' 

SELECT @backup_set_id_end = MIN(backup_set_id)  
FROM  msdb.dbo.backupset  
WHERE database_name = @dbname AND type = 'D' 
AND backup_set_id > @backup_set_id_start 

IF @backup_set_id_end IS NULL SET @backup_set_id_end = 999999999 
SELECT backup_set_id, 'RESTORE DATABASE ' + @dbname + ' FROM DISK = '''  
               + mf.physical_device_name + ''' WITH NORECOVERY' AS Query
FROM    msdb.dbo.backupset b, 
        msdb.dbo.backupmediafamily mf 
WHERE    b.media_set_id = mf.media_set_id 
           AND b.database_name = @dbname 
          AND b.backup_set_id = @backup_set_id_start 
UNION 
SELECT backup_set_id, 'RESTORE LOG ' + @dbname + ' FROM DISK = '''  
     + mf.physical_device_name + ''' WITH NORECOVERY' 
FROM    msdb.dbo.backupset b, 
        msdb.dbo.backupmediafamily mf 
WHERE    b.media_set_id = mf.media_set_id 
     AND b.database_name = @dbname 
     AND b.backup_set_id >= @backup_set_id_start AND b.backup_set_id < @backup_set_id_end 
     AND b.type = 'L'       

UNION 
SELECT 999999999 AS backup_set_id, 'RESTORE DATABASE ' + @dbname + ' WITH NORECOVERY' AS Query
ORDER BY backup_set_id

END
CLOSE C
DEALLOCATE C