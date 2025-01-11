--******************************************************************************************************
-- CHANGE THE BKP FILE NAMES B4 RUN ********************************************************************************************************

USE [master]
RESTORE DATABASE [] FROM DISK = N'K:\BKP\_backup_2015_07_15_041635_8491879.bak' WITH FILE = 1, MOVE N'' TO N'H:\APP_DATA\.mdf', MOVE N'_LOG' TO N'I:\APP_LOG\.ldf', NOUNLOAD, REPLACE,STATS = 5
GO
