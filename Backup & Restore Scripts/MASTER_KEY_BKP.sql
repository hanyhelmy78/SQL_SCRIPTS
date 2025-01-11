BACKUP SERVICE MASTER KEY -- Important overall and should be backed up
TO FILE = 'I:\BKP\RUH1SFADB_SQLServiceMasterKey_20120314.snk' 
    ENCRYPTION BY PASSWORD = '@Netw0rk';

-- 4 SSISDB
OPEN MASTER KEY
DECRYPTION BY PASSWORD = N'Pepsi-123'; --Password used when creating SSISDB