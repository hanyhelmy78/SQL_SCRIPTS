SET NOCOUNT ON;
DECLARE @db SYSNAME, @user NVARCHAR(MAX);
IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp;
CREATE TABLE #tmp (DBName SYSNAME NULL, UserName NVARCHAR(MAX));
exec sp_MsforEachDB '
INSERT INTO #tmp
SELECT ''?'', dp.name AS user_name 
FROM [?].sys.database_principals AS dp 
LEFT JOIN sys.server_principals AS sp ON dp.SID = sp.SID 
WHERE sp.SID IS NULL 
AND authentication_type_desc = ''INSTANCE''
AND dp.name IN (SELECT name COLLATE database_default FROM sys.server_principals);'

DECLARE Orphans CURSOR FOR
SELECT DBName, UserName FROM #tmp;

OPEN Orphans
FETCH NEXT FROM Orphans INTO @db, @user

WHILE @@FETCH_STATUS = 0
BEGIN
 DECLARE @Command NVARCHAR(MAX)
 SET @Command = N'USE ' + QUOTENAME(@db) + N'; ALTER USER ' + QUOTENAME(@user) + N' WITH LOGIN = ' + QUOTENAME(@user)
 PRINT @Command;
 EXEC (@Command);

 FETCH NEXT FROM Orphans INTO @db, @user
END

CLOSE Orphans
DEALLOCATE Orphans