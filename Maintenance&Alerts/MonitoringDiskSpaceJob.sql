USE [msdb]
GO
SET NOCOUNT ON
DECLARE @ReturnCode BIGINT,
 @PctWarning VARCHAR(2),
 @PctCritical VARCHAR(2),
 @JobSubSystem NVARCHAR(16),
 @JobStep NVARCHAR(128),
 @JobOper NVARCHAR(32),
 @JobName NVARCHAR(64),
 @JobID BINARY(16),
 @JobDescr NVARCHAR(128),
 @JobCmd NVARCHAR(MAX),
 @JobCategory NVARCHAR(128),
 @InstanceVersion VARCHAR(16),
 @DebugMessage VARCHAR(MAX),
 @DatabaseName NVARCHAR(12);
 
-- Set values for user variables
SET @PctWarning = '10';
SET @PctCritical = '5';
SET @JobOper = N'SQL_DBA';
-- End user variable section

-- Initialize static variables
SET @InstanceVersion = SUBSTRING(CONVERT(VARCHAR(16), SERVERPROPERTY('ProductVersion')), 1, 
  (CHARINDEX('.', (CONVERT(VARCHAR(16), SERVERPROPERTY('ProductVersion')))) - 1));
SET @JobCategory = N'Instance Monitor';
SET @JobDescr = N'Monitor percent free space for local disks.';
SET @JobName = N'Monitor Disk Space';
SET @JobStep = N'Check for local disks with free space below percentage thresholds.';
SET @ReturnCode = 0;
-- End static variable section

-- Check for existence of specified operator; use failsafe operator if it doesn't
IF NOT EXISTS ( SELECT * FROM dbo.[sysoperators] WHERE [name] = @JobOper )
BEGIN
 SET @DebugMessage = 'Operator [' + @JobOper + '] not found; checking for failsafe operator.';
  RAISERROR(@DebugMessage, 0, 42) WITH NOWAIT;
 EXEC [master].dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', 
  N'Software\Microsoft\MSSQLServer\SQLServerAgent',
  N'AlertFailSafeOperator', @JobOper OUTPUT;
END
IF @JobOper IS NULL
BEGIN
 SET @DebugMessage = 'No failsafe operator found; Job [' + @JobName + '] will not be created without notification functionality.';
  RAISERROR(@DebugMessage, 8, 0) WITH LOG, NOWAIT;
   GOTO QuitWithRollback;
END

-- Create the custom messages
EXEC [master].dbo.sp_addmessage @msgnum = 64000,
 @msgtext = 'WARNING: The following disks have less than %d percent free space: %s',
 @severity = 8, @with_log = 'FALSE', @replace = 'REPLACE';
EXEC [master].dbo.sp_addmessage @msgnum = 64001,
 @msgtext = 'CRITICAL: The following disks have less than %d percent free space: %s',
 @severity = 12, @with_log = 'FALSE', @replace = 'REPLACE';

-- Create alerts associated with custom error messages
IF EXISTS (SELECT * FROM [dbo].[sysalerts] WHERE [name] = N'Disk Critical')
 EXEC dbo.sp_delete_alert @name=N'Disk Critical';
IF EXISTS (SELECT * FROM [dbo].[sysalerts] WHERE [name] = N'Disk Warning')
 EXEC dbo.sp_delete_alert @name=N'Disk Warning';
EXEC dbo.sp_add_alert @name=N'Disk Critical', @message_id=64001, @severity=0, @enabled=1,
 @delay_between_responses=0, @include_event_description_in=3;
EXEC dbo.sp_add_notification @alert_name=N'Disk Critical', @operator_name=@JobOper,
 @notification_method = 3;
EXEC dbo.sp_add_alert @name=N'Disk Warning', @message_id=64000, @severity=0, @enabled=1,
 @delay_between_responses=0, @include_event_description_in=3;
EXEC dbo.sp_add_notification @alert_name=N'Disk Warning', @operator_name=@JobOper,
 @notification_method = 1;

 -- Set conditional value of job parameters based on version of current instance
IF CAST(@InstanceVersion AS INT) < 10
BEGIN
 SELECT @JobSubSystem = N'ActiveScripting', @DatabaseName = N'VBScript',
  @JobCmd = N'Option Explicit
On Error Resume Next
dim sWarnMsg, sCritMsg, sConStr, sComputer, sCmd
dim oWMI, oDiskList, oDisk, oConn
dim iWarn, iPct, iError, iCrit, cWarn, cCrit

