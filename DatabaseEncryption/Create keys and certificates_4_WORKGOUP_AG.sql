SELECT * FROM SYS.certificates

-- Create a cert from the master key
USE master;  
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'PassWOrd123!';  
GO  

CREATE CERTIFICATE [VSC-SQL03-Cert]
	--ENCRYPTION BY PASSWORD = 'pGFD4bb925DGvbd2439587y'
    WITH SUBJECT = 'AG Node 03 Certificate',   
    EXPIRY_DATE = '20991231';  
GO

-- Backup the cert and transfer it to AGNode2
BACKUP CERTIFICATE [VSC-SQL03-Cert] TO FILE = 'C:\cert\AGNode3Cert.crt'; --Provide appropriate folder location 
GO

-- Create a certificate that the login uses for authentication
CREATE CERTIFICATE [VSC-SQL03-Cert]  
   AUTHORIZATION AGNode3_User  
   FROM FILE = 'C:\cert\AGNode3Cert.crt'  
GO 

--CREATE or ALTER the mirroring endpoint
ALTER ENDPOINT hadr_endpoint  
   STATE = STARTED  
   AS TCP (  
      LISTENER_PORT=5022  
      , LISTENER_IP = ALL  
   )   
   FOR DATABASE_MIRRORING (   
      AUTHENTICATION = CERTIFICATE [VSC-SQL03-Cert] -- Use the new certificate created in above step
      --, ENCRYPTION = REQUIRED ALGORITHM AES  
      , ROLE = ALL  
   );  
GO

GRANT ALTER ANY AVAILABILITY GROUP TO [NT AUTHORITY\SYSTEM];
GRANT CONNECT SQL TO [NT AUTHORITY\SYSTEM];
GRANT VIEW SERVER STATE TO [NT AUTHORITY\SYSTEM];

/* Cleanup Old SQL Server Database Mirroring Certificates

drop certificate principal_cert -- Provide the expired certificate name
drop certificate mirror_cert -- Provide the expired certificate name
*/