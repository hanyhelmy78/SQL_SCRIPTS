-- GRANT THE DATABASE ENGINE SERVICE ACCOUNT FULL CONTROL ON THE BACKUP LOCATION ***

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'xp_cmdshell',1
GO
RECONFIGURE
GO
EXEC XP_CMDSHELL 'net use z: \\10.10.241.5\Backup'

/*
EXEC XP_CMDSHELL 'net use'

exec xp_cmdshell 'net use G: /delete'
*/