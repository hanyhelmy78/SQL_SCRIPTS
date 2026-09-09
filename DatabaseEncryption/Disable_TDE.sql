USE master
GO
ALTER DATABASE [AdventureWorksLT2019_CLEAN]
SET ENCRYPTION ON;  
GO  
/* Wait for decryption operation to complete, look for a value of 1 in the query below for column encryption_state */  
USE master;
GO
SELECT 
    d.name AS database_name,
	encryption_state,
    dek.encryptor_type,
    c.name AS cert_name
FROM 
    sys.databases AS d
LEFT OUTER JOIN 
    sys.dm_database_encryption_keys AS dek ON dek.database_id = d.database_id
LEFT OUTER JOIN 
    sys.certificates AS c ON dek.encryptor_thumbprint = c.thumbprint;
/*
REMOVE THE DATABASE FROM AG, THEN RUN BELOW QUERY
*/
USE master
GO
ALTER AVAILABILITY GROUP [AG_TEST2]
REMOVE DATABASE [AdventureWorksLT2019_CLEAN];
GO
USE [AdventureWorksLT2019_CLEAN];  
GO  
DROP DATABASE ENCRYPTION KEY;  
GO
/*
if that didn`t work you might NEED TO DROP THE DATABASE FROM ALL NODES, THEN RESTORE IT FROM A CLEAN BACKUP
*/