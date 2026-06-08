-- 1. Backup all user databases

-- Backup all user databases
EXEC sp_MSforeachdb '
IF ''?'' NOT IN (''master'', ''model'', ''msdb'', ''tempdb'')
BEGIN
    DECLARE @backupFile NVARCHAR(500)
    SET @backupFile = ''C:\SQLBackups\?_backup.bak''
    BACKUP DATABASE [?] TO DISK = @backupFile WITH INIT, COMPRESSION, STATS = 10
END'


-- 2. Restore databases from .bak files

-- Restore a database from .bak file
RESTORE DATABASE [YourDatabaseName]
FROM DISK = 'C:\SQLBackups\YourDatabaseName_backup.bak'
WITH MOVE 'YourDatabaseName' TO 'C:\SQLData\YourDatabaseName.mdf',
     MOVE 'YourDatabaseName_log' TO 'C:\SQLLogs\YourDatabaseName_log.ldf',
     REPLACE, STATS = 10;


-- 3. Script out logins

-- Script out SQL Server logins
SELECT 'CREATE LOGIN [' + sp.name + '] WITH PASSWORD = ' + CONVERT(VARCHAR(MAX), sl.password_hash, 1) + ', CHECK_POLICY = OFF;'
FROM sys.sql_logins sl
JOIN sys.server_principals sp ON sl.principal_id = sp.principal_id
WHERE sp.name NOT LIKE '##%' AND sp.name NOT LIKE 'NT AUTHORITY%' AND sp.name NOT LIKE 'NT SERVICE%';


-- 4. Script out SQL Agent jobs

-- Script out SQL Agent jobs using SQL Server Management Studio (SSMS)
-- Alternatively, use the following to list jobs
SELECT name, description, date_created, date_modified
FROM msdb.dbo.sysjobs;
-- For full scripting, use SSMS or SQL Server Management Objects (SMO) in PowerShell


-- 5. Check and update compatibility levels

-- Check and update compatibility level for all user databases
DECLARE @dbName NVARCHAR(128)
DECLARE db_cursor CURSOR FOR
SELECT name FROM sys.databases WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @dbName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = 'ALTER DATABASE [' + @dbName + '] SET COMPATIBILITY_LEVEL = 160'
    EXEC sp_executesql @sql
    FETCH NEXT FROM db_cursor INTO @dbName
END

CLOSE db_cursor
DEALLOCATE db_cursor
