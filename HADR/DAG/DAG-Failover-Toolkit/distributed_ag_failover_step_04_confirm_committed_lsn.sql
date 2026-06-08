/*
    Confirm the LSN for all involved databases prior to failover
    to ensure no data loss.
*/
GO
DECLARE @delay_seconds int;
SET @delay_seconds = $(SyncWaitSeconds);
DECLARE @msg varchar(100) = N'Waiting for LSN hardening for ' + CONVERT(nvarchar(11), @delay_seconds) + N' seconds.';
RAISERROR (@msg, 0, 1) WITH NOWAIT;
GO
DECLARE @delay_seconds int;
SET @delay_seconds = $(SyncWaitSeconds);
DECLARE @delay DATETIME = DATEADD(SECOND, @delay_seconds, 0);
WAITFOR DELAY @delay;
GO
:CONNECT $(Primary)
:OUT ./lsn-primary.sql
GO
/* Per-row PRINT avoids the 4000-character nvarchar(max) truncation limit. */
DECLARE @ag_name     sysname;
DECLARE @db_name     sysname;
DECLARE @is_local    varchar(3);
DECLARE @sync_state  nvarchar(60);
DECLARE @lsn         nvarchar(48);
DECLARE @first       bit          = 1;
DECLARE @rows        int;
DECLARE @cur         CURSOR;

SET @cur = CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
    SELECT 
          ag.[name]
        , d.[name]
        , CASE hdrs.[is_local] WHEN 1 THEN N'YES' ELSE N'' END
        , hdrs.[synchronization_state_desc]
        , CONVERT(nvarchar(48), hdrs.[last_hardened_lsn], 0)
    FROM sys.dm_hadr_database_replica_states AS hdrs
        INNER JOIN sys.availability_replicas AS ar
            ON hdrs.[replica_id] = ar.[replica_id]
            AND hdrs.[group_id] = ar.[group_id]
        INNER JOIN sys.availability_groups AS ag
            ON hdrs.[group_id] = ag.[group_id]
        INNER JOIN sys.databases AS d
            ON hdrs.[database_id] = d.[database_id]
        INNER JOIN sys.dm_hadr_availability_replica_states AS ars
            ON ag.[group_id] = ars.[group_id]
            AND ar.[replica_id] = ars.[replica_id]
    WHERE hdrs.[is_local] = 1
    ORDER BY d.[name];

OPEN @cur;
SET @rows = @@CURSOR_ROWS;

WHILE @rows > 0
BEGIN
    FETCH NEXT FROM @cur INTO @ag_name, @db_name, @is_local, @sync_state, @lsn;
    IF @first = 0
    BEGIN
        PRINT N'UNION ALL';
    END
    PRINT N'SELECT [AG Name] = N''' + @ag_name + N''''
        + N', [Database Name] = N''' + @db_name + N''''
        + N', [Local Database] = N''' + @is_local + N''''
        + N', [Synchronization State] = N''' + @sync_state + N''''
        + N', [Last Hardened LSN] = N''' + @lsn + N'''';
    SET @first = 0;
    SET @rows = @rows - 1;
END

CLOSE @cur;
DEALLOCATE @cur;
PRINT N';';
GO
:OUT stdout
GO
:CONNECT $(Secondary)
:OUT ./lsn-secondary.sql
GO
/* Per-row PRINT avoids the 4000-character nvarchar(max) truncation limit. */
DECLARE @ag_name     sysname;
DECLARE @db_name     sysname;
DECLARE @is_local    varchar(3);
DECLARE @sync_state  nvarchar(60);
DECLARE @lsn         nvarchar(48);
DECLARE @first       bit          = 1;
DECLARE @rows        int;
DECLARE @cur         CURSOR;

SET @cur = CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
    SELECT 
          ag.[name]
        , d.[name]
        , CASE hdrs.[is_local] WHEN 1 THEN N'YES' ELSE N'' END
        , hdrs.[synchronization_state_desc]
        , CONVERT(nvarchar(48), hdrs.[last_hardened_lsn], 0)
    FROM sys.dm_hadr_database_replica_states AS hdrs
        INNER JOIN sys.availability_replicas AS ar
            ON hdrs.[replica_id] = ar.[replica_id]
            AND hdrs.[group_id] = ar.[group_id]
        INNER JOIN sys.availability_groups AS ag
            ON hdrs.[group_id] = ag.[group_id]
        INNER JOIN sys.databases AS d
            ON hdrs.[database_id] = d.[database_id]
        INNER JOIN sys.dm_hadr_availability_replica_states AS ars
            ON ag.[group_id] = ars.[group_id]
            AND ar.[replica_id] = ars.[replica_id]
    WHERE hdrs.[is_local] = 1
    ORDER BY d.[name];

OPEN @cur;
SET @rows = @@CURSOR_ROWS;

WHILE @rows > 0
BEGIN
    FETCH NEXT FROM @cur INTO @ag_name, @db_name, @is_local, @sync_state, @lsn;
    IF @first = 0
    BEGIN
        PRINT N'UNION ALL';
    END
    PRINT N'SELECT [AG Name] = N''' + @ag_name + N''''
        + N', [Database Name] = N''' + @db_name + N''''
        + N', [Local Database] = N''' + @is_local + N''''
        + N', [Synchronization State] = N''' + @sync_state + N''''
        + N', [Last Hardened LSN] = N''' + @lsn + N'''';
    SET @first = 0;
    SET @rows = @rows - 1;
END

CLOSE @cur;
DEALLOCATE @cur;
PRINT N';';
GO
:OUT stdout
GO
 
:r ./distributed_ag_failover_step_04a_confirm_committed_lsn.sql
IF @last_hardened_lsn = N'NOT_OK'
BEGIN
    RAISERROR (N'Last Hardened LSN is not identical on both $(Primary) and $(Secondary).  Aborting.', 10, 127);
END
ELSE
BEGIN
    PRINT N'Last Hardened LSN is ' + @last_hardened_lsn;
END
GO
