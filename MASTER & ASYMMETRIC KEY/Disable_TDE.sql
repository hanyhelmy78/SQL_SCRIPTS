USE master
GO
ALTER DATABASE [AdventureWorksLT2019]
SET ENCRYPTION OFF;  
GO  
/* Wait for decryption operation to complete, look for a value of  1 in the query below. */  
SELECT encryption_state  
FROM sys.dm_database_encryption_keys;  
GO  
USE [AdventureWorksLT2019];  
GO  
DROP DATABASE ENCRYPTION KEY;  
GO