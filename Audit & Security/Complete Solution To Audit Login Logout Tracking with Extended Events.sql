-- =============================================
-- SQL Server Login/Logout Tracking with Extended Events
-- Tracks successful/failed logins and disconnections
-- =============================================

-- Step 1: Create audit table to store login/logout events
CREATE TABLE dbo.LoginAudit (
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
    EventType VARCHAR(50) NOT NULL,
    EventTime DATETIME2 NOT NULL,
    SessionID INT NULL,
    LoginName NVARCHAR(256) NULL,
    ClientHostName NVARCHAR(256) NULL,
    ClientAppName NVARCHAR(256) NULL,
    DatabaseName NVARCHAR(128) NULL,
    ServerPrincipalName NVARCHAR(256) NULL,
    ErrorNumber INT NULL,
    ErrorSeverity INT NULL,
    ErrorState INT NULL,
    IsSuccessful BIT NOT NULL,
    INDEX IX_LoginAudit_EventTime (EventTime),
    INDEX IX_LoginAudit_LoginName (LoginName)
);
GO

-- Step 2: Create Extended Events session
-- This captures login successes, failures, and logouts
IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name = 'LoginLogoutTracking')
    DROP EVENT SESSION LoginLogoutTracking ON SERVER;
GO

CREATE EVENT SESSION LoginLogoutTracking ON SERVER
ADD EVENT sqlserver.login (
    ACTION (
        sqlserver.session_id,
        sqlserver.client_hostname,
        sqlserver.client_app_name,
        sqlserver.database_name,
        sqlserver.server_principal_name
    )
    WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0)))
),
ADD EVENT sqlserver.logout (
    ACTION (
        sqlserver.session_id,
        sqlserver.client_hostname,
        sqlserver.client_app_name,
        sqlserver.database_name,
        sqlserver.server_principal_name
    )
    WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0)))
),
ADD EVENT sqlserver.error_reported (
    ACTION (
        sqlserver.session_id,
        sqlserver.client_hostname,
        sqlserver.client_app_name,
        sqlserver.server_principal_name
    )
    WHERE (
        [package0].[equal_boolean]([sqlserver].[is_system],(0))
        AND [error_number]=(18456) -- Login failed error
    )
)
ADD TARGET package0.ring_buffer (
    SET max_memory = 4096 -- 4MB buffer
)
WITH (
    MAX_MEMORY = 4096 KB,
    EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY = 30 SECONDS,
    MAX_EVENT_SIZE = 0 KB,
    MEMORY_PARTITION_MODE = NONE,
    TRACK_CAUSALITY = OFF,
    STARTUP_STATE = ON
);
GO

-- Start the Extended Events session
ALTER EVENT SESSION LoginLogoutTracking ON SERVER STATE = START;
GO

-- Step 3: Create procedure to read Extended Events and populate audit table
CREATE OR ALTER PROCEDURE dbo.sp_CaptureLoginLogoutEvents
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @target_data XML;
    
    -- Get the ring buffer data
    SELECT @target_data = CAST(target_data AS XML)
    FROM sys.dm_xe_session_targets AS t
    INNER JOIN sys.dm_xe_sessions AS s ON s.address = t.event_session_address
    WHERE s.name = 'LoginLogoutTracking'
      AND t.target_name = 'ring_buffer';
    
    -- Parse and insert login events
    INSERT INTO dbo.LoginAudit (
        EventType, EventTime, SessionID, LoginName, ClientHostName, 
        ClientAppName, DatabaseName, ServerPrincipalName, ErrorNumber,
        ErrorSeverity, ErrorState, IsSuccessful
    )
    SELECT
        event_data.value('(@name)[1]', 'VARCHAR(50)') AS EventType,
        event_data.value('(@timestamp)[1]', 'DATETIME2') AS EventTime,
        event_data.value('(action[@name="session_id"]/value)[1]', 'INT') AS SessionID,
        event_data.value('(data[@name="server_principal_name"]/value)[1]', 'NVARCHAR(256)') AS LoginName,
        event_data.value('(action[@name="client_hostname"]/value)[1]', 'NVARCHAR(256)') AS ClientHostName,
        event_data.value('(action[@name="client_app_name"]/value)[1]', 'NVARCHAR(256)') AS ClientAppName,
        event_data.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(128)') AS DatabaseName,
        event_data.value('(action[@name="server_principal_name"]/value)[1]', 'NVARCHAR(256)') AS ServerPrincipalName,
        event_data.value('(data[@name="error_number"]/value)[1]', 'INT') AS ErrorNumber,
        event_data.value('(data[@name="severity"]/value)[1]', 'INT') AS ErrorSeverity,
        event_data.value('(data[@name="state"]/value)[1]', 'INT') AS ErrorState,
        CASE 
            WHEN event_data.value('(@name)[1]', 'VARCHAR(50)') = 'error_reported' THEN 0
            ELSE 1
        END AS IsSuccessful
    FROM @target_data.nodes('//RingBufferTarget/event') AS XEventData(event_data)
    WHERE event_data.value('(@timestamp)[1]', 'DATETIME2') > 
          ISNULL((SELECT MAX(EventTime) FROM dbo.LoginAudit), '1900-01-01');
END;
GO

-- Step 4: Create SQL Agent Job to capture events every 5 minutes
-- Note: This requires SQL Server Agent to be running
USE msdb;
GO

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = 'Capture Login Logout Events')
    EXEC sp_delete_job @job_name = 'Capture Login Logout Events';
GO

EXEC sp_add_job 
    @job_name = 'Capture Login Logout Events',
    @enabled = 1,
    @description = 'Captures login/logout events from Extended Events session';

EXEC sp_add_jobstep 
    @job_name = 'Capture Login Logout Events',
    @step_name = 'Execute Capture Procedure',
    @subsystem = 'TSQL',
    @command = 'EXEC dbo.sp_CaptureLoginLogoutEvents;',
    @retry_attempts = 3,
    @retry_interval = 1;

EXEC sp_add_schedule 
    @schedule_name = 'Every5Minutes',
    @freq_type = 4, -- Daily
    @freq_interval = 1,
    @freq_subday_type = 4, -- Minutes
    @freq_subday_interval = 5;

EXEC sp_attach_schedule 
    @job_name = 'Capture Login Logout Events',
    @schedule_name = 'Every5Minutes';

EXEC sp_add_jobserver 
    @job_name = 'Capture Login Logout Events';
GO

-- Step 5: Create procedure to trim audit data older than 90 days
USE master;
GO

CREATE OR ALTER PROCEDURE dbo.sp_TrimLoginAuditData
    @RetentionDays INT = 90
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CutoffDate DATETIME2 = DATEADD(DAY, -@RetentionDays, GETDATE());
    DECLARE @RowsDeleted INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DELETE FROM dbo.LoginAudit
        WHERE EventTime < @CutoffDate;
        
        SET @RowsDeleted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        PRINT 'Successfully deleted ' + CAST(@RowsDeleted AS VARCHAR(20)) + ' audit records older than ' 
              + CAST(@RetentionDays AS VARCHAR(10)) + ' days.';
              
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO

-- Step 6: Create SQL Agent Job to trim old audit data (runs daily)
USE msdb;
GO

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = 'Trim Login Audit Data')
    EXEC sp_delete_job @job_name = 'Trim Login Audit Data';
GO

EXEC sp_add_job 
    @job_name = 'Trim Login Audit Data',
    @enabled = 1,
    @description = 'Removes login audit records older than 90 days';

EXEC sp_add_jobstep 
    @job_name = 'Trim Login Audit Data',
    @step_name = 'Execute Trim Procedure',
    @subsystem = 'TSQL',
    @command = 'EXEC dbo.sp_TrimLoginAuditData @RetentionDays = 90;',
    @database_name = 'master';

EXEC sp_add_schedule 
    @schedule_name = 'Daily2AM',
    @freq_type = 4, -- Daily
    @freq_interval = 1,
    @active_start_time = 020000; -- 2:00 AM

EXEC sp_attach_schedule 
    @job_name = 'Trim Login Audit Data',
    @schedule_name = 'Daily2AM';

EXEC sp_add_jobserver 
    @job_name = 'Trim Login Audit Data';
GO

-- =============================================
-- Query Examples: View Captured Data
-- =============================================

-- View all login/logout activity
SELECT 
    EventType,
    EventTime,
    LoginName,
    ClientHostName,
    ClientAppName,
    DatabaseName,
    IsSuccessful,
    ErrorNumber
FROM dbo.LoginAudit
ORDER BY EventTime DESC;

-- Count logins by user (last 7 days)
SELECT 
    LoginName,
    COUNT(CASE WHEN EventType = 'login' THEN 1 END) AS LoginCount,
    COUNT(CASE WHEN EventType = 'logout' THEN 1 END) AS LogoutCount,
    COUNT(CASE WHEN IsSuccessful = 0 THEN 1 END) AS FailedLoginCount
FROM dbo.LoginAudit
WHERE EventTime >= DATEADD(DAY, -7, GETDATE())
GROUP BY LoginName
ORDER BY LoginCount DESC;

-- Failed login attempts
SELECT 
    EventTime,
    LoginName,
    ClientHostName,
    ClientAppName,
    ErrorNumber
FROM dbo.LoginAudit
WHERE IsSuccessful = 0
ORDER BY EventTime DESC;