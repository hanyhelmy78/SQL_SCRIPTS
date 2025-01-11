-- table for collecting data
CREATE TABLE #x([login] SYSNAME, db SYSNAME, error INT);

-- table of logins we care about today
DECLARE @logins TABLE([login] SYSNAME);
INSERT @logins([login]) VALUES(N'hany.helmy'),(N'HmgDbUser'),(N'PharmaUser'),('Farrukh');

-- build SQL commands for read attempts to each online db
DECLARE @sql NVARCHAR(MAX) = N'', @cmd NVARCHAR(MAX) = N'';

SELECT @sql += N'
 BEGIN TRY
  INSERT #x SELECT TOP (1) SUSER_SNAME(),N''' + REPLACE(name,'''','''''')
    + N''',0 FROM ' + QUOTENAME(name) + N'.sys.all_objects;
 END TRY
 BEGIN CATCH
   INSERT #x SELECT SUSER_SNAME(),N''' + REPLACE(name,'''','''''') 
     + ''', ERROR_NUMBER();
 END CATCH;' FROM sys.databases
 WHERE [state] = 0;

SELECT @cmd += N'
  EXECUTE AS LOGIN = N''' 
   + REPLACE([login], '''', '''''') + N''';
  ' + @sql + N'
  REVERT;' FROM @logins;

EXEC [master].sys.sp_executesql @cmd;

-- report
SELECT [login], [db], [Access?] = CASE error
  WHEN 0   THEN 'Yes'
  WHEN 229 THEN 'Access denied on sys.all_objects'
  WHEN 916 THEN 'Cannot connect to database'
  ELSE 'No - ' + CONVERT(VARCHAR(11), error) END
FROM #x ORDER BY [login],db;
GO

--DROP TABLE #x;