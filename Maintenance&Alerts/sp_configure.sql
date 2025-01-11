sp_configure 'show advanced options',1
go
sp_configure 'backup checksum default',1
GO
sp_configure 'backup compression default' ,1
GO
sp_configure 'clr enabled',1
go
sp_configure 'Database Mail XPs',1
go
sp_configure 'Ole Automation Procedures',1
go
sp_configure 'optimize for ad hoc workloads',0
go
sp_configure 'remote admin connections',1
go
sp_configure 'xp_cmdshell',0
go
sp_configure 'Agent XPs',1
go
sp_configure 'remote access',0
go
sp_configure 'remote login timeout (s)',10
go
sp_configure 'c2 audit mode',0
go
Reconfigure
go