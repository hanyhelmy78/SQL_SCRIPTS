USE [msdb]
GO

/****** Object:  Job [Kill_Idle_Sessions]    Script Date: 23/03/2017 09:54:04 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 23/03/2017 09:54:04 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Kill_Idle_Sessions', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Kill_Idle_Sessions
https://gallery.technet.microsoft.com/scriptcenter/How-to-kill-SQL-Server-a33476b7', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'SQL_DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Kill_Idle_Sessions]    Script Date: 23/03/2017 09:54:04 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Kill_Idle_Sessions', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET NOCOUNT ON
 
DECLARE @IDLE_TIME DATETIME
DECLARE @LAST_BATCH DATETIME
 
DECLARE @nKillProcess INT
DECLARE @nFetchStatus INT
DECLARE @sTemp VARCHAR(30)
 
--Please set the idle time (Hours:Minutes:Seconds)
SET @IDLE_TIME = ''00:30:00''
 
--CREATE TEMP TABLE FOR STORE SESSION DATA
IF OBJECT_ID(''tempdb.dbo.#SESSION_TEMP_RECORD'', ''U'') IS NOT NULL
  DROP TABLE #SESSION_TEMP_RECORD; 

CREATE TABLE #SESSION_TEMP_RECORD
(
spid smallint,
last_batch datetime,
kpid smallint,
[status] nchar(60),
waittype binary,
waittime bigint,
lastwaittype nchar(64),
[dbid] smallint,
cmd  nchar(32),
hostname nchar(256),
loginame nchar(256),
IDLE_TIME_TARGET DATETIME
)
 
--SELECT CURRENT SESSION RECORDS WHICH MEETS REQUIREMENTS
INSERT INTO #SESSION_TEMP_RECORD(spid,last_batch,kpid,[status],waittype,waittime,lastwaittype,[dbid],cmd,hostname,loginame)
SELECT
spid,last_batch,kpid,status,waittype,waittime,lastwaittype,dbid,cmd,hostname,loginame
from sys.sysprocesses
WHERE status IN (''sleeping'')
and cmd IN (''AWAITING COMMAND'')
and kpid = 0 -- Not processing now, > 1 means this session own at least a SQL Server thread
AND spid > 50
and DB_NAME(dbid) NOT IN (''master'',''tempdb'',''model'',''msdb'',''distribution'') -- You could add database name which you want to exclude
--and hostname IN (''host1'',''host2'')                            -- You could add host name which you want to exclude
and open_tran = 1                                          -- open_tran > 0 means there are some transaction still active
 
--Update IDLE_TIME_TARGET column and get the idle time target
UPDATE #SESSION_TEMP_RECORD
SET IDLE_TIME_TARGET = GETDATE()-@IDLE_TIME
 
--SELECT * FROM #SESSION_TEMP_RECORD WHERE last_batch < IDLE_TIME_TARGET
 
DECLARE curProcesses CURSOR
    LOCAL
    FAST_FORWARD
    READ_ONLY
FOR
     SELECT spid
     FROM #SESSION_TEMP_RECORD
     WHERE last_batch < IDLE_TIME_TARGET
 
OPEN curProcesses
 
FETCH NEXT FROM curProcesses INTO -- Get the first process
@nKillProcess
 
SET @nFetchStatus = @@FETCH_STATUS
 
--Kill the processes
WHILE @nFetchStatus = 0
     BEGIN
           SET @sTemp =''KILL '' + CAST(@nKillProcess as varchar(5))
           PRINT @sTemp
           EXEC(@sTemp)
           FETCH NEXT FROM curProcesses INTO --Gets the next process
                 @nKillProcess
           SET @nFetchStatus = @@FETCH_STATUS
     END
 
CLOSE curProcesses
DEALLOCATE curProcesses', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Replication agent schedule.', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=1, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161218, 
		@active_end_date=99991231, 
		@active_start_time=500, 
		@active_end_time=459, 
		@schedule_uid=N'8a4f7a59-2f3d-427f-895c-7a02bfac90ba'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


