/*
    Reset to Asynchronous Commit, if desired.
*/
GO
IF UPPER('$(SetToAsyncCommitAfterFailover)') = 'YES'
BEGIN
    PRINT N'Setting Distributed AG [$(DistributedAGName)] to asynchronous commit post failover.';
END
GO
:CONNECT $(Primary)

:r ./parse_server_names.sql


IF UPPER('$(SetToAsyncCommitAfterFailover)') = 'YES'
BEGIN
        DECLARE @cmd nvarchar(max);

        SET @cmd = N'
        ALTER AVAILABILITY GROUP [$(DistributedAGName)]
        MODIFY AVAILABILITY GROUP ON 
        N''' + @primary_name + N'''
            WITH 
            ( 
              AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT 
            )
        , N''' + @secondary_name + N'''
            WITH  
            ( 
              AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT 
            );';
        EXEC sys.sp_executesql @cmd;
END
GO
:CONNECT $(Secondary)
:r ./parse_server_names.sql
IF UPPER('$(SetToAsyncCommitAfterFailover)') = 'YES'
BEGIN
        DECLARE @cmd nvarchar(max);

        SET @cmd = N'
        ALTER AVAILABILITY GROUP [$(DistributedAGName)]
        MODIFY AVAILABILITY GROUP ON 
        N''' + @primary_name + N'''
            WITH 
            ( 
              AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT 
            )
        , N''' + @secondary_name + N'''
            WITH  
            ( 
              AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT 
            );';
        EXEC sys.sp_executesql @cmd;
END
GO
