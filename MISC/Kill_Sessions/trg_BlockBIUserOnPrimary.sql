USE master;
GO

CREATE OR ALTER TRIGGER trg_BlockBIUserOnPrimary
ON ALL SERVER
FOR LOGON
AS
BEGIN
    DECLARE @LoginName NVARCHAR(128) = ORIGINAL_LOGIN();
    DECLARE @IsPrimary BIT = 0;
    
    -- Check if this is the BIUser login
    IF @LoginName = 'BIUser'
    BEGIN
        -- Check if current replica is primary
        -- This query returns 1 if primary, 0 if secondary
        SELECT @IsPrimary = CASE 
            WHEN role_desc = 'PRIMARY' THEN 1 
            ELSE 0 
        END
        FROM sys.dm_hadr_availability_replica_states hrs
        INNER JOIN sys.availability_replicas ar 
            ON hrs.replica_id = ar.replica_id
        WHERE hrs.is_local = 1;
        
        -- If this is the primary replica, deny the connection
        IF @IsPrimary = 1
        BEGIN
            RAISERROR('BIUser is not allowed to connect to the PRIMARY replica. Please connect to a SECONDARY replica.', 16, 1);
            ROLLBACK;
        END
    END
END;
GO