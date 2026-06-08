@ECHO OFF
ECHO Failover Distributed AG mb-db-to-azure from az3tmbdbvwprag.corp.teranet.ca to az1tmbdbvwprag.corp.teranet.ca ?
ECHO (Hit CTRL-C to abort)
pause
sqlcmd -i distributed_ag_failover_main.sql -M -S mb-db.corp.teranet.ca\TMB -v DistributedAGName = "mb-db-in-azure" Primary = "az3tmbdbvwprag\TMB" Secondary = "az1tmbdbvwprag\TMB" DNSServer = "stdns1.teranet.ca" TTL = "30" CName = "mb-db" DNSZone = "corp.teranet.ca" EnableXPCmdShellIfRequired = "YES" StopAtStep = 10 SyncWaitSeconds = 15 SetToAsyncCommitAfterFailover = "Yes" TestMode = FailOver
ECHO.
ECHO.
ECHO SqlCmd Completed.
ECHO.
ECHO.
ECHO You will need to have the NOC update DNS so that mb-db.corp.teranet.ca CNAME points at az1tmbdbvwprag.corp.teranet.ca
