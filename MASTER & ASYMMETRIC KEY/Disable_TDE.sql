USE master
GO
ALTER DATABASE [AdventureWorksLT2019]
SET ENCRYPTION OFF;  
GO  
/* Wait for decryption operation to complete, look for a value of  1 in the query below. */  
SELECT encryption_state  
FROM sys.dm_database_encryption_keys;  
GO
-- ANOTHER VERIFICATION:
SELECT
 db.name,
 db.is_encrypted,
 dm.encryption_state,
 dm.percent_complete,
 dm.key_algorithm,
 dm.key_length
FROM
 sys.databases db
 LEFT OUTER JOIN sys.dm_database_encryption_keys dm
 ON db.database_id = dm.database_id;
GO

USE [AdventureWorksLT2019];  
GO  
DROP DATABASE ENCRYPTION KEY;  
GO
