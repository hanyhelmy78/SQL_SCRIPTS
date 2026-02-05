USE msdb;
GO

-- Create the job
EXEC dbo.sp_add_job
    @job_name = N'Monitor BIUser Connections on Primary',
    @enabled = 1,
    @description = N'Kills any active BIUser sessions on the primary replica';
GO

-- Add job step
EXEC dbo.sp_add_jobstep
    @job_name = N'Monitor BIUser Connections on Primary',
    @step_name = N'Kill BIUser Sessions',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'
DECLARE @IsPrimary BIT = 0;
DECLARE @SPID INT;
DECLARE @SQL NVARCHAR(50);

-- Check if this is primary
SELECT @IsPrimary = CASE 
    WHEN role_desc = ''PRIMARY'' THEN 1 
    ELSE 0 
END
FROM sys.dm_hadr_availability_replica_states hrs
INNER JOIN sys.availability_replicas ar 
    ON hrs.replica_id = ar.replica_id
WHERE hrs.is_local = 1;

-- If primary, kill any BIUser sessions
IF @IsPrimary = 1
BEGIN
    DECLARE session_cursor CURSOR FOR
    SELECT session_id
    FROM sys.dm_exec_sessions
    WHERE login_name = ''BIUser''
        AND session_id != @@SPID;
    
    OPEN session_cursor;
    FETCH NEXT FROM session_cursor INTO @SPID;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            SET @SQL = N''KILL '' + CAST(@SPID AS NVARCHAR(10));
            EXEC sp_executesql @SQL;
        END TRY
        BEGIN CATCH
            -- Session may have already terminated
        END CATCH;
        
        FETCH NEXT FROM session_cursor INTO @SPID;
    END;
    
    CLOSE session_cursor;
    DEALLOCATE session_cursor;
END;
',
    @retry_attempts = 3,
    @retry_interval = 1;
GO

-- Add schedule (runs every 5 minutes)
EXEC dbo.sp_add_schedule
    @schedule_name = N'Every_5_Minutes',
    @freq_type = 4, -- Daily
    @freq_interval = 1,
    @freq_subday_type = 4, -- Minutes
    @freq_subday_interval = 5,
    @active_start_time = 0;
GO

-- Attach schedule to job
EXEC dbo.sp_attach_schedule
    @job_name = N'Monitor BIUser Connections on Primary',
    @schedule_name = N'Every_5_Minutes';
GO

-- Add job to local server
EXEC dbo.sp_add_jobserver
    @job_name = N'Monitor BIUser Connections on Primary',
    @server_name = N'(LOCAL)';
GO