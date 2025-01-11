SELECT name,is_read_committed_snapshot_on FROM sys.databases WHERE is_read_committed_snapshot_on = 1
 
EXEC sp_resetstatus ''
GO
 
ALTER DATABASE  SET SINGLE_USER WITH ROLLBACK IMMEDIATE
go
 
ALTER DATABASE  SET READ_COMMITTED_SNAPSHOT ON;
go
 
ALTER DATABASE  SET MULTI_USER
go
-------------------------------------------------------------- 
EXEC sp_resetstatus ''
GO
 
ALTER DATABASE  SET SINGLE_USER WITH ROLLBACK IMMEDIATE
go
 
ALTER DATABASE  SET READ_COMMITTED_SNAPSHOT ON;
go
 
ALTER DATABASE  SET MULTI_USER
go
---------------------------------------------------------------
EXEC sp_resetstatus ''
GO
 
ALTER DATABASE  SET SINGLE_USER WITH ROLLBACK IMMEDIATE
go

ALTER DATABASE  SET READ_COMMITTED_SNAPSHOT ON;
go
 
ALTER DATABASE  SET MULTI_USER
go
-------------------------------------------------------------- 