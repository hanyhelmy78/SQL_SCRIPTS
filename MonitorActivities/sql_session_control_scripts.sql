-- ============================================================
-- SCENARIO 1: Long Running Query Detection & Termination
-- ============================================================
-- -------------------------------------------------------
-- STEP 1: Audit/Logging Table (run once)
-- -------------------------------------------------------
USE [DBA_Admin];  -- Change here to your DBA utility database
GO

IF OBJECT_ID('dbo.KilledSessionLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.KilledSessionLog (
        LogID            INT IDENTITY(1,1) PRIMARY KEY,
        LogDate          DATETIME2 DEFAULT SYSDATETIME(),
        SessionID        SMALLINT,
        LoginName        NVARCHAR(128),
        DatabaseName     NVARCHAR(128),
        HostName         NVARCHAR(128),
        ProgramName      NVARCHAR(256),
        CommandType      NVARCHAR(32),
        StatementText    NVARCHAR(MAX),
        ElapsedTime_m    DECIMAL(38,2),
        BlockingSessionID SMALLINT,
        KillReason       NVARCHAR(256),
        KilledBy         NVARCHAR(128) DEFAULT SYSTEM_USER,
        IsDryRun         BIT DEFAULT 1   -- 1 = logged only, 0 = actually killed
    );
