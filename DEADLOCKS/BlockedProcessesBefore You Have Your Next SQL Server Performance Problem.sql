-- First, do this: 
EXEC sys.sp_configure N'show advanced options', 1;
RECONFIGURE;
GO
EXEC sys.sp_configure N'blocked process threshold', 5; --Seconds
RECONFIGURE;
GO

-- Next, you’ll want to set up an Extended Event to house the data from it:
CREATE EVENT SESSION 
    blocked_process_report
ON SERVER
    ADD EVENT 
        sqlserver.blocked_process_report
    ADD TARGET 
        package0.event_file
    (
        SET filename = N'bpr'
    )
WITH
(
    MAX_MEMORY = 4096KB,
    EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY = 5 SECONDS,
    MAX_EVENT_SIZE = 0KB,
    MEMORY_PARTITION_MODE = NONE,
    TRACK_CAUSALITY = OFF,
    STARTUP_STATE = ON
);
GO

ALTER EVENT SESSION
    blocked_process_report
ON SERVER 
    STATE = START;
GO