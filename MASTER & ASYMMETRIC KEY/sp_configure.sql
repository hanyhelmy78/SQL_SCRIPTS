sp_configure 'show advanced options',1
go

reconfigure with override
go

--sp_configure 'clr enabled',1
--go

sp_configure 'Database Mail XPs',1
go

sp_configure 'Ole Automation Procedures',1
go

sp_configure 'optimize for ad hoc workloads',1
go

sp_configure 'remote admin connections',1
go

reconfigure with override
go