USE [msdb]
GO

/****** Object:  Job [Shrink_Log]    Script Date: 23/12/2015 11:21:41 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 23/12/2015 11:21:41 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Shrink_Log', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Log_Shrink ALL DB`S.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [LogShrink]    Script Date: 23/12/2015 11:21:41 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'LogShrink', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE [HMGWEBDB]
GO
DBCC SHRINKFILE (N''HMGWEBDB_LOG'' , 0, TRUNCATEONLY)
GO
USE [HISGENX]
GO
DBCC SHRINKFILE (N''HISGENX_LOG'' , 0, TRUNCATEONLY)
GO
USE [PHARMAKON]
GO
DBCC SHRINKFILE (N''PharmaKon_log'' , 0, TRUNCATEONLY)
GO
USE [msdb]
GO
DBCC SHRINKFILE (N''MSDBLog'' , 0, TRUNCATEONLY)
GO
USE [HISGENX_MEDICALRECORD]
GO
DBCC SHRINKFILE (N''HISGENX_MEDICALRECORD_log'' , 0, TRUNCATEONLY)
GO
USE [HMGERPINF]
GO
DBCC SHRINKFILE (N''HMGERPINF_log'' , 0, TRUNCATEONLY)
GO
USE [HRMS]
GO
DBCC SHRINKFILE (N''HRMS_log'' , 0, TRUNCATEONLY)
GO
USE [RIS_ORDER]
GO
DBCC SHRINKFILE (N''RIS_ORDER_log'' , 0, TRUNCATEONLY)
GO
USE [LAB_ORDER_MD]
GO
DBCC SHRINKFILE (N''LAB_ORDER_MD_log'' , 0, TRUNCATEONLY)
GO
USE [LAB_RESULT_MD]
GO
DBCC SHRINKFILE (N''LAB_RESULT_MD_log'' , 0, TRUNCATEONLY)
GO
USE [WSLMIDTABLES]
GO
DBCC SHRINKFILE (N''WSLMIDTABLES_log'' , 0, TRUNCATEONLY)
GO
USE [SENTRY]
GO
DBCC SHRINKFILE (N''SENTRY_LOG'' , 0, TRUNCATEONLY)
GO
USE [MARHABA]
GO
DBCC SHRINKFILE (N''MARHABA_log'' , 0, TRUNCATEONLY)
GO
USE [LAB_ORDER]
GO
DBCC SHRINKFILE (N''LAB_ORDER_log'' , 0, TRUNCATEONLY)
GO
USE [HISTRANSFERQUEUE]
GO
DBCC SHRINKFILE (N''HISTRANSFERQUEUE_log'' , 0, TRUNCATEONLY)
GO
USE [NitgenAccessManager]
GO
DBCC SHRINKFILE (N''MSSDB_log'' , 0, TRUNCATEONLY)
GO
USE [LAB_RESULT]
GO
DBCC SHRINKFILE (N''LAB_RESULT_log'' , 0, TRUNCATEONLY)
GO
USE [AGS_RESULT]
GO
DBCC SHRINKFILE (N''AGS_RESULT_log'' , 0, TRUNCATEONLY)
GO
USE [RIS_RESULT]
GO
DBCC SHRINKFILE (N''RIS_RESULT_log'' , 0, TRUNCATEONLY)
GO', 
		@database_name=N'HMGWEBDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'HMGWEBDB_Log_Shrink', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150105, 
		@active_end_date=99991231, 
		@active_start_time=1000, 
		@active_end_time=235959, 
		@schedule_uid=N'395a080d-5a94-4106-a9d4-0af3a92114bf'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO