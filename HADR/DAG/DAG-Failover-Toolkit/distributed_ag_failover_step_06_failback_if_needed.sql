/*
    If you want to fail back to the primary, and enable access to the
    databases covered by the Distributed AG, then run this on the
    Distributed AG primary node:
*/
GO
:CONNECT $(Primary)
IF '$(TestMode)' = 'Failback'
BEGIN
    ALTER AVAILABILITY GROUP [$(DistributedAGName)]
    FORCE_FAILOVER_ALLOW_DATA_LOSS; 
    PRINT N'Distributed Availability Group [$(DistributedAGName)] has failed back to the primary, $(Primary).';
END
GO
