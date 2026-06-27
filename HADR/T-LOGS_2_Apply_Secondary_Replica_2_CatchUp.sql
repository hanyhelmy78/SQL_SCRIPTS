DECLARE @DatabaseName NVARCHAR(128) = 'SeedingTest'
DECLARE @HardenedLSN NUMERIC(25,0)
SELECT @HardenedLSN = last_hardened_lsn
FROM sys.dm_hadr_database_replica_states drs
JOIN sys.databases d ON drs.database_id = d.database_id
WHERE d.name = @DatabaseName
    AND drs.is_local = 0
SELECT 
    bs.backup_set_id,
    bs.backup_start_date,
    bs.first_lsn,
    bs.last_lsn,
    bmf.physical_device_name AS backup_file,
    ROW_NUMBER() OVER (ORDER BY bs.backup_start_date) AS apply_order,
    'RESTORE LOG ' + QUOTENAME(@DatabaseName) + 
    ' FROM DISK = ' + QUOTENAME(bmf.physical_device_name, '''') + 
    ' WITH NORECOVERY, STATS = 10' AS restore_command
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf 
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = @DatabaseName
    AND bs.type = 'L'
    AND bs.last_lsn >= @HardenedLSN
ORDER BY bs.backup_start_date ASC