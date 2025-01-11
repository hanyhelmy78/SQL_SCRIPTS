SET NOCOUNT ON 
GO 
DECLARE @DBName VARCHAR(255) 
DECLARE @SQL VARCHAR(MAX) 
DECLARE @SQLEXEC VARCHAR(MAX) 
CREATE TABLE #TableVar (DatabaseName varchar(256), permission_name varchar(32), State_desc varchar(10))DECLARE curDatabases CURSOR STATIC FOR SELECT [name] 
FROM master.sys.databases 
--WHERE database_id > 4 
ORDER BY [name] OPEN curDatabases 
FETCH NEXT FROM curDatabases INTO @DBName 
WHILE @@FETCH_STATUS = 0 
BEGIN 
SET @SQL = 'insert into #TableVar SELECT DB_NAME() as DatabaseName,permission_name,state_desc FROM sys.database_permissions where grantee_principal_id = user_id(''''guest'''') AND state = ''''G'''' 
AND type = ''''CO'''' '
SET @SQLEXEC = 'USE ' + QUOTENAME(@DBName) + ';EXEC (''' + @SQL +''')'
EXEC(@SQLEXEC) FETCH NEXT FROM curDatabases INTO @DBName END 
CLOSE curDatabases 
DEALLOCATE curDatabases 
Select * from #TableVar
Drop table #TableVar
GO

--REVOKE CONNECT FROM guest