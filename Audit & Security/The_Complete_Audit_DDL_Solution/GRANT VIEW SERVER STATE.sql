USE master;
GO

DECLARE @LoginName SYSNAME;

DECLARE login_cursor CURSOR FOR
SELECT name
FROM sys.server_principals
WHERE type IN ('S', 'U', 'G') -- S = SQL Login, U = Windows Login, G = Windows Group
AND is_disabled = 0
AND name NOT IN ('sa', 'public', '##MS_SQLResourceGroup##', '##MS_SQLServerDTSUser##', '##MS_SQLReplicationGroup##', '##MS_SQLServerMonitorGroup##', '##MS_AgentReaderRole##', '##MS_AgentUserRole##', '##MS_AgentWriterRole##', '##MS_PolicyAdministratorRole##', '##MS_DatabaseManager##', '##MS_ServerStateManager##', '##MS_ServerStateReader##', '##MS_ServerStateManager##','distributor_admin', 'NT AUTHORITY\SYSTEM', 'NT Service\MSSQLSERVER', 'NT SERVICE\SQLSERVERAGENT', 'NT SERVICE\SQLTELEMETRY', 'NT SERVICE\SQLWriter', 'NT SERVICE\Winmgmt');

OPEN login_cursor;
FETCH NEXT FROM login_cursor INTO @LoginName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Check if the login already has VIEW SERVER STATE permission to avoid errors
    IF NOT EXISTS (SELECT 1 FROM sys.server_permissions WHERE grantee_principal_id = (SELECT principal_id FROM sys.server_principals WHERE name = @LoginName) AND permission_name = 'VIEW SERVER STATE')
    BEGIN
        EXEC('GRANT VIEW SERVER STATE TO [' + @LoginName + ']');
        PRINT 'Granted VIEW SERVER STATE to login: ' + @LoginName;
    END
    ELSE
    BEGIN
        PRINT 'Login already has VIEW SERVER STATE: ' + @LoginName;
    END
    FETCH NEXT FROM login_cursor INTO @LoginName;
END

CLOSE login_cursor;
DEALLOCATE login_cursor;
GO