END
GO
-- -------------------------------------------------------
-- STEP 2: Configuration Table (run once)
-- -------------------------------------------------------
IF OBJECT_ID('dbo.LongQueryKillConfig', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LongQueryKillConfig (
        ConfigID          INT IDENTITY(1,1) PRIMARY KEY,
        ConfigType        NVARCHAR(50),   -- 'USER', 'QUERY_KEYWORD', 'TIME_WINDOW'
        ConfigValue       NVARCHAR(512),
        IsActive          BIT DEFAULT 1,
        Notes             NVARCHAR(256)
    );

    -- Seed example entries
    INSERT INTO dbo.LongQueryKillConfig (ConfigType, ConfigValue, Notes) VALUES
    ('USER',         'BI_USER',   'Reporting service account'),
    ('USER',         'RMS_USER',      'RMS account'),
    ('QUERY_KEYWORD','##GlobalTempTable', 'Queries using global temp tables'),
    ('QUERY_KEYWORD','NOLOCK',            'Dirty-read queries above threshold'),
    ('TIME_WINDOW',  '22:30:00:00',       'time of the last incident - more aggressive kill');

    -- Enable live kill mode (required only when @DryRun = 0)
INSERT INTO dbo.LongQueryKillConfig (ConfigType, ConfigValue, Notes)
VALUES ('KILL_ENABLED', '1', 'Flip this to 0 to disable all live kills instantly');
END
GO
-- -------------------------------------------------------
-- STEP 3: The Core Stored Procedure
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.usp_KillLongRunningSessions
    @MaxElapsedMinutes     INT     = 30,    -- Kill if running longer than this
    @KillBlockingSessions  BIT     = 1,     -- Also kill sessions blocking others
    @BlockingThreshold_m   INT     = 5,     -- Only kill blockers running > N minutes
    @DryRun                BIT     = 1,     -- 1 = log only (SAFE DEFAULT), 0 = actually kill sessions
    @DebugMode             BIT     = 0      -- Print diagnostic info
AS
BEGIN
    SET NOCOUNT ON;

    -- ── Safety checks ──────────────────────────────────────────────────────────
    IF @DryRun = 0
    BEGIN
        -- Require explicit confirmation flag when running live
        IF NOT EXISTS (
            SELECT 1 FROM dbo.LongQueryKillConfig
            WHERE ConfigType = 'KILL_ENABLED' AND ConfigValue = '1' AND IsActive = 1
        )
        BEGIN
            RAISERROR('Live KILL is disabled. Set ConfigType=KILL_ENABLED, ConfigValue=1 to enable.', 16, 1);
            RETURN;
        END
    END

    -- ── Resolve configuration ──────────────────────────────────────────────────
    -- Load target users from config
    DECLARE @TargetUsers TABLE (LoginName NVARCHAR(128));
    INSERT INTO @TargetUsers
    SELECT ConfigValue FROM dbo.LongQueryKillConfig
    WHERE ConfigType = 'USER' AND IsActive = 1;

    -- Load query keywords from config
    DECLARE @QueryKeywords TABLE (Keyword NVARCHAR(512));
    INSERT INTO @QueryKeywords
    SELECT ConfigValue FROM dbo.LongQueryKillConfig
    WHERE ConfigType = 'QUERY_KEYWORD' AND IsActive = 1;

    -- Detect if current time falls in any configured "active kill window"
    DECLARE @InKillWindow BIT = 0;
    IF EXISTS (
        SELECT 1 FROM dbo.LongQueryKillConfig
        WHERE ConfigType = 'TIME_WINDOW' AND IsActive = 1
          AND (
            -- Handle windows that don't cross midnight (e.g., '09:00:00:00')
            (
                CHARINDEX('-', ConfigValue) > 0
                AND CAST(SUBSTRING(ConfigValue, 1, CHARINDEX('-',ConfigValue)-1) AS TIME)
                    <= CAST(GETDATE() AS TIME)
                AND CAST(GETDATE() AS TIME)
                    <= CAST(SUBSTRING(ConfigValue, CHARINDEX('-',ConfigValue)+1, 10) AS TIME)
                AND CAST(SUBSTRING(ConfigValue, 1, CHARINDEX('-',ConfigValue)-1) AS TIME)
                    < CAST(SUBSTRING(ConfigValue, CHARINDEX('-',ConfigValue)+1, 10) AS TIME)
            )
            OR
            -- Handle overnight windows (e.g., '22:30:00:00')
            (
                CHARINDEX('-', ConfigValue) > 0
                AND CAST(SUBSTRING(ConfigValue, 1, CHARINDEX('-',ConfigValue)-1) AS TIME)
                    > CAST(SUBSTRING(ConfigValue, CHARINDEX('-',ConfigValue)+1, 10) AS TIME)
                AND (
                    CAST(GETDATE() AS TIME) >= CAST(SUBSTRING(ConfigValue, 1, CHARINDEX('-',ConfigValue)-1) AS TIME)
                    OR CAST(GETDATE() AS TIME) <= CAST(SUBSTRING(ConfigValue, CHARINDEX('-',ConfigValue)+1, 10) AS TIME)
                )
            )
          )
    )
    SET @InKillWindow = 1;

    IF @DebugMode = 1
        PRINT 'In Kill Window: ' + CAST(@InKillWindow AS VARCHAR);

    -- Only proceed outside a defined kill window if no window is configured,
    -- OR if we ARE inside one. This makes time-window optional.
    IF NOT EXISTS (SELECT 1 FROM dbo.LongQueryKillConfig WHERE ConfigType = 'TIME_WINDOW' AND IsActive = 1)
        SET @InKillWindow = 1;  -- No window configured = always active

    IF @InKillWindow = 0
    BEGIN
        IF @DebugMode = 1
            PRINT 'Outside kill window. Exiting.';
        RETURN;
    END

    -- ── Identify candidate sessions ────────────────────────────────────────────
    DECLARE @Candidates TABLE (
        SessionID         SMALLINT,
        LoginName         NVARCHAR(128),
        DatabaseName      NVARCHAR(128),
        HostName          NVARCHAR(128),
        ProgramName       NVARCHAR(256),
        CommandType       NVARCHAR(32),
        StatementText     NVARCHAR(MAX),
        ElapsedTime_m     DECIMAL(38,2),
        BlockingSessionID SMALLINT,
        KillReason        NVARCHAR(256)
    );

    -- Exclude system sessions and our own session
    INSERT INTO @Candidates
    SELECT
        er.session_id,
        es.login_name,
        DB_NAME(er.database_id),
        es.host_name,
        es.program_name,
        er.command,
        est.text,
        CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0),
        er.blocking_session_id,
        CASE
            WHEN CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0) > @MaxElapsedMinutes
              AND EXISTS (SELECT 1 FROM @TargetUsers tu WHERE tu.LoginName = es.login_name)
                THEN 'Exceeded ' + CAST(@MaxElapsedMinutes AS VARCHAR) + ' min threshold [Target User]'
            WHEN CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0) > @MaxElapsedMinutes
              AND EXISTS (SELECT 1 FROM @QueryKeywords qk WHERE est.text LIKE '%' + qk.Keyword + '%')
                THEN 'Exceeded ' + CAST(@MaxElapsedMinutes AS VARCHAR) + ' min threshold [Target Query]'
            WHEN CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0) > @MaxElapsedMinutes
                THEN 'Exceeded ' + CAST(@MaxElapsedMinutes AS VARCHAR) + ' min threshold [General]'
            WHEN @KillBlockingSessions = 1
              AND er.blocking_session_id > 0
              AND CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0) > @BlockingThreshold_m
                THEN 'Blocking other sessions for > ' + CAST(@BlockingThreshold_m AS VARCHAR) + ' min'
            ELSE NULL
        END
    FROM sys.dm_exec_requests AS er
    INNER JOIN sys.dm_exec_sessions AS es
        ON er.session_id = es.session_id
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS est
    WHERE er.session_id <> @@SPID       -- Never kill ourselves
      AND es.is_user_process = 1        -- Never kill system sessions
      AND er.session_id > 50            -- Defensive: skip reserved system IDs
      AND es.login_name NOT IN (        -- Protect privileged accounts
            'sa', 'NT AUTHORITY\SYSTEM',
            'NT SERVICE\MSSQLSERVER',
            'NT SERVICE\SQLSERVERAGENT'
          )
      AND (
            -- Condition 1: Long-running + user match OR keyword match OR general threshold
            (
                CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0) > @MaxElapsedMinutes
                AND (
                    EXISTS (SELECT 1 FROM @TargetUsers tu WHERE tu.LoginName = es.login_name)
                    OR EXISTS (SELECT 1 FROM @QueryKeywords qk WHERE est.text LIKE '%' + qk.Keyword + '%')
                    OR NOT EXISTS (SELECT 1 FROM @TargetUsers) -- kill all if no users configured
                )
            )
            OR
            -- Condition 2: Blocking others beyond threshold
            (
                @KillBlockingSessions = 1
                AND er.blocking_session_id > 0
                AND CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0) > @BlockingThreshold_m
            )
          );

    IF @DebugMode = 1
    BEGIN
        SELECT 'Candidates' AS Info, * FROM @Candidates;
    END

    -- ── Log & optionally KILL ──────────────────────────────────────────────────
    DECLARE @SessionID    SMALLINT;
    DECLARE @KillReason   NVARCHAR(256);
    DECLARE @KillSQL      NVARCHAR(50);
    DECLARE @LogID        INT;

    DECLARE kill_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT SessionID, KillReason FROM @Candidates WHERE KillReason IS NOT NULL;

    OPEN kill_cursor;
    FETCH NEXT FROM kill_cursor INTO @SessionID, @KillReason;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Always log first
        INSERT INTO dbo.KilledSessionLog
            (SessionID, LoginName, DatabaseName, HostName, ProgramName,
             CommandType, StatementText, ElapsedTime_m, BlockingSessionID, KillReason, IsDryRun)
        SELECT
            c.SessionID, c.LoginName, c.DatabaseName, c.HostName, c.ProgramName,
            c.CommandType, c.StatementText, c.ElapsedTime_m, c.BlockingSessionID,
            c.KillReason, @DryRun
        FROM @Candidates c WHERE c.SessionID = @SessionID;

        SET @LogID = SCOPE_IDENTITY();

        IF @DryRun = 0
        BEGIN
            BEGIN TRY
                SET @KillSQL = N'KILL ' + CAST(@SessionID AS NVARCHAR(10));
                EXEC sp_executesql @KillSQL;

                IF @DebugMode = 1
                    PRINT 'KILLED session ' + CAST(@SessionID AS VARCHAR) + ' | Reason: ' + @KillReason;
            END TRY
            BEGIN CATCH
                -- Session may have already ended; update log with error
                UPDATE dbo.KilledSessionLog
                SET KillReason = KillReason + ' [KILL ERROR: ' + ERROR_MESSAGE() + ']'
                WHERE LogID = @LogID;
            END CATCH
        END
        ELSE
        BEGIN
            IF @DebugMode = 1
                PRINT '[DRY RUN] Would KILL session ' + CAST(@SessionID AS VARCHAR) + ' | Reason: ' + @KillReason;
        END

        FETCH NEXT FROM kill_cursor INTO @SessionID, @KillReason;
    END

    CLOSE kill_cursor;
    DEALLOCATE kill_cursor;
