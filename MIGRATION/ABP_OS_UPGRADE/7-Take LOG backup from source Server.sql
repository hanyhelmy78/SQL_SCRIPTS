USE [msdb]
GO
--Select * FROM Sys.Databases 
DECLARE	@return_value int
--declare @Exceptionlist_value Exceptionlist 
--insert into @Exceptionlist_value 
--SELECT 9

EXEC	@return_value = [dbo].[DMV_BackupAll]
		@start_DB_ID = 7, 
		@END_DB_ID = 8, 
		@TapeBackupLocation = N'\\RUH1SFAB\ABP_Backup\',
		@TranBackupLocation = N'\\RUH1SFAB\ABP_Backup\',
		@FULLBackup = 0,
		@TXNLOG = 1,
		@TXLLOGType = 0,
		--@Exceptionlist_DBs=@Exceptionlist_value,
		@job_name='NOJob',
		@p_recipients = 'hhelmy@aljomaihbev.com',
		@DiffBackup = 0

SELECT	'Return Value' = @return_value
GO