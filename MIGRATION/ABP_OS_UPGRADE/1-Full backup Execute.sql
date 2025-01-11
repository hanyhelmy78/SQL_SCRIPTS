USE [msdb]
GO

DECLARE	@return_value int
declare @Exceptionlist_value Exceptionlist 

--Select * FROM Sys.Databases

--insert into @Exceptionlist_value 
--SELECT 9

EXEC	@return_value = [dbo].[DMV_BackupAll]
		@start_DB_ID = 7,
		@END_DB_ID = 8,
		@TapeBackupLocation = N'\\\ABP_Backup\',
		@TranBackupLocation = N'\\\ABP_Backup\',
		@FULLBackup = 1,
		@TXNLOG = 0,
		@TXLLOGType = 0,
		--@Exceptionlist_DBs=@Exceptionlist_value,
		@job_name='NoJob',
		@p_recipients = 'hhelmy@.com'

SELECT	'Return Value' = @return_value
GO
