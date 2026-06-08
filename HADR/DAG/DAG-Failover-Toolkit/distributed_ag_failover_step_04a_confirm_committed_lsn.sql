/*
    Set the @last_hardened_lsn variable
*/
GO
:CONNECT $(Primary)
SET NOCOUNT ON;
DECLARE @lsns TABLE
(
      [AG Name]                 sysname NULL
    , [Database Name]           sysname NULL
    , [Local Database]          varchar(3) NULL
    , [Synchronization State]   nvarchar(60) NULL
    , [Last Hardened LSN]       nvarchar(48) NULL
);
INSERT INTO @lsns
(
      [AG Name]              
    , [Database Name]        
    , [Local Database]       
    , [Synchronization State]
    , [Last Hardened LSN]    
)
:r ./lsn-primary.sql
INSERT INTO @lsns
(
      [AG Name]              
    , [Database Name]        
    , [Local Database]       
    , [Synchronization State]
    , [Last Hardened LSN]    
)
:r ./lsn-secondary.sql

DECLARE @last_hardened_lsn nvarchar(48);
DECLARE @count1 int;
DECLARE @count2 int;
DECLARE @match_count int;

DECLARE @msg nvarchar(2048);
SET @msg = N'$(Primary) -> $(Secondary)';
RAISERROR (@msg, 0, 1) WITH NOWAIT;

:r ./parse_server_names.sql

SET @count1 = COALESCE((SELECT COUNT(1) FROM @lsns l WHERE l.[AG Name] = @primary_name), -1);
SET @count2 = COALESCE((SELECT COUNT(1) FROM @lsns l WHERE l.[AG Name] = @secondary_name), -2);

SET @match_count = (
    SELECT COUNT(1)
    FROM (SELECT * FROM @lsns WHERE [AG Name] = @primary_name) l1
        LEFT JOIN (SELECT * FROM @lsns WHERE [AG Name] = @secondary_name) l2 ON l1.[Database Name] = l2.[Database Name]
                                AND l1.[Last Hardened LSN] = l2.[Last Hardened LSN]
    WHERE l1.[AG Name] = @primary_name
        AND l2.[AG Name] = @secondary_name
);

PRINT N'Count of Databases in ' + @primary_name + N': ' + CONVERT(nvarchar(11), @count1, 0);
PRINT N'Count of Databases in ' + @secondary_name + N': ' + CONVERT(nvarchar(11), @count2, 0);
PRINT N'Count of LSNs that match across AGs: ' + CONVERT(nvarchar(11), @match_count, 0);

    DECLARE @database_name sysname;
    DECLARE @sync1 nvarchar(60);
    DECLARE @sync2 nvarchar(60);
    DECLARE @lsn1  nvarchar(48);
    DECLARE @lsn2  nvarchar(48);

    PRINT 
                 LEFT('Database'                            + REPLICATE(N' ', 30), 30) 
        + N' ' + LEFT('Sync State ' + @primary_name         + REPLICATE(N' ', 25), 25) 
        + N' ' + LEFT('Sync State ' + @secondary_name       + REPLICATE(N' ', 25), 25) 
        + N' ' + LEFT('Last Hardened ' + @primary_name      + REPLICATE(N' ', 30), 30) 
        + N' ' + LEFT('Last Hardened ' + @secondary_name    + REPLICATE(N' ', 30), 30);

    DECLARE cur_last_lsn CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY
    FOR
    SELECT 
          l1.[Database Name]
        , l1.[Synchronization State]
        , l2.[Synchronization State]
        , l1.[Last Hardened LSN]
        , l2.[Last Hardened LSN]
    FROM (SELECT * FROM @lsns WHERE [AG Name] = @primary_name) l1
        LEFT JOIN (SELECT * FROM @lsns WHERE [AG Name] = @secondary_name) l2 ON l1.[Database Name] = l2.[Database Name]
    ORDER BY l1.[Database Name];

    OPEN cur_last_lsn;
    FETCH NEXT FROM cur_last_lsn INTO @database_name, @sync1, @sync2, @lsn1, @lsn2;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 
                     LEFT(@database_name    + REPLICATE(N' ', 30), 30) 
            + N' ' + LEFT(COALESCE(@sync1, N'<NULL>')            + REPLICATE(N' ', 25), 25) 
            + N' ' + LEFT(COALESCE(@sync2, N'<NULL>')            + REPLICATE(N' ', 25), 25) 
            + N' ' + LEFT(COALESCE(@lsn1, N'<NULL>') + N' ' + CASE WHEN @lsn1 < @lsn2 THEN N'(behind)' ELSE N'' END + REPLICATE(N' ', 30), 30) 
            + N' ' + LEFT(COALESCE(@lsn2, N'<NULL>') + N' ' + CASE WHEN @lsn2 < @lsn1 THEN N'(behind)' ELSE N'' END + REPLICATE(N' ', 30), 30);
            
        FETCH NEXT FROM cur_last_lsn INTO @database_name, @sync1, @sync2, @lsn1, @lsn2;
    END
    CLOSE cur_last_lsn;
    DEALLOCATE cur_last_lsn;

IF @match_count = @count1 AND @match_count = @count2
BEGIN
    SET @last_hardened_lsn = N'OK';
END
ELSE
BEGIN
    SET @last_hardened_lsn = N'NOT_OK';
END
