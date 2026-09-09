-- On Primary Replica (before enabling TDE)
-- 1. Create Master Key if not exists
USE master
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<maintain_strong_password>';
GO

-- 2. Create Certificate
CREATE CERTIFICATE TDE_Cert
WITH SUBJECT = 'TDE Certificate for AG Databases',
EXPIRY_DATE = '2099-12-31'
GO

-- 3. Backup Certificate and Private Key
BACKUP CERTIFICATE TDE_Cert
TO FILE = 'C:\Certificates\TDE_Cert.cer'
WITH PRIVATE KEY (
    FILE = 'C:\Certificates\TDE_Cert_PrivateKey.pvk',
    ENCRYPTION BY PASSWORD = '<different_password_for_backup>');
GO
/*
Copy the certificate files to all secondary replicas, then:
On EACH Secondary Replica (before enabling TDE on primary)
1. Create Master Key if not exists 
*/

USE master
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<same_key_pass>';
GO
-- 2. Restore Certificate on ALL secondaries
CREATE CERTIFICATE TDE_Cert -- same name as primary cert
FROM FILE = 'C:\Certificates\TDE_Cert.cer'
WITH PRIVATE KEY (
    FILE = 'C:\Certificates\TDE_Cert_PrivateKey.pvk',
    DECRYPTION BY PASSWORD = '<same_backup_pass>');
GO

-- Verify certificate exists on all replicas
SELECT * FROM sys.certificates; -- WHERE name = 'TDE_Cert';

-- Check certificate thumbprint matches across replicas
SELECT thumbprint FROM sys.certificates WHERE name = 'TDE_Cert';