/*
    Confirm we're on the Distributed AG Primary.

    You should see a single row-per-Distributed AG where the primary Distributed AG
    is the local server.
*/
GO
PRINT N'';
PRINT N'Connecting to $(Primary) to ensure it is the primary.';
GO
:CONNECT $(Primary)
PRINT N'';
SET ANSI_WARNINGS OFF;

DECLARE @AGName     sysname;
DECLARE @IsPrimary  bit;
DECLARE @msg        nvarchar(1000);
DECLARE @item       nvarchar(30);
DECLARE @value      nvarchar(128);

DECLARE cur CURSOR LOCAL FORWARD_ONLY READ_ONLY STATIC
FOR
WITH src AS
(
    SELECT 
          [Distributed AG Name]         = CONVERT(nvarchar(128), ag.[name])
        , [Distributed AG Local Role]   = CONVERT(nvarchar(128), ars.[role_desc])
        , [Local AG Name]               = CONVERT(nvarchar(128), ag1.[name])
        , [Replica Server]              = CONVERT(nvarchar(128), ar.[replica_server_name])
        , [Local AG Role]               = CONVERT(nvarchar(128), arsl.[role_desc])
        , [Local AG Operational State]  = CONVERT(nvarchar(128), COALESCE(arsl.[operational_state_desc], N'<secondary>'))
        , [Local AG Connected State]    = CONVERT(nvarchar(128), arsl.[connected_state_desc])
        , [Local AG Recovery Health]    = CONVERT(nvarchar(128), arsl.[recovery_health_desc])
        , [Local AG Sync Health]        = CONVERT(nvarchar(128), arsl.[synchronization_health_desc])
    FROM sys.availability_groups ag 
        INNER JOIN sys.dm_hadr_availability_replica_states ars 
           ON ag.[group_id] = ars.[group_id]
        CROSS APPLY sys.fn_hadr_distributed_ag_replica(ag.[group_id], ars.[replica_id]) hdar
        INNER JOIN sys.availability_groups ag1 ON hdar.[group_id] = ag1.[group_id]
        INNER JOIN sys.availability_replicas ar ON ag1.[group_id] = ar.[group_id]
        INNER JOIN sys.dm_hadr_availability_replica_states arsl ON ar.[replica_id] = arsl.[replica_id] 
    WHERE ar.[replica_server_name] = @@SERVERNAME
        AND ag.[name] = N'$(DistributedAGName)'
)
SELECT 
      up.[Item]
    , up.[value]
FROM src
UNPIVOT 
(
    [value]
    FOR [Item] IN 
    (
          [Distributed AG Name]       
        , [Distributed AG Local Role] 
        , [Local AG Name]             
        , [Replica Server]              
        , [Local AG Role]             
        , [Local AG Operational State]
        , [Local AG Connected State]  
        , [Local AG Recovery Health]  
        , [Local AG Sync Health]          
    )
) up;

OPEN cur;
FETCH NEXT FROM cur INTO @item, @value;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CONVERT(nchar(30), @item) + ': ' + @value;
    IF @item = N'Distributed AG Name'
    BEGIN
        SET @AGName = @value;
    END
    IF @item = N'Distributed AG Local Role'
    BEGIN
        SET @IsPrimary = CASE WHEN @value = N'PRIMARY' THEN 1 ELSE 0 END
    END
    FETCH NEXT FROM cur INTO @item, @value;
END
CLOSE cur;
DEALLOCATE cur;
PRINT N'';

IF @AGName <> '$(DistributedAGName)'
BEGIN
    SET @msg = N'Specified AG Name ($(DistributedAGName)) not found.  Aborting.';
    RAISERROR (@msg, 14, 127);
END

IF @IsPrimary = 0
BEGIN
    SET @msg = N'Specfied primary server ($(Primary)) is not the current primary for the Distributed AG ($(DistributedAGName)).  Aborting.';
    RAISERROR (@msg, 14, 127);
END
GO