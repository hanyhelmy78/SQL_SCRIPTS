@ECHO OFF
ECHO Failover Distributed AG mb-db-to-azure from az1tmbdbvwprag.corp.teranet.ca to az3tmbdbvwprag.corp.teranet.ca ?
ECHO (Hit CTRL-C to abort)
pause
sqlcmd -i distributed_ag_failover_main.sql -M -S mb-db.corp.teranet.ca\TMB -v DistributedAGName = "mb-db-in-azure" Primary = "az1tmbdbvwprag\TMB" Secondary = "az3tmbdbvwprag\TMB" DNSServer = "stdns1.teranet.ca" TTL = "30" CName = "mb-db" DNSZone = "corp.teranet.ca" EnableXPCmdShellIfRequired = "YES" StopAtStep = 10 SyncWaitSeconds = 15 SetToAsyncCommitAfterFailover = "Yes" TestMode = FailOver
ECHO.
ECHO.
ECHO SqlCmd Completed.
ECHO.
ECHO.
ECHO You will need to have the NOC update DNS so that mb-db.corp.teranet.ca CNAME points at az3tmbdbvwprag.corp.teranet.ca
