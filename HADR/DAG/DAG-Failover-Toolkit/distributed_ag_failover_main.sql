/*
    Failover Distributed AG

    2022-07-13  Hannah Vernon

    Steps:
        
        1. Disable client access to databases in the Distributed AG.
        2. Configure Distributed AG for synchronous commit.
        3. Wait for the "synchronized" state, and confirm the last_hardened_lsn
           is the same on the primary and secondary.
        4. Set the primary node of the Distributed AG to state "SECONDARY"
        5. Failover the Distributed AG.

    Change the Primary and Secondary sqlcmd variables to match the actual current primary and forwarder Distributed AG instances.

    Sample command line:

    sqlcmd -i distributed_ag_failover_main.sql -S sqlag.mvct.com,22136 -v DistributedAGName = "SQLDAG" Primary = "SQLAG200,22136" Secondary = "SQLAG100,22136" DNSServer = "mvctdc01.mvct.com" TTL = "300" CName = "sqlag" DNSZone = "mvct.com" EnableXPCmdShellIfRequired = "YES" StopAtStep = 0

    FYI, RAISERROR with state = 127 causes sqlcmd to stop.  SSMS however will not stop running, so only run this under sqlcmd, and not in sqlcmd mode in SSMS.
*/
PRINT N'';
PRINT N'Distributed AG Failover, by Hannah Vernon, 2022-07-14';
PRINT N'';
PRINT N'Command Line Parameters passed to sqlcmd:

DistributedAGName               "$(DistributedAGName)"
Primary                         "$(Primary)"
Secondary                       "$(Secondary)"
SyncWaitSeconds                 "$(SyncWaitSeconds)"
SetToAsyncCommitAfterFailover   "$(SetToAsyncCommitAfterFailover)"

DNSServer                       "$(DNSServer)"
TTL                             "$(TTL)"
CName                           "$(CName)"
DNSZone                         "$(DNSZone)"

EnableXpCmdshellIfRequired      "$(EnableXpCmdshellIfRequired)"

TestMode                        "$(TestMode)"
';
--:setvar DistributedAGName   "SQLDAG1"
--:setvar Primary     "SQLAG200,22136"
--:setvar Secondary   "SQLAG100,22136"

--:setvar DNSServer   "mvctdc01.mvct.com"
--:setvar TTL         "300"
--:setvar CName       "sqlag"
--:setvar DNSZone     "mvct.com"

--:setvar EnableXpCmdshellIfRequired "YES"
/*
    $(TestMode) can be set to:
        - "Failback" to test failing back to the primary
        - "Failover" to actually fail over to the secondary
*/
--:setvar TestMode  "Failback"
:on error exit
GO
:setvar IsSqlCmdEnabled "True"
GO
IF '$(IsSqlCmdEnabled)' NOT LIKE 'True'
BEGIN
    RAISERROR (N'This must be ran via sqlcmd.exe', 10, 127);
    SET NOEXEC ON;
END
GO

IF '$(Primary)' = '$(Secondary)'
BEGIN
    RAISERROR ('Primary and Secondary are set to the same value.  Please correct your command line, and try again.', 10, 127);
END

:r .\is_xp_cmdshell_enabled.sql
IF '$(StopAtStep)' = '0' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_01.sql

IF '$(StopAtStep)' = '1' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_02_synchronous_commit.sql
IF '$(StopAtStep)' = '2' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_03_confirm_synchronous_commit.sql
IF '$(StopAtStep)' = '3' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_04_confirm_committed_lsn.sql
IF '$(StopAtStep)' = '4' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_05_disable_access_to_distributed_ag.sql
IF '$(StopAtStep)' = '5' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_06_failback_if_needed.sql
IF '$(StopAtStep)' = '6' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_07_failover.sql
IF '$(StopAtStep)' = '7' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_08_reset_to_async_commit.sql
IF '$(StopAtStep)' = '8' RAISERROR ('Step $(StopAtStep) reached.  Aborting.', 10, 127); 

:r .\distributed_ag_failover_step_09_finished.sql
