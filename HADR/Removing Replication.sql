sp_removedbreplication [ABP_SFA_BMB]

sp_adddistributiondb 'distribution'
GO 
sp_adddistpublisher @@servername, 'distribution'
GO
sp_dropdistributor 
GO
exec sp_dropdistpublisher @@servername
GO
exec sp_droppublication 'ABP_PROD'
go

/* THIS WORKED */
EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1
GO

/* DISABLE & RENABLE PUBLISH */
exec sp_replicationdboption @dbname = N'ABP_SFA_BMB', @optname = N'publish', @value = N'false'
exec sp_replicationdboption @dbname = N'ABP_SFA_BMB', @optname = N'publish', @value = N'true'

/* RUN IN THE SUBSCRIBER TO DROP SUBSCRIBTIOB

DECLARE @publication AS sysname;
DECLARE @publisher AS sysname;
DECLARE @publicationDB     AS sysname;
SET @publication = N'ABP_SFA_BMB_PROD';
SET @publisher = 'RUH1SFADB';
SET @publicationDB = N'ABP_SFA_BMB';

EXEC sp_droppullsubscription 
  @publisher = @publisher, 
  @publisher_db = @publicationDB, 
  @publication = @publication;
GO */