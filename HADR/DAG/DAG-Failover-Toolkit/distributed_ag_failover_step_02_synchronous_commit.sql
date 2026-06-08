/*
    Run this on BOTH members of the Distributed AG
*/
GO
:CONNECT $(Primary)
IF '$(SQLCMDSERVER)' = '$(Primary)'
BEGIN
    PRINT N'Connected to $(Primary) to set the availability mode to SYNCHRONOUS COMMIT.';
    BEGIN TRY
        :r ./parse_server_names.sql

        DECLARE @cmd nvarchar(max);

        SET @cmd = N'
        ALTER AVAILABILITY GROUP [$(DistributedAGName)]
        MODIFY AVAILABILITY GROUP ON 
        N''' + @primary_name + N'''
            WITH 
            ( 
              AVAILABILITY_MODE = SYNCHRONOUS_COMMIT 
            )
        , N''' + @secondary_name + N'''
            WITH  
            ( 
              AVAILABILITY_MODE = SYNCHRONOUS_COMMIT 
            );';
        EXEC sys.sp_executesql @cmd;
    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(2048) = N'An error occurred setting synchronous commit on $(Primary): ' + ERROR_MESSAGE();
        RAISERROR (@msg, 10, 127);
    END CATCH
END
ELSE
BEGIN
    RAISERROR (N'Couldn''t connect to $(Primary).  Aborting.', 10, 127);
END
GO
:CONNECT $(Secondary)
IF '$(SQLCMDSERVER)' = '$(Secondary)'
BEGIN
    PRINT N'Connected to $(Secondary) to set the availability mode to SYNCHRONOUS COMMIT.';
    BEGIN TRY
        :r ./parse_server_names.sql

        DECLARE @cmd nvarchar(max);

        SET @cmd = N'
        ALTER AVAILABILITY GROUP [$(DistributedAGName)]
        MODIFY AVAILABILITY GROUP ON 
        N''' + @primary_name + N'''
            WITH 
            ( 
              AVAILABILITY_MODE = SYNCHRONOUS_COMMIT 
            )
        , N''' + @secondary_name + N'''
            WITH  
            ( 
              AVAILABILITY_MODE = SYNCHRONOUS_COMMIT 
            );';
        EXEC sys.sp_executesql @cmd;
    END TRY
    BEGIN CATCH
        RAISERROR (N'An error occurred setting synchronous commit on $(Secondary).', 10, 127);
    END CATCH
END
ELSE
BEGIN
    RAISERROR (N'Couldn''t connect to $(Primary).  Aborting.', 10, 127);
END
GO
