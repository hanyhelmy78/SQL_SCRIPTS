USE [master];
GO

DECLARE @LoginName SYSNAME;
DECLARE @SQL NVARCHAR(MAX);

DECLARE LoginCursor CURSOR FOR
SELECT name
FROM sys.server_principals
WHERE type IN ('S', 'U', 'G') -- SQL Logins and Windows Logins
AND is_disabled = 0
AND name NOT IN ('sa', '##MS_SQLResourceGroup##', '##MS_SQLAuthenticator##', '##MS_AgentSigningCertificate##') -- Exclude system logins
AND name NOT IN (SELECT name FROM DBADMIN.sys.database_principals WHERE type IN ('S', 'U', 'G')); -- Exclude logins already having a user in DBADMIN

OPEN LoginCursor;

FETCH NEXT FROM LoginCursor INTO @LoginName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'USE [DBADMIN]; 
                CREATE USER [' + @LoginName + '] FOR LOGIN [' + @LoginName + '];
                GRANT INSERT ON [DBADMIN].[dbo].DDLEvents TO [' + @LoginName + '];';
    EXEC sp_executesql @SQL;
    
    FETCH NEXT FROM LoginCursor INTO @LoginName;
END;

CLOSE LoginCursor;
DEALLOCATE LoginCursor;
GO