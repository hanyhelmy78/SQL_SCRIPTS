/*
    To complete the failover to the Secondary node of the Distributed AG,
    run the following on the SECONDARY NODE.
*/
GO
:CONNECT $(Secondary)
IF '$(TestMode)' = 'Failover'
BEGIN
    ALTER AVAILABILITY GROUP [$(DistributedAGName)]
    FORCE_FAILOVER_ALLOW_DATA_LOSS; 
    PRINT N'Distributed Availability Group [$(DistributedAGName)] has failed over from $(Primary) to $(Secondary).';
END
GO
