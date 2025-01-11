-- Create login HmgEncUser 
USE [master] -- USE MASTER 4 THE SECONDARY REPLICA TO CREATE THE KEY, CERTIFICATE, AND THE SYMMETRIC KEY
go

-- 4 FIRST TIME INSTALLATION:
--DROP MASTER KEY 
-- THIS IS 2 BE RUN WHEN DR SITE IS THE PRIMARY REPLICA
CREATE MASTER KEY ENCRYPTION
BY PASSWORD = 'pepsi-123'

--DROP CERTIFICATE EncryptConCert
CREATE CERTIFICATE EncryptConCert
WITH SUBJECT = 'ConnectionEncryption'

--DROP SYMMETRIC KEY AppConKey
CREATE SYMMETRIC KEY AppConKey
WITH ALGORITHM = TRIPLE_DES ENCRYPTION
BY CERTIFICATE EncryptConCert

-- 4 MODIFING THE EXISTING APP CONNECTION STRINGS
--Delete from SEC_AppConnection
--GO 

--ALTER TABLE SEC_AppConnection
--DROP COLUMN EncryptedConInfo
--GO

ALTER TABLE SEC_AppConnection
ADD ConString Varchar(1000) -- ConnInfo 4 BAH & ConString 4 RAYYAN
GO

DELETE FROM SEC_AppConnection

INSERT INTO SEC_AppConnection (ConKey,ConString)
SELECT 'HISGENX','data source=10.70.100.104;initial catalog=HISGENX;User ID=HmGDbUser;Password=HmG2569!eS;persist security info=False;packet size=4096'
UNION ALL
SELECT 'PHARMAKON','data source=10.70.100.104;initial catalog=PHARMAKON;User ID=pharmauser;Password=Pe2569!eS;persist security info=False;packet size=4096'
UNION ALL
SELECT 'SECURITY','data source=10.70.100.104;initial catalog=SENTRY;User ID=HmgSentryUser;Password=HmgSentryUser;persist security info=False;packet size=4096'
UNION ALL
SELECT 'MEDICAL_RECORD','data source=10.70.100.104;initial catalog=HISGENX_MEDICALRECORD;User ID=HmgDbUser;Password=HmG2569!eS;persist security info=False;packet size=4096'
UNION ALL
SELECT 'WASEEL','data source=10.70.100.104;initial catalog=WSLMIDTABLES;User ID=HmgDbUser;Password=HmG2569!eS;persist security info=False;packet size=4096'
UNION ALL
SELECT 'CENTER','data source=10.10.10.162;initial catalog=HISGENX;User ID=HmgDbUser;Password=HmG2569!eS;persist security info=False;packet size=4096'
UNION ALL
SELECT 'GMRS','data source=10.10.10.162;initial catalog=GMRS;User ID=HmgDbUser;Password=HmG2569!eS;persist security info=False;packet size=4096'
UNION ALL
SELECT 'REPORT','data source=10.70.100.104;initial catalog=HISGENX;User ID=HmgDbReader;Password=Hmg(!*&&Reader;persist security info=False;packet size=4096'
GO

--ALTER TABLE SEC_AppConnection
--ADD EncryptedConInfo VARBINARY(MAX)
--GO 

OPEN MASTER KEY DECRYPTION
BY PASSWORD = 'pepsi-123'

OPEN SYMMETRIC KEY AppConKey DECRYPTION
BY CERTIFICATE EncryptConCert

UPDATE SEC_AppConnection
SET EncryptedConInfo = ENCRYPTBYKEY(KEY_GUID('AppConKey'),ConString)

CLOSE SYMMETRIC KEY AppConKey
GO

-- UPDATE TABLE SEC_AppConnection, THE REPORT VALUE 2 BE 121

ALTER TABLE SEC_AppConnection
DROP COLUMN ConString
--GO

--SELECT ConKey, CONVERT(VARCHAR(500),DECRYPTBYKEY(EncryptedConInfo)) AS ConnectionString
--FROM SEC_AppConnection

-- CLOSE SYMMETRIC KEY AppConKey

--EXEC [dbo].[GetConnectionStore]

GRANT CONTROL ON CERTIFICATE::EncryptConCert TO HmgEncUser;
GO 

GRANT REFERENCES ON SYMMETRIC KEY::AppConKey TO HmgEncUser;
GO

Use HISGENX -- RUN THIS WHEN FAILOVER TO SECONDARY NODE
go
Grant Execute on fn_UTL_GetNow to HmgEncUser;
go