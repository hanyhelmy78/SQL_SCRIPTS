USE [msdb]
GO
--Select * FROM Sys.Databases
DECLARE	@return_value int
--declare @Exceptionlist_value Exceptionlist 
--insert into @Exceptionlist_value 
--SELECT 9

EXEC	@return_value = [dbo].[DMV_BackupAll]
		@start_DB_ID = 5, 
		@END_DB_ID = 7, 
		@TapeBackupLocation = N'I:\BKP\',
		@TranBackupLocation = N'I:\BKP\',
		@FULLBackup = 0,
		@TXNLOG = 1,
		@TXLLOGType = 0,
		--@Exceptionlist_DBs=@Exceptionlist_value,
		@job_name='Log_BKP_Failure',
		@p_recipients = 'hhelmy@.com',
		@DiffBackup = 0

SELECT	'Return Value' = @return_value
GO
