SET IDENTITY_INSERT ServerConnections ON;
SET IDENTITY_INSERT ServerConnections OFF;

DBCC CHECKIDENT(Client_Asset_Validations_Log, RESEED, 0);