USE [DBA]
GO
/****** Object:  Table [dbo].[BlitzResults]    Script Date: 09/11/2022 12:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BlitzResults](
	[ID] [smallint] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](50) NULL,
	[CheckDate] [nvarchar](100) NULL,
	[Priority] [tinyint] NULL,
	[FindingsGroup] [nvarchar](50) NULL,
	[Finding] [nvarchar](100) NULL,
	[DatabaseName] [nvarchar](50) NULL,
	[URL] [nvarchar](100) NULL,
	[Details] [nvarchar](max) NULL,
	[QueryPlan] [xml] NULL,
	[QueryPlanFiltered] [xml] NULL,
	[CheckID] [smallint] NULL,
 CONSTRAINT [PK_BlitzResults] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--=======================================================================================================
USE msdb
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[Send_Automatic_HC] 	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @Var_recipients AS NVARCHAR(100) = 'Eoqdi@saudivts.com;tsuhaibani@jawar.sa;hhelmy@jawar.sa';
		DECLARE @Var_Query_Attachment_Filename1 AS VARCHAR(100) = 'Database Health Check_' + (CONVERT(VARCHAR(11),GETDATE(),106)) + '.csv';
		DECLARE @Var_Query1_For_Email NVARCHAR(MAX);
		DECLARE @Command NVARCHAR(MAX);
		DECLARE @columnname varchar(400);

		SET @Command = 'TRUNCATE TABLE [DBA].[dbo].[BlitzResults];
		  EXEC DBA.dbo.sp_Blitz 
		  @OutputDatabaseName = ''DBA'',
		  @OutputSchemaName = ''dbo'',
		  @OutputTableName = ''BlitzResults'';'
	    EXEC SP_EXECUTESQL @Command;

		SET @ColumnName = '[sep=,' + CHAR(13) + CHAR(10) + 'ID]'
		SET @Var_Query1_For_Email =
		'	SELECT
			[ID] ' + @ColumnName + ',
			[ServerName] AS [Server Name],
			[CheckDate] AS [Check Date],
			[Priority] AS [Priority],
			[FindingsGroup] AS [Findings Group],
			[Finding] AS [Finding],
			[DatabaseName] AS [Database Name],
			[URL] AS [URL],
			[Details] AS [Details],
			[QueryPlan] AS [Query Plan],
			[QueryPlanFiltered] AS [Query Plan Filtered],
			[CheckID] AS [Check ID]
	   FROM [DBA].[dbo].[BlitzResults]'

			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'DB Mail',
			@recipients = @Var_recipients,
			@subject = 'Database Health Check',
			@body='Kindly check the attached for today`s Database Health Check',
			@query = @Var_Query1_For_Email,
			@attach_query_result_as_file = 1,
			@query_attachment_filename = @Var_Query_Attachment_Filename1,
			@query_result_separator=',',
			@query_result_width =32767,
			@query_result_no_padding=1
				
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2047);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END
GO
--=================================================================================================================
USE [msdb]
GO
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Send_Automatic_HC', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Send_Automatic_HC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'SQL_DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Send_Automatic_HC]    Script Date: 30/05/2023 2:02:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Send_Automatic_HC', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Send_Automatic_HC', 
		@database_name=N'msdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'syspolicy_purge_history_schedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20080101, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, 
		@schedule_uid=N'e782885f-d935-47bb-a8e2-3b378dde3a4f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO