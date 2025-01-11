USE [msdb]
GO
DECLARE	@return_value int
declare @Exceptionlist_value Exceptionlist 
--Select * FROM Sys.Databases

insert into @Exceptionlist_value 
SELECT 2 UNION SELECT 14 UNION SELECT 15

EXEC	@return_value = [dbo].[DMV_BackupAll]
		@start_DB_ID = 1,
		@END_DB_ID = 30,
		@TapeBackupLocation = N'D:\DB_Backup\B4_UPGRADE\',
		@TranBackupLocation = N'D:\DB_Backup\B4_UPGRADE\',
		@FULLBackup = 1,
		@TXNLOG = 0,
		@TXLLOGType = 0,
		@Exceptionlist_DBs=@Exceptionlist_value,
		@job_name='Full_BKP_Failure',
		@p_recipients = 'hhelmy@aljomaihbev.com'
SELECT	'Return Value' = @return_value
GO