END
GO
-- ============================================================
-- SCENARIO 1: SQL Agent Job Creation Script
-- ============================================================

USE [msdb];
GO
-- Create the job (runs every 5 minutes)
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'DBA - Kill Long Running Sessions')
BEGIN
    EXEC sp_add_job
        @job_name = N'DBA - Kill Long Running Sessions',
        @enabled = 1,
        @description = N'Detects and terminates long-running, blocking, or target-user sessions per configuration.',
        @category_name = N'[Uncategorized (Local)]',
        @owner_login_name = N'sa';

    EXEC sp_add_jobstep
        @job_name = N'DBA - Kill Long Running Sessions',
        @step_name = N'Execute Kill Procedure',
        @subsystem = N'TSQL',
        @command = N'
EXEC DBA_Admin.dbo.usp_KillLongRunningSessions
    @MaxElapsedMinutes    = 30,
    @KillBlockingSessions = 1,
    @BlockingThreshold_m  = 5,
    @DryRun               = 0, -- this will actually kill the sessions
    @DebugMode            = 0;
',
        @database_name = N'DBA_Admin', -- CHANGE YOUR DATABASE NAME HERE !!**
        @on_success_action = 1,  -- Quit with success
        @on_fail_action = 2;     -- Quit with failure

    EXEC sp_add_schedule
        @schedule_name = N'Every 5 Minutes',
        @freq_type = 4,           -- Daily
        @freq_interval = 1,
        @freq_subday_type = 4,    -- Minutes
        @freq_subday_interval = 5,
        @active_start_time = 0;

    EXEC sp_attach_schedule
        @job_name = N'DBA - Kill Long Running Sessions',
        @schedule_name = N'Every 5 Minutes';

    EXEC sp_add_jobserver
        @job_name = N'DBA - Kill Long Running Sessions',
        @server_name = N'(local)';
