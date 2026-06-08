/*
    Disables access to the databases covered by the Distributed AG, in
    preparation for failover.

    Run this from the PRIMARY node of the Distributed AG
*/
GO
:CONNECT $(Primary)
ALTER AVAILABILITY GROUP [$(DistributedAGName)]
SET (ROLE = SECONDARY); 
PRINT N'Access to Distributed AG [$(DistributedAGName)] has been temporarily disabled in preparation for failover or failback.';
GO
