/*============================================================================
  File:     sp_CheckPlanCache

Summary: This procedure looks at cache and totals the single-use plans to report the percentage of memory consumed (and therefore wasted) from single-use plans.
			
  Date:     April 2010

  Version:	2008.
------------------------------------------------------------------------------
  Written by Kimberly L. Tripp, SQLskills.com

  For more scripts and sample code, check out http://www.SQLskills.com

  This script is intended only as a supplement to demos and lectures given by SQLskills instructors.  
  
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
============================================================================*/
USE master
go

if OBJECTPROPERTY(OBJECT_ID('sp_CheckPlanCache'), 'IsProcedure') = 1
	DROP PROCEDURE sp_CheckPlanCache
go

CREATE PROCEDURE sp_CheckPlanCache
	(@Percent	decimal(6,3) OUTPUT,
	 @WastedMB	decimal(19,3) OUTPUT)
AS
SET NOCOUNT ON

DECLARE @ConfiguredMemory	decimal(19,3)
	, @PhysicalMemory		decimal(19,3)
	, @MemoryInUse			decimal(19,3)
	, @SingleUsePlanCount	bigint

CREATE TABLE #ConfigurationOptions
(
	[name]				nvarchar(35)
	, [minimum]			int
	, [maximum]			int
	, [config_value]	int				-- in bytes
	, [run_value]		int				-- in bytes
);
INSERT #ConfigurationOptions EXEC ('sp_configure ''max server memory''');

SELECT @ConfiguredMemory = run_value/1024/1024 
FROM #ConfigurationOptions 
WHERE name = 'max server memory (MB)'

SELECT @PhysicalMemory = total_physical_memory_kb/1024 
FROM sys.dm_os_sys_memory

SELECT @MemoryInUse = physical_memory_in_use_kb/1024 
FROM sys.dm_os_process_memory

-- REMOVED THE PREPARED PART OF THE SP AS: "Using Prepared Parameterized statements/queries not only improves plan reuse and compilation overhead, but it also reduces the SQL Injection attack risk involved with Passing Parameters 
SELECT @WastedMB = sum(cast((CASE WHEN USECOUNTS = 1 AND objtype IN ('Adhoc')--, 'Prepared') 
								THEN size_in_bytes ELSE 0 END) AS DECIMAL(12,2)))/1024/1024 
	, @SingleUsePlanCount = sum(CASE WHEN usecounts = 1 AND objtype IN ('Adhoc')--, 'Prepared') 
								THEN 1 ELSE 0 END)
	, @Percent = @WastedMB/@MemoryInUse * 100
FROM sys.dm_exec_cached_plans

SELECT	[TotalPhysicalMemory (MB)] = @PhysicalMemory
	, [TotalConfiguredMemory (MB)] = @ConfiguredMemory
	, [MaxMemoryAvailableToSQLServer (%)] = @ConfiguredMemory/@PhysicalMemory * 100
	, [MemoryInUseBySQLServer (MB)] = @MemoryInUse
	, [TotalSingleUsePlanCache (MB)] = @WastedMB
	, TotalNumberOfSingleUsePlans = @SingleUsePlanCount
	, [PercentOfConfiguredCacheWastedForSingleUsePlans (%)] = @Percent
GO

EXEC sys.sp_MS_marksystemobject 'sp_CheckPlanCache'
GO
----------------------------------------------------------------------
-- Logic (in a job?) to decide whether or not to clear - using the SP.
----------------------------------------------------------------------
--DECLARE @Percent		decimal(6, 3)
--	  , @WastedMB		decimal(19,3)
--	  , @StrMB		nvarchar(20)
--	  , @StrPercent	nvarchar(20)
--EXEC sp_CheckPlanCache @Percent output, @WastedMB output

--SELECT @StrMB = CONVERT(nvarchar(20), @WastedMB)
--		, @StrPercent = CONVERT(nvarchar(20), @Percent)

--IF @Percent > 10 OR @WastedMB > 100
--	BEGIN
--		DBCC FREESYSTEMCACHE('SQL Plans') -- THIS COMMAND IS USED 2 MANUALLY REMOVE UNUSED ENTRIES FROM THE SPECIFIC CACHE SQLPLANS (4 ADHOC QUERIES).
--		RAISERROR ('%s MB (%s percent) was allocated to single-use plan cache. Single-use plans have been cleared.', 10, 1, @StrMB, @StrPercent)
--	END
--ELSE
--	BEGIN
--		RAISERROR ('Only %s MB (%s percent) is allocated to single-use plan cache - No Need To Clear Cache Now.', 10, 1, @StrMB, @StrPercent)
--			-- Note: this is only a warning message and not an actual error.
--	END
--GO
USE [msdb]
GO

/****** Object:  Job [Clear single-use plan cache]    Script Date: 08/09/2016 08:15:54 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 08/09/2016 08:15:55 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA_ClearSingle-UsePlanCache', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'sp_CheckPlanCache', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'SQL_DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [single-use plan cache]    Script Date: 08/09/2016 08:15:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'single-use plan cache', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @Percent		decimal(6, 3)
	  , @WastedMB		decimal(19,3)
	  , @StrMB		nvarchar(20)
	  , @StrPercent	nvarchar(20)
EXEC sp_CheckPlanCache @Percent output, @WastedMB output

SELECT @StrMB = CONVERT(nvarchar(20), @WastedMB)
		, @StrPercent = CONVERT(nvarchar(20), @Percent)

IF @Percent > 10 OR @WastedMB > 100
	BEGIN
		DBCC FREESYSTEMCACHE(''SQL Plans'') -- THIS COMMAND IS USED 2 MANUALLY REMOVE UNUSED ENTRIES FROM THE SPECIFIC CACHE SQLPLANS (4 ADHOC QUERIES).
		RAISERROR (''%s MB (%s percent) was allocated to single-use plan cache. Single-use plans have been cleared.'', 10, 1, @StrMB, @StrPercent)
	END
ELSE
	BEGIN
		RAISERROR (''Only %s MB (%s percent) is allocated to single-use plan cache - No Need To Clear Cache Now.'', 10, 1, @StrMB, @StrPercent)
			-- Note: this is only a warning message and not an actual error.
	END
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'CollectorSchedule_Every_30min', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20141105, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959
		--,@schedule_uid=N'98016f0b-2567-4a5a-949d-cdcb2363bbd9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO