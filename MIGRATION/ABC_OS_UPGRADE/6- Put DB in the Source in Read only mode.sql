SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
ALTER DATABASE  SET SINGLE_USER WITH rollback immediate
GO
ALTER DATABASE  SET Read_only WITH rollback immediate
GO 
ALTER DATABASE  SET MULTI_USER WITH rollback immediate
GO
