USE msdb
GO
EXEC sp_delete_backuphistory @oldest_date = '01 jul 2012'