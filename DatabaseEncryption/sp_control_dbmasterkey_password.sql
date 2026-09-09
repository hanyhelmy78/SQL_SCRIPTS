CREATE DATABASE [DBMKDemo]
GO

ALTER DATABASE [DBMKDemo] SET RECOVERY FULL
GO

BACKUP DATABASE [DBMKDemo] TO DISK='C:\SQLBackup\DBMKDemo.BAK' WITH INIT;
GO

USE [DBMKDemo]
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD='$t0ngP@$$word!!12345';
GO

EXECUTE sp_control_dbmasterkey_password @db_name = N'DBMKDemo', @password = N'$t0ngP@$$word!!12345', @action = N'add'
GO

SELECT c.name AS credential_name,
	d.name AS database_name,
	c.create_date,
	c.modify_date,
	c.credential_identity
FROM sys.credentials AS c
INNER JOIN sys.master_key_passwords AS mkp on c.credential_id = mkp.credential_id
INNER JOIN sys.database_recovery_status AS drs ON mkp.family_guid = drs.family_guid
INNER JOIN sys.databases AS d on drs.database_id = d.database_id
WHERE d.name = N'DBMKDemo'
GO

/* Cleanup
ALTER DATABASE [DBMKDemo] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE [DBMKDemo]
GO

EXECUTE sp_control_dbmasterkey_password @db_name = N'DBMKDemo', @password = N'$t0ngP@$$word!!12345', @action = N'drop'
GO

*/