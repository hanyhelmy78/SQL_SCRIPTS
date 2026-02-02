/*
Important Notes:

This script requires sysadmin or appropriate permissions
The WITH ROLLBACK IMMEDIATE option will disconnect all users
Run during maintenance window to avoid disrupting active connections
Test in a non-production environment first
If you want to exclude specific databases by modifying the WHERE clause
Run this on the PRIMARY replica only
Changes propagate automatically to secondary replicas
*/
-- =============================================
-- Enable RCSI and Set Compatibility Level for AG Databases
-- Must be run on the PRIMARY replica
-- =============================================

-- Set your desired compatibility level here
DECLARE @TargetCompatibilityLevel INT = 160; -- SQL Server 2022 (160), 2019 (150), 2017 (140), 2016 (130)

-- Declare variables
DECLARE @DatabaseName NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);
DECLARE @IsRCSIEnabled BIT;
DECLARE @CurrentCompatLevel INT;

-- Cursor to iterate through all user databases
DECLARE db_cursor CURSOR FOR
SELECT name 
FROM sys.databases
WHERE database_id > 4  -- Exclude system databases
  AND state_desc = 'ONLINE'  -- Only process online databases
  AND is_read_only = 0;  -- Exclude read-only databases

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DatabaseName;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        PRINT '================================================';
        PRINT 'Processing database: ' + @DatabaseName;
        
        -- Check current RCSI status
        SELECT @IsRCSIEnabled = is_read_committed_snapshot_on,
               @CurrentCompatLevel = compatibility_level
        FROM sys.databases
        WHERE name = @DatabaseName;
        
        -- Enable RCSI (no need for single user mode for AG databases)
        IF @IsRCSIEnabled = 0
        BEGIN
            SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;';
            PRINT 'Enabling RCSI...';
            EXEC sp_executesql @SQL;
            PRINT 'RCSI enabled successfully.';
        END
        ELSE
        BEGIN
            PRINT 'RCSI already enabled.';
        END
        
        -- Set compatibility level
        IF @CurrentCompatLevel <> @TargetCompatibilityLevel
        BEGIN
            SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET COMPATIBILITY_LEVEL = ' + CAST(@TargetCompatibilityLevel AS NVARCHAR(10)) + ';';
            PRINT 'Setting compatibility level from ' + CAST(@CurrentCompatLevel AS NVARCHAR(10)) + ' to ' + CAST(@TargetCompatibilityLevel AS NVARCHAR(10)) + '...';
            EXEC sp_executesql @SQL;
            PRINT 'Compatibility level updated successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Compatibility level already set to ' + CAST(@TargetCompatibilityLevel AS NVARCHAR(10)) + '.';
        END
        
        PRINT 'Successfully processed: ' + @DatabaseName;
        
    END TRY
    BEGIN CATCH
        PRINT 'ERROR processing ' + @DatabaseName + ': ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
    END CATCH
    
    FETCH NEXT FROM db_cursor INTO @DatabaseName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

PRINT '================================================';
PRINT 'Process completed!';
PRINT '';

-- Verify RCSI status, compatibility level, and AG membership
SELECT 
    d.name AS DatabaseName,
    d.is_read_committed_snapshot_on AS RCSI_Enabled,
    d.compatibility_level AS CompatibilityLevel,
    ar.replica_server_name AS ReplicaServer,
    ars.role_desc AS ReplicaRole,
    ag.name AS AvailabilityGroupName
FROM sys.databases d
LEFT JOIN sys.dm_hadr_database_replica_states drs ON d.database_id = drs.database_id
LEFT JOIN sys.availability_replicas ar ON drs.replica_id = ar.replica_id
LEFT JOIN sys.dm_hadr_availability_replica_states ars ON ar.replica_id = ars.replica_id
LEFT JOIN sys.availability_groups ag ON ar.group_id = ag.group_id
WHERE d.database_id > 4
ORDER BY d.name;