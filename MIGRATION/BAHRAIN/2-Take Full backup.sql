
EXEC Weekly_Full_BKP.Subplan_1

--USE [msdb]
--GO
--DECLARE	@return_value int
--declare @Exceptionlist_value Exceptionlist 

--insert into  @Exceptionlist_value select 2 

--EXEC	@return_value = [dbo].[DMV_BackupAll]
--		@start_DB_ID = 1,
--		@END_DB_ID = 200,
--		@TapeBackupLocation = N'J:\Backup\',
--		@TranBackupLocation = N'J:\Backup\',
--		@FULLBackup = 1,
--		@TXNLOG = 0,
--		@TXLLOGType = 1,
--		@Exceptionlist_DBs=@Exceptionlist_value,
--		@job_name='Temp',
--		@p_recipients = 'hany.helmy@drsulaimanalhabib.com'

--SELECT	'Return Value' = @return_value
--GO