'' Set disk free space percentage thresholds
iWarn = ' + @PctWarning + '
iCrit = ' + @PctCritical + '
cWarn = 0
cCrit = 0

'' Initialize string variables
sComputer = "."
sConStr = "Provider=SQLOLEDB;server=' + @@SERVERNAME + ';database=msdb;Trusted_Connection=Yes"
sCritMsg = ""
sWarnMsg = ""

'' Initialize object variables
set oWMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & sComputer & "\root\cimv2")

'' Drive type 3 indicates local disk
set oDiskList = oWMI.ExecQuery("SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3")
set oConn = CreateObject("ADODB.Connection")

'' Loop through all local disk drives
for each oDisk in oDiskList
 iPct = round((oDisk.FreeSpace / oDisk.Size) * 100)
 if iPct < iWarn and iPct > iCrit then
  cWarn = cWarn + 1
  sWarnMsg = sWarnMsg & replace(oDisk.Name, ":", "") & " - " & iPct & "; "
 end if
 if iPct < iCrit then
  cCrit = cCrit + 1
  sCritMsg = sCritMsg & replace(oDisk.Name, ":", "") & " - " & iPct & "; "
 end if
next

'' Open local database connection
oConn.Open(sConStr)

'' Check results
if cWarn = 0 and cCrit = 0 then
 sCmd = "RAISERROR(''All disks have free space within the defined thresholds.'', 0, 2) WITH NOWAIT"
 oConn.Execute(sCmd)
else
 if cWarn > 0 then
  sCmd = "RAISERROR(64000, 0, 0, " & iWarn & ", ''" & sWarnMsg & "'') WITH LOG, NOWAIT"
  oConn.Execute(sCmd)
 end if
 if cCrit > 0 then
  sCmd = "RAISERROR(64001, 0, 1, " & iCrit & ", ''" & sCritMsg & "'') WITH LOG, NOWAIT"
  oConn.Execute(sCmd)
 end if
end if

'' Close local database connection
oConn.Close()

'' Housekeeping
set oConn = Nothing
set oDisk = Nothing
set oDiskList = Nothing
set oWMI = Nothing
';
END
ELSE
BEGIN
 SELECT @JobSubSystem = N'Powershell', @DatabaseName = N'Powershell',
  @JobCmd = N'#SqlAlert function
Function SqlAlert([string]$fConn, [string]$fCmd)
{
    $sqlConn = New-Object System.Data.SqlClient.SQLConnection($fConn);
    $sqlCmd = New-Object System.Data.SqlClient.SqlCommand($fCmd, $sqlConn);
 
    $sqlConn.Open();
 try { $sqlCmd.ExecuteNonQuery() | Out-Null; }
 catch [System.Management.Automation.MethodInvocationException] { continue; }
    $sqlConn.Close;
}

# Initialize variables
$sqlConn = "Data Source=' + @@SERVERNAME + ';Initial Catalog=msdb;Integrated Security=SSPI";
$server = "."
$pctWarn = ' + @PctWarning + '
$pctCrit = ' + @PctCritical + '
$msgWarn = ""
$msgCrit = ""
$cntWarn = 0
$cntCrit = 0

# Get fixed drive info
$disks = Get-WmiObject -ComputerName $server -Class Win32_LogicalDisk -Filter "DriveType = 3";
foreach ($disk in $disks)
{
 $deviceID = $disk.DeviceID;
 $drive = $deviceID -replace ":", " -";
 [float]$size = $disk.Size;
 [float]$freespace = $disk.FreeSpace;
 $pctFree = [Math]::Round(($freespace / $size) * 100, 2);
 
 if ( ($pctFree -lt $pctWarn) -and ($pctFree -gt $pctCrit) )
 {
  $cntWarn = $cntWarn + 1;
  $msgWarn = "$msgWarn $drive $pctFree; ";
 }
 
 if ($pctFree -lt $pctCrit)
 {
  $cntCrit = $cntCrit + 1;
  $msgCrit = "$msgCrit $msgWarn $drive $pctFree; ";
 }
}
# Set conditional value of RAISERROR command and execute SqlAlert function where applicable
if ( ($cntWarn -eq 0) -and ($cntCrit -eq 0) )
{
 $sql = "RAISERROR(''All disks have sufficient free space.'', 0, 2) WITH NOWAIT";
 SqlAlert $sqlConn $sql;
}
if ($cntWarn -gt 0)
{
 $sql = "RAISERROR(64000, 0, 0, $pctWarn, ''$msgWarn'') WITH LOG, NOWAIT";
 SqlAlert $sqlConn $sql;
}
if ($cntCrit -gt 0)
{
 $sql = "RAISERROR(64001, 0, 1, $pctCrit, ''$msgCrit'') WITH LOG, NOWAIT";
 SqlAlert $sqlConn $sql;
}

# Close SQL connection
$sqlConn.Close;
';
END
BEGIN TRANSACTION

-- Create job category if it doesn't already exist
IF NOT EXISTS (SELECT name FROM dbo.syscategories WHERE name=@JobCategory AND category_class=1)
BEGIN
 EXEC @ReturnCode = dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=@JobCategory;
 IF (@@ERROR <> 0 OR @ReturnCode <> 0)
 BEGIN
  SET @DebugMessage = 'Error creating job category [' + @JobCategory + ']';
   RAISERROR(@DebugMessage, 0, 42) WITH NOWAIT;
    GOTO QuitWithRollback;
 END
END

-- Delete job if it already exists
IF EXISTS (SELECT job_id FROM dbo.sysjobs_view WHERE [name] = @JobName)
 EXEC dbo.sp_delete_job @job_name=@JobName, @delete_unused_schedule=1;

-- Create disk monitoring job
EXEC @ReturnCode = dbo.sp_add_job @job_name=@JobName, @enabled=1, @notify_level_eventlog=2,
 @notify_level_email=2, @notify_level_netsend=0, @notify_level_page=0,
 @notify_email_operator_name=@JobOper, @delete_level=0, @description=@JobDescr,
 @category_name=@JobCategory, @owner_login_name=N'sa', @job_id = @JobID OUTPUT;
IF (@@ERROR <> 0 OR @ReturnCode <> 0)
BEGIN
 SET @DebugMessage = 'Error creating job [' + @JobName + ']';
  RAISERROR(@DebugMessage, 0, 42) WITH NOWAIT;
   GOTO QuitWithRollback;
END

-- Add step to job
EXEC @ReturnCode = dbo.sp_add_jobstep @job_id=@JobID, @step_name=@JobStep, @step_id=1,
 @cmdexec_success_code=0, @on_success_action=1, @on_success_step_id=0,
 @on_fail_action=2, @on_fail_step_id=0, @retry_attempts=0, @retry_interval=0,
 @os_run_priority=0, @subsystem=@JobSubSystem, @command=@JobCmd,
 @database_name=@DatabaseName, @flags=0;
IF (@@ERROR <> 0 OR @ReturnCode <> 0)
BEGIN
 SET @DebugMessage = 'Error creating job step [' + @JobStep + ']';
  RAISERROR(@DebugMessage, 0, 42) WITH NOWAIT;
   GOTO QuitWithRollback;
END

-- Explicitly set step id at which job will start
EXEC @ReturnCode = dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
IF (@@ERROR <> 0 OR @ReturnCode <> 0)
BEGIN
 SET @DebugMessage = 'Error setting start step for job [' + @JobName + ']';
  RAISERROR(@DebugMessage, 0, 42) WITH NOWAIT;
   GOTO QuitWithRollback;
END

-- Create job schedule
EXEC @ReturnCode = dbo.sp_add_jobschedule @job_id=@JobID, @name=@JobName, @enabled=1, @freq_type=4,
 @freq_interval=1, @freq_subday_type=8, @freq_subday_interval=1, @freq_relative_interval=0,
 @freq_recurrence_factor=0, @active_start_date=19900101, @active_end_date=99991231,
 @active_start_time=000000, @active_end_time=235959;
IF (@@ERROR <> 0 OR @ReturnCode <> 0)
BEGIN
 SET @DebugMessage = 'Error creating job schedule [' + @JobName + ']';
  RAISERROR(@DebugMessage, 0, 42) WITH NOWAIT;
   GOTO QuitWithRollback;
END

-- Designate server for job execution
EXEC @ReturnCode = dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
IF (@@ERROR <> 0 OR @ReturnCode <> 0)
BEGIN
 SET @DebugMessage = 'Error setting job server for job [' + @JobName + ']';
  RAISERROR(@DebugMessage, 0, 42) WITH NOWAIT;
   GOTO QuitWithRollback;
END

-- Commit changes if no errors occur
IF @@TRANCOUNT <> 0
 COMMIT TRANSACTION;
SET @DebugMessage = 'DiskSpace monitoring job has been (re)created.';
 RAISERROR(@DebugMessage, 0, 42) WITH NOWAIT;

-- Rollback changes if error occurs at any point in script
QuitWithRollback:
IF (@@TRANCOUNT <> 0)
 ROLLBACK TRANSACTION;
GO