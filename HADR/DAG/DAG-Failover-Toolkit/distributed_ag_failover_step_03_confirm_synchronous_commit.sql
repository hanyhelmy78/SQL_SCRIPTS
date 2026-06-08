/*
    Run this on both the primary and secondary members of the Distributed AG
    to ensure both replicas have the availability mode set to SYNCHRONOUS_COMMIT
*/
GO
:CONNECT $(Primary)
DECLARE @mode nvarchar(60);

:r ./parse_server_names.sql

SELECT 
    @mode = ar.availability_mode_desc
FROM sys.availability_groups ag 
    INNER JOIN sys.availability_replicas ar ON ag.group_id = ar.group_id
    INNER JOIN sys.dm_hadr_availability_replica_states ars 
       ON ag.group_id = ars.group_id
        AND ar.replica_id = ars.replica_id
WHERE ag.[name] = N'$(DistributedAGName)'
    AND ar.[replica_server_name] = @primary_name
IF COALESCE(@mode, N'') = N'SYNCHRONOUS_COMMIT'
BEGIN
    PRINT N'Synchronous commit established on $(Primary).';
END
ELSE
BEGIN
    RAISERROR (N'Could not confirm SYNCHRONOUS_COMMIT on $(Primary).  Aborting.', 10, 127);
END
GO
:CONNECT $(Secondary)
DECLARE @mode nvarchar(60);

:r ./parse_server_names.sql

SELECT 
    @mode = ar.availability_mode_desc
FROM sys.availability_groups ag 
    INNER JOIN sys.availability_replicas ar ON ag.group_id = ar.group_id
    INNER JOIN sys.dm_hadr_availability_replica_states ars 
       ON ag.group_id = ars.group_id
        AND ar.replica_id = ars.replica_id
WHERE ag.[name] = N'$(DistributedAGName)'
    AND ar.[replica_server_name] = @secondary_name
IF COALESCE(@mode, N'') = N'SYNCHRONOUS_COMMIT'
BEGIN
    PRINT N'Synchronous commit established on $(Secondary).';
END
ELSE
BEGIN
    RAISERROR (N'Could not confirm SYNCHRONOUS_COMMIT on $(Primary).  Aborting.', 10, 127);
END
GO
