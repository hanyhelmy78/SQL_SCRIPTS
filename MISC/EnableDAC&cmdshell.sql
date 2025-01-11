sp_configure 'remote admin connections', 1
GO

RECONFIGURE
GO

sp_configure 'xp_cmdshell',1
GO

RECONFIGURE
GO