END
GO
-- ============================================================
-- SCENARIO 2: Large Result Set Detection & Termination
-- ============================================================
-- -------------------------------------------------------
-- How It Works:
-- SQL Server does not expose row counts for in-flight queries natively. The strategy is:

--   1. Detect queries that have been running long and their plan contains large row estimates (plan_rows)
--   2. Detect queries with massive logical reads as a candidate for large scans (high reads = likely large result)
--   3. Detect queries with high row counts already written to tempdb (sort spills, worktables)
-- -------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.usp_KillLargeResultSetQueries
    @MaxLogicalReads      BIGINT  = 5000000,    -- 5M page reads, large scan
    @MaxTempdbSpillPages  BIGINT  = 100000,     -- Sort spills to tempdb
    @MaxGrantedMemoryMB   INT     = 2048,       -- Memory grant threshold (2 GB)
    @MinElapsedMinutes    INT     = 2,          -- Ignore very new queries
    @DryRun               BIT     = 1,
    @DebugMode            BIT     = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Candidates TABLE (
        SessionID       SMALLINT,
        LoginName       NVARCHAR(128),
        DatabaseName    NVARCHAR(128),
        StatementText   NVARCHAR(MAX),
        ElapsedTime_m   DECIMAL(38,2),
        LogicalReads    BIGINT,
        GrantedMemoryMB DECIMAL(10,2),
        TempdbSpillKB   BIGINT,
        EstimatedRows   FLOAT,
        KillReason      NVARCHAR(512)
    );

    -- Collect suspect queries via DMVs + query plan stats
    INSERT INTO @Candidates
    SELECT
        er.session_id,
        es.login_name,
        DB_NAME(er.database_id),
        est.text,
        CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0),
        er.logical_reads,
        CONVERT(DECIMAL(10,2), mg.granted_memory_kb / 1024.0),
        ISNULL(mg.used_memory_kb, 0) - ISNULL(mg.granted_memory_kb, 0),  -- spill approx
        -- Pull estimated output rows from the query plan
        TRY_CAST(qp.query_plan.value(
            '(//RelOp[@NodeId=0]/@EstimateRows)[1]',
            'FLOAT') AS FLOAT),
        CASE
            WHEN er.logical_reads > @MaxLogicalReads
                THEN 'Logical reads exceeded ' + FORMAT(@MaxLogicalReads,'N0')
                     + ' (actual: ' + FORMAT(er.logical_reads,'N0') + ')'
            WHEN mg.granted_memory_kb / 1024.0 > @MaxGrantedMemoryMB
                THEN 'Memory grant exceeded ' + CAST(@MaxGrantedMemoryMB AS VARCHAR)
                     + ' MB (actual: ' + CAST(CAST(mg.granted_memory_kb/1024.0 AS INT) AS VARCHAR) + ' MB)'
            ELSE NULL
        END
    FROM sys.dm_exec_requests AS er
    INNER JOIN sys.dm_exec_sessions AS es
        ON er.session_id = es.session_id
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS est
    CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) AS qp
    LEFT JOIN sys.dm_exec_query_memory_grants AS mg
        ON er.session_id = mg.session_id
    WHERE er.session_id <> @@SPID
      AND es.is_user_process = 1
      AND er.session_id > 50
      AND es.login_name NOT IN ('sa','NT AUTHORITY\SYSTEM','NT SERVICE\MSSQLSERVER','NT SERVICE\SQLSERVERAGENT')
      AND CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0) >= @MinElapsedMinutes
      AND (
            er.logical_reads > @MaxLogicalReads
            OR (mg.granted_memory_kb / 1024.0) > @MaxGrantedMemoryMB
          );

    IF @DebugMode = 1
        SELECT 'Large Result Candidates' AS Info, * FROM @Candidates;

    -- Log & Kill (same pattern as Scenario 1)
    DECLARE @SessionID  SMALLINT;
    DECLARE @Reason     NVARCHAR(512);
    DECLARE @KillSQL    NVARCHAR(50);
    DECLARE @LogID      INT;

    DECLARE c CURSOR LOCAL FAST_FORWARD FOR
        SELECT SessionID, KillReason FROM @Candidates WHERE KillReason IS NOT NULL;

    OPEN c;
    FETCH NEXT FROM c INTO @SessionID, @Reason;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO dbo.KilledSessionLog
            (SessionID, LoginName, DatabaseName, StatementText, ElapsedTime_m, KillReason, IsDryRun)
        SELECT SessionID, LoginName, DatabaseName, StatementText, ElapsedTime_m,
               @Reason, @DryRun
        FROM @Candidates WHERE SessionID = @SessionID;

        SET @LogID = SCOPE_IDENTITY();

        IF @DryRun = 0
        BEGIN
            BEGIN TRY
                SET @KillSQL = N'KILL ' + CAST(@SessionID AS NVARCHAR(10));
                EXEC sp_executesql @KillSQL;
            END TRY
            BEGIN CATCH
                UPDATE dbo.KilledSessionLog
                SET KillReason = KillReason + ' [KILL ERROR: ' + ERROR_MESSAGE() + ']'
                WHERE LogID = @LogID;
            END CATCH
        END

        FETCH NEXT FROM c INTO @SessionID, @Reason;
    END

    CLOSE c; DEALLOCATE c;
END
GO
-- ============================================================
-- SCENARIO 2: SQL Agent Job Creation Script
-- ============================================================

USE [msdb];
GO
-- Create the job (runs every 5 minutes)
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'DBA - Kill Large Result-set Queries')
BEGIN
    EXEC sp_add_job
        @job_name = N'DBA - Kill Large Result-set Queries',
        @enabled = 1,
        @description = N'Detects and terminates Large Result-set Queries.',
        @category_name = N'[Uncategorized (Local)]',
        @owner_login_name = N'sa';

    EXEC sp_add_jobstep
        @job_name = N'DBA - Kill Large Result-set Queries',
        @step_name = N'Execute Kill Procedure',
        @subsystem = N'TSQL',
        @command = N'
EXEC DBA_Admin.dbo.usp_KillLargeResultSetQueries
    @MaxLogicalReads        = 5000000,    -- 5M page reads, large scan
    @MaxTempdbSpillPages    = 100000,     -- Sort spills to tempdb
    @MaxGrantedMemoryMB     = 2048,       -- Memory grant threshold (2 GB)
    @MinElapsedMinutes      = 2,          -- Ignore very new queries
    @DryRun                 = 1,          -- this will actually kill the sessions
    @DebugMode              = 0
    ',
        @database_name = N'DBA_Admin', -- CHANGE YOUR DATABASE NAME HERE !!** 
        @on_success_action = 1,  -- Quit with success
        @on_fail_action = 2;     -- Quit with failure

    EXEC sp_add_schedule
        @schedule_name = N'Every 10 Minutes',
        @freq_type = 4,           -- Daily
        @freq_interval = 1,
        @freq_subday_type = 4,    -- Minutes
        @freq_subday_interval = 10,
        @active_start_time = 0;

    EXEC sp_attach_schedule
        @job_name = N'DBA - Kill Large Result-set Queries',
        @schedule_name = N'Every 10 Minutes';

    EXEC sp_add_jobserver
        @job_name = N'DBA - Kill Large Result-set Queries',
        @server_name = N'(local)';
END
GO
-- ============================================================
-- SCENARIO 3: Resource Governor — Per-User Memory Limits
-- ============================================================
-- -------------------------------------------------------
-- STEP 1: Create a Resource Pool for the restricted user
-- -------------------------------------------------------
-- Adjust MIN/MAX percentages based on your hardware.
-- For a 32-core, 256 GB RAM server example:
--   MAX_CPU_PERCENT = 20  → capped at 20% of total CPU
--   MAX_MEMORY_PERCENT = 10 → capped at 25.6 GB RAM
-- -------------------------------------------------------
USE [master];
GO
IF NOT EXISTS (SELECT 1 FROM sys.resource_governor_resource_pools WHERE name = 'pool_restricted_users')
BEGIN
    CREATE RESOURCE POOL pool_restricted_users
    WITH (
        MIN_CPU_PERCENT       = 0,    -- No guaranteed minimum
        MAX_CPU_PERCENT       = 20,   -- Hard cap at 20% CPU
        MIN_MEMORY_PERCENT    = 0,    -- No guaranteed minimum memory
        MAX_MEMORY_PERCENT    = 15,   -- Hard cap at 15% of server memory
        MIN_IOPS_PER_VOLUME   = 0,
        MAX_IOPS_PER_VOLUME   = 500   -- IO throttle
    );
END
GO
-- -------------------------------------------------------
-- STEP 2: Create a Workload Group linked to the pool
-- -------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.resource_governor_workload_groups WHERE name = 'wg_restricted_users')
BEGIN
    CREATE WORKLOAD GROUP wg_restricted_users
    WITH (
        IMPORTANCE                  = LOW,
        REQUEST_MAX_MEMORY_GRANT_PERCENT = 10,-- Max memory grant per single query (% of buffer pool)
        REQUEST_MAX_CPU_TIME_SEC    = 1800,      -- Auto-kill query after 30 minutes CPU time
        REQUEST_MEMORY_GRANT_TIMEOUT_SEC = 120, -- Give up on memory grant after 2 minutes
        GROUP_MAX_REQUESTS          = 5          -- Max concurrent requests in this group
    )
    USING pool_restricted_users;
END
GO
-- -------------------------------------------------------
-- STEP 3: Classifier Function
-- Maps sessions to the restricted workload group
-- based on login name. Add more users as needed.
-- -------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.fn_RG_Classifier()
RETURNS SYSNAME
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @WorkloadGroup SYSNAME;

    -- Restricted users list — add/remove users here as needed
    IF SUSER_SNAME() IN (
        'BI_USER',
        'RMS_USER'
    )
        SET @WorkloadGroup = 'wg_restricted_users';
    ELSE
        SET @WorkloadGroup = 'default';
    RETURN @WorkloadGroup;
END
GO
-- -------------------------------------------------------
-- STEP 4: Register classifier & reconfigure
-- -------------------------------------------------------
ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = dbo.fn_RG_Classifier);
GO

ALTER RESOURCE GOVERNOR RECONFIGURE;
GO
-- -------------------------------------------------------
-- STEP 5: Verify Resource Governor is ENABLED
-- -------------------------------------------------------
-- Check current state:
SELECT
    is_enabled,
    classifier_function_id,
    OBJECT_NAME(classifier_function_id) AS ClassifierFunctionName
FROM sys.resource_governor_configuration;
-- is_enabled =1

-- If not enabled:
-- ALTER RESOURCE GOVERNOR RECONFIGURE;
-- -------------------------------------------------------
-- MONITORING QUERIES
-- -------------------------------------------------------
-- View pool & workload group stats

SELECT
    rp.name AS PoolName,
    rp.max_cpu_percent,
    rp.max_memory_percent,
    rpstats.active_memgrant_count Active_Memory_grant_Count,
    rpstats.active_memgrant_kb Active_Memory_grant_KB,
    CONVERT(DECIMAL(10,2), rpstats.used_memgrant_kb / 1024.0) AS UsedMemGrant_MB
FROM sys.resource_governor_resource_pools AS rp
JOIN sys.dm_resource_governor_resource_pools AS rpstats
    ON rp.pool_id = rpstats.pool_id;

-- See which workload group each active session is in
SELECT
    es.session_id,
    es.login_name,
    wg.name AS WorkloadGroup,
    rp.name AS ResourcePool,
    er.command,
    CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0) AS ElapsedTime_m,
    er.granted_query_memory / 128 AS GrantedMemory_MB
FROM sys.dm_exec_sessions AS es
INNER JOIN sys.dm_resource_governor_workload_groups AS wg
    ON es.group_id = wg.group_id
INNER JOIN sys.dm_resource_governor_resource_pools AS rp
    ON wg.pool_id = rp.pool_id
LEFT JOIN sys.dm_exec_requests AS er
    ON es.session_id = er.session_id
WHERE es.is_user_process = 1
ORDER BY ElapsedTime_m DESC;
-- ============================================================
-- DIAGNOSTIC / MONITORING QUERIES (All Scenarios)
-- ============================================================
-- View Kill History

SELECT TOP 100
    LogDate,
    SessionID,
    LoginName,
    DatabaseName,
    LEFT(StatementText, 200)   AS StatementPreview,
    ElapsedTime_m,
    KillReason,
    KilledBy,
    CASE WHEN IsDryRun = 1 THEN 'DRY RUN' ELSE 'KILLED' END AS Action
FROM DBA_Admin.dbo.KilledSessionLog -- Don`t forget to change you DB name here
ORDER BY LogDate DESC;

-- Current long-running sessions snapshot (base monitoring query)
SELECT
    DB_NAME(er.database_id)                                       AS DatabaseName,
    er.session_id                                                 AS SessionID,
    es.login_name                                                 AS LoginName,
    es.host_name                                                  AS HostName,
    er.command                                                    AS CommandType,
    est.text                                                      AS StatementText,
    er.status                                                     AS Status,
    CONVERT(DECIMAL(5,2), er.percent_complete)                    AS Complete_Percent,
    CONVERT(DECIMAL(38,2), er.total_elapsed_time / 60000.0)       AS ElapsedTime_m,
    CONVERT(DECIMAL(38,2), er.estimated_completion_time / 60000.0) AS EstimatedCompletion_m,
    er.logical_reads                                              AS LogicalReads,
    er.blocking_session_id                                        AS BlockedBy,
    er.last_wait_type                                             AS LastWait,
    er.wait_resource                                              AS CurrentWait,
    mg.granted_memory_kb / 1024                                   AS GrantedMemory_MB
FROM sys.dm_exec_requests AS er
INNER JOIN sys.dm_exec_sessions AS es
    ON er.session_id = es.session_id
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS est
LEFT JOIN sys.dm_exec_query_memory_grants AS mg
    ON er.session_id = mg.session_id
WHERE es.is_user_process = 1
ORDER BY ElapsedTime_m DESC;