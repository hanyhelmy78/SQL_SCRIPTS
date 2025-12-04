-- =============================================
-- SQL Server Daily Partitioning Solution
-- Table: Event_FileManager (Dummy table)
-- Partition Column: InsertedDate (datetime)
-- =============================================

-- Step 1: Create Partition Function
-- This defines the boundary points for partitions (daily ranges)
-- Creates partitions for the next 365 days from today
-- RIGHT partition function: values >= boundary go to the partition on the right

DECLARE @StartDate DATE = CAST(GETDATE() AS DATE);
DECLARE @EndDate DATE = DATEADD(DAY, 365, @StartDate);
DECLARE @SQL NVARCHAR(MAX);

-- Build partition function creation script
SET @SQL = N'CREATE PARTITION FUNCTION PF_Event_FileManager_Daily (datetime) 
AS RANGE RIGHT FOR VALUES (';

DECLARE @CurrentDate DATE = @StartDate;
DECLARE @BoundaryValues NVARCHAR(MAX) = '';

WHILE @CurrentDate <= @EndDate
BEGIN
    SET @BoundaryValues = @BoundaryValues + '''' + CONVERT(VARCHAR(10), @CurrentDate, 120) + ''',';
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END

-- Remove trailing comma and close the statement
SET @BoundaryValues = LEFT(@BoundaryValues, LEN(@BoundaryValues) - 1);
SET @SQL = @SQL + @BoundaryValues + N')';

-- Execute partition function creation
EXEC sp_executesql @SQL;
GO

-- Step 2: Create Partition Scheme
-- This maps partitions to filegroups
CREATE PARTITION SCHEME PS_Event_FileManager_Daily
AS PARTITION PF_Event_FileManager_Daily
ALL TO ([PRIMARY]);
GO

-- Step 3: Check if table has clustered index
-- If it does, we need to drop and recreate it on the partition scheme

-- First, let's save the existing table structure
SELECT * INTO Event_FileManager_Backup FROM Event_FileManager;
GO

-- Step 4: Drop existing constraints and indexes if they exist
-- (Adjust these based on your actual table structure)

-- Drop foreign key constraints first (if any)
-- Example:
-- ALTER TABLE Event_FileManager DROP CONSTRAINT FK_ConstraintName;

-- Drop primary key or unique constraints
DECLARE @ConstraintName NVARCHAR(200);
SELECT @ConstraintName = name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('Event_FileManager') 
AND type = 'PK';

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Event_FileManager DROP CONSTRAINT ' + @ConstraintName);
END
GO

-- Step 5: Recreate the table with partitioning
-- Note: Adjust column definitions based on your actual table structure

CREATE TABLE Event_FileManager_New
(
    -- Add your actual columns here
    Id BIGINT NOT NULL,
    FileName NVARCHAR(500),
    FilePath NVARCHAR(1000),
    FileSize BIGINT,
    InsertedDate DATETIME NOT NULL,
    -- Add other columns...
    
    -- Create clustered index on partition scheme
    CONSTRAINT PK_Event_FileManager PRIMARY KEY CLUSTERED 
    (
        InsertedDate ASC,
        Id ASC  -- Include Id to ensure uniqueness
    )
) ON PS_Event_FileManager_Daily(InsertedDate);
GO

-- Step 6: Copy data from backup table to new partitioned table
SET IDENTITY_INSERT Event_FileManager_New ON;  -- If Id is identity
INSERT INTO Event_FileManager_New 
SELECT * FROM Event_FileManager_Backup;
SET IDENTITY_INSERT Event_FileManager_New OFF;
GO

-- Step 7: Drop old table and rename new table
DROP TABLE Event_FileManager;
GO

EXEC sp_rename 'Event_FileManager_New', 'Event_FileManager';
GO

-- Step 8: Recreate non-clustered indexes (if any)
-- Example:
-- CREATE NONCLUSTERED INDEX IX_Event_FileManager_FileName 
-- ON Event_FileManager(FileName)
-- ON PS_Event_FileManager_Daily(InsertedDate);

-- Step 9: Recreate foreign key constraints (if any)
-- Example:
-- ALTER TABLE Event_FileManager ADD CONSTRAINT FK_ConstraintName
-- FOREIGN KEY (ColumnName) REFERENCES OtherTable(ColumnName);

-- =============================================
-- MAINTENANCE: Automated Partition Management
-- =============================================
-- Create stored procedure to add new partitions automatically
IF OBJECT_ID('usp_AddDailyPartitions', 'P') IS NOT NULL
    DROP PROCEDURE usp_AddDailyPartitions;
GO

CREATE PROCEDURE usp_AddDailyPartitions
    @DaysAhead INT = 30
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @NextBoundary DATETIME;
    DECLARE @Counter INT;
    
    -- Get the last boundary value
    SELECT TOP 1 @NextBoundary = CAST(value AS DATETIME)
    FROM sys.partition_range_values prv
    INNER JOIN sys.partition_functions pf ON prv.function_id = pf.function_id
    WHERE pf.name = 'PF_Event_FileManager_Daily'
    ORDER BY prv.boundary_id DESC;
    
    -- Add new boundaries
    SET @Counter = 0;
    
    WHILE @Counter < @DaysAhead
    BEGIN
        SET @NextBoundary = DATEADD(DAY, 1, @NextBoundary);
        
        -- First, designate the next filegroup
        ALTER PARTITION SCHEME PS_Event_FileManager_Daily
        NEXT USED [PRIMARY];
        
        -- Then split the range
        SET @SQL = N'ALTER PARTITION FUNCTION PF_Event_FileManager_Daily()
                     SPLIT RANGE (''' + CONVERT(VARCHAR(23), @NextBoundary, 121) + ''');';
        
        EXEC sp_executesql @SQL;
        
        SET @Counter = @Counter + 1;
    END
    
    PRINT 'Successfully added ' + CAST(@DaysAhead AS VARCHAR(10)) + ' new partitions.';
END
GO

-- Create stored procedure using TRUNCATE (faster, removes all data in the partition)
IF OBJECT_ID('usp_TruncateOldPartitions', 'P') IS NOT NULL
    DROP PROCEDURE usp_TruncateOldPartitions;
GO

CREATE PROCEDURE usp_TruncateOldPartitions
    @DaysToKeep INT = 180
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @PartitionNumber INT;
    DECLARE @BoundaryValue DATETIME;
    DECLARE @CutoffDate DATETIME;
    DECLARE @TruncatedCount INT = 0;
    
    SET @CutoffDate = DATEADD(DAY, -@DaysToKeep, GETDATE());
    
    PRINT 'Starting truncation of partitions older than ' + CONVERT(VARCHAR(10), @CutoffDate, 120);
    
    -- Get partitions to truncate
    DECLARE partition_cursor CURSOR FOR
    SELECT 
        p.partition_number,
        CAST(prv.value AS DATETIME) AS BoundaryValue
    FROM sys.partitions p
    LEFT JOIN sys.partition_range_values prv 
        ON prv.function_id = (SELECT function_id FROM sys.partition_functions WHERE name = 'PF_Event_FileManager_Daily')
        AND p.partition_number = prv.boundary_id + 1
    WHERE p.object_id = OBJECT_ID('Event_FileManager')
    AND p.index_id IN (0,1)
    AND CAST(prv.value AS DATETIME) < @CutoffDate
    AND p.rows > 0
    ORDER BY p.partition_number;
    
    OPEN partition_cursor;
    FETCH NEXT FROM partition_cursor INTO @PartitionNumber, @BoundaryValue;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Truncate the specific partition (much faster than DELETE)
        SET @SQL = N'TRUNCATE TABLE Event_FileManager 
                     WITH (PARTITIONS (' + CAST(@PartitionNumber AS VARCHAR(10)) + '));';
        
        PRINT 'Truncating partition ' + CAST(@PartitionNumber AS VARCHAR(10)) + 
              ' (Boundary: ' + CONVERT(VARCHAR(23), @BoundaryValue, 121) + ')';
        
        EXEC sp_executesql @SQL;
        
        SET @TruncatedCount = @TruncatedCount + 1;
        
        FETCH NEXT FROM partition_cursor INTO @PartitionNumber, @BoundaryValue;
    END
    
    CLOSE partition_cursor;
    DEALLOCATE partition_cursor;
    
    -- Now merge the empty partitions
    DECLARE @BoundaryToMerge DATETIME;
    DECLARE @MergedCount INT = 0;
    
    DECLARE boundary_cursor CURSOR FOR
    SELECT CAST(value AS DATETIME)
    FROM sys.partition_range_values prv
    INNER JOIN sys.partition_functions pf ON prv.function_id = pf.function_id
    WHERE pf.name = 'PF_Event_FileManager_Daily'
    AND CAST(value AS DATETIME) < @CutoffDate
    ORDER BY prv.boundary_id;
    
    OPEN boundary_cursor;
    FETCH NEXT FROM boundary_cursor INTO @BoundaryToMerge;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SQL = N'ALTER PARTITION FUNCTION PF_Event_FileManager_Daily()
                     MERGE RANGE (''' + CONVERT(VARCHAR(23), @BoundaryToMerge, 121) + ''');';
        
        EXEC sp_executesql @SQL;
        SET @MergedCount = @MergedCount + 1;
        
        FETCH NEXT FROM boundary_cursor INTO @BoundaryToMerge;
    END
    
    CLOSE boundary_cursor;
    DEALLOCATE boundary_cursor;
    
    PRINT '-------------------------------------------';
    PRINT 'Summary:';
    PRINT 'Partitions truncated: ' + CAST(@TruncatedCount AS VARCHAR(10));
    PRINT 'Partitions merged: ' + CAST(@MergedCount AS VARCHAR(10));
    PRINT 'Partition cleanup completed successfully.';
END
GO

-- =============================================
-- PARTITION SPLITTING AND DATA CORRECTION
-- =============================================
-- Create stored procedure to split a partition at a specific date
IF OBJECT_ID('usp_SplitPartitionAtDate', 'P') IS NOT NULL
    DROP PROCEDURE usp_SplitPartitionAtDate;
GO

CREATE PROCEDURE usp_SplitPartitionAtDate
    @SplitDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @ExistingBoundary INT;
    
    -- Check if boundary already exists
    SELECT @ExistingBoundary = COUNT(*)
    FROM sys.partition_range_values prv
    INNER JOIN sys.partition_functions pf ON prv.function_id = pf.function_id
    WHERE pf.name = 'PF_Event_FileManager_Daily'
    AND CAST(value AS DATETIME) = @SplitDate;
    
    IF @ExistingBoundary > 0
    BEGIN
        PRINT 'Boundary already exists for date: ' + CONVERT(VARCHAR(23), @SplitDate, 121);
        RETURN;
    END
    
    -- Designate next filegroup
    ALTER PARTITION SCHEME PS_Event_FileManager_Daily
    NEXT USED [PRIMARY];
    
    -- Split the partition at the specified date
    SET @SQL = N'ALTER PARTITION FUNCTION PF_Event_FileManager_Daily()
                 SPLIT RANGE (''' + CONVERT(VARCHAR(23), @SplitDate, 121) + ''');';
    
    EXEC sp_executesql @SQL;
    
    PRINT 'Successfully split partition at: ' + CONVERT(VARCHAR(23), @SplitDate, 121);
    
    -- Show which partition the date is now in
    DECLARE @PartitionNum INT;
    SET @SQL = N'SELECT @PartNum = $PARTITION.PF_Event_FileManager_Daily(''' + 
               CONVERT(VARCHAR(23), @SplitDate, 121) + ''')';
    EXEC sp_executesql @SQL, N'@PartNum INT OUTPUT', @PartNum = @PartitionNum OUTPUT;
    
    PRINT 'Date now belongs to partition number: ' + CAST(@PartitionNum AS VARCHAR(10));
END
GO

-- Create stored procedure to fix wrong data in partitions
IF OBJECT_ID('usp_FixWrongDataInPartition', 'P') IS NOT NULL
    DROP PROCEDURE usp_FixWrongDataInPartition;
GO

CREATE PROCEDURE usp_FixWrongDataInPartition
    @PartitionNumber INT,
    @Action VARCHAR(20) = 'REPORT' -- Options: REPORT, DELETE, CORRECT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @MinBoundary DATETIME;
    DECLARE @MaxBoundary DATETIME;
    DECLARE @WrongRowCount BIGINT;
    
    -- Get partition boundaries
    SELECT 
        @MinBoundary = ISNULL(LAG(CAST(value AS DATETIME)) OVER (ORDER BY boundary_id), '1900-01-01'),
        @MaxBoundary = CAST(value AS DATETIME)
    FROM sys.partition_range_values prv
    INNER JOIN sys.partition_functions pf ON prv.function_id = pf.function_id
    WHERE pf.name = 'PF_Event_FileManager_Daily'
    AND boundary_id + 1 = @PartitionNumber;
    
    IF @MinBoundary IS NULL OR @MaxBoundary IS NULL
    BEGIN
        PRINT 'Invalid partition number: ' + CAST(@PartitionNumber AS VARCHAR(10));
        RETURN;
    END
    
    PRINT 'Checking partition ' + CAST(@PartitionNumber AS VARCHAR(10));
    PRINT 'Expected date range: ' + CONVERT(VARCHAR(23), @MinBoundary, 121) + 
          ' to ' + CONVERT(VARCHAR(23), @MaxBoundary, 121);
    PRINT '';
    
    -- Find rows that don't belong in this partition
    SELECT @WrongRowCount = COUNT(*)
    FROM Event_FileManager
    WHERE $PARTITION.PF_Event_FileManager_Daily(InsertedDate) = @PartitionNumber
    AND (InsertedDate < @MinBoundary OR InsertedDate >= @MaxBoundary);
    
    PRINT 'Found ' + CAST(@WrongRowCount AS VARCHAR(20)) + ' rows with incorrect InsertedDate in this partition.';
    
    IF @WrongRowCount = 0
    BEGIN
        PRINT 'No data issues found in partition ' + CAST(@PartitionNumber AS VARCHAR(10));
        RETURN;
    END
    
    -- Report details
    IF @Action = 'REPORT'
    BEGIN
        SELECT 
            'Partition ' + CAST(@PartitionNumber AS VARCHAR(10)) AS PartitionInfo,
            InsertedDate,
            COUNT(*) AS [RowCount],
            $PARTITION.PF_Event_FileManager_Daily(InsertedDate) AS ActualPartitionNumber
        FROM Event_FileManager
        WHERE $PARTITION.PF_Event_FileManager_Daily(InsertedDate) = @PartitionNumber
        AND (InsertedDate < @MinBoundary OR InsertedDate >= @MaxBoundary)
        GROUP BY InsertedDate, $PARTITION.PF_Event_FileManager_Daily(InsertedDate)
        ORDER BY InsertedDate;
        
        PRINT '';
        PRINT 'Run with @Action = ''DELETE'' to remove these rows';
        PRINT 'Or fix the data manually and rebuild the index to move rows to correct partitions';
    END
    
    -- Delete wrong data
    ELSE IF @Action = 'DELETE'
    BEGIN
        DELETE FROM Event_FileManager
        WHERE $PARTITION.PF_Event_FileManager_Daily(InsertedDate) = @PartitionNumber
        AND (InsertedDate < @MinBoundary OR InsertedDate >= @MaxBoundary);
        
        PRINT 'Deleted ' + CAST(@@ROWCOUNT AS VARCHAR(20)) + ' rows from partition ' + 
              CAST(@PartitionNumber AS VARCHAR(10));
    END
    
    ELSE
    BEGIN
        PRINT 'Invalid action. Use REPORT or DELETE';
    END
END
GO

-- Create stored procedure to rebuild partition and move data to correct partitions
IF OBJECT_ID('usp_RebuildPartitionedTable', 'P') IS NOT NULL
    DROP PROCEDURE usp_RebuildPartitionedTable;
GO

CREATE PROCEDURE usp_RebuildPartitionedTable
    @RebuildOption VARCHAR(20) = 'ONLINE' -- Options: ONLINE, OFFLINE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQL NVARCHAR(MAX);
    
    PRINT 'Starting partition rebuild for Event_FileManager...';
    PRINT 'This will move all rows to their correct partitions based on InsertedDate.';
    PRINT '';
    
    IF @RebuildOption = 'ONLINE'
    BEGIN
        -- Online rebuild (requires Enterprise Edition for large tables)
        SET @SQL = N'ALTER INDEX ALL ON Event_FileManager 
                     REBUILD PARTITION = ALL 
                     WITH (ONLINE = ON, MAXDOP = 4);';
        
        PRINT 'Performing ONLINE rebuild...';
    END
    ELSE
    BEGIN
        -- Offline rebuild (faster but table is locked)
        SET @SQL = N'ALTER INDEX ALL ON Event_FileManager 
                     REBUILD PARTITION = ALL 
                     WITH (MAXDOP = 4);';
        
        PRINT 'Performing OFFLINE rebuild...';
    END
    
    BEGIN TRY
        EXEC sp_executesql @SQL;
        PRINT 'Rebuild completed successfully!';
        PRINT 'All data has been moved to correct partitions.';
    END TRY
    BEGIN CATCH
        PRINT 'Error during rebuild: ' + ERROR_MESSAGE();
        
        IF ERROR_NUMBER() = 1927 -- Online rebuild not supported
        BEGIN
            PRINT '';
            PRINT 'ONLINE rebuild not supported. Trying OFFLINE rebuild...';
            SET @SQL = N'ALTER INDEX ALL ON Event_FileManager 
                         REBUILD PARTITION = ALL 
                         WITH (MAXDOP = 4);';
            EXEC sp_executesql @SQL;
            PRINT 'OFFLINE rebuild completed successfully!';
        END
    END CATCH
END
GO

-- Create stored procedure to check data integrity across all partitions
IF OBJECT_ID('usp_CheckPartitionDataIntegrity', 'P') IS NOT NULL
    DROP PROCEDURE usp_CheckPartitionDataIntegrity;
GO

CREATE PROCEDURE usp_CheckPartitionDataIntegrity
AS
BEGIN
    SET NOCOUNT ON;
    
    PRINT 'Checking data integrity across all partitions...';
    PRINT '';
    
    -- Check for rows in wrong partitions
    WITH PartitionBoundaries AS
    (
        SELECT 
            p.partition_number,
            ISNULL(LAG(CAST(prv.value AS DATETIME)) OVER (ORDER BY prv.boundary_id), '1900-01-01') AS MinBoundary,
            CAST(prv.value AS DATETIME) AS MaxBoundary
        FROM sys.partitions p
        LEFT JOIN sys.partition_range_values prv 
            ON prv.function_id = (SELECT function_id FROM sys.partition_functions WHERE name = 'PF_Event_FileManager_Daily')
            AND p.partition_number = prv.boundary_id + 1
        WHERE p.object_id = OBJECT_ID('Event_FileManager')
        AND p.index_id IN (0,1)
    )
    SELECT 
        pb.partition_number AS PartitionNumber,
        pb.MinBoundary,
        pb.MaxBoundary,
        COUNT(*) AS TotalRows,
        SUM(CASE WHEN em.InsertedDate < pb.MinBoundary OR em.InsertedDate >= pb.MaxBoundary 
                 THEN 1 ELSE 0 END) AS WrongPartitionRows,
        MIN(em.InsertedDate) AS ActualMinDate,
        MAX(em.InsertedDate) AS ActualMaxDate
    FROM Event_FileManager em
    INNER JOIN PartitionBoundaries pb 
        ON $PARTITION.PF_Event_FileManager_Daily(em.InsertedDate) = pb.partition_number
    GROUP BY pb.partition_number, pb.MinBoundary, pb.MaxBoundary
    HAVING SUM(CASE WHEN em.InsertedDate < pb.MinBoundary OR em.InsertedDate >= pb.MaxBoundary 
                    THEN 1 ELSE 0 END) > 0
    ORDER BY pb.partition_number;
    
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'All partitions contain correct data! No integrity issues found.';
    END
    ELSE
    BEGIN
        PRINT '';
        PRINT 'Data integrity issues found!';
        PRINT 'Use usp_FixWrongDataInPartition to investigate or fix specific partitions.';
        PRINT 'Or use usp_RebuildPartitionedTable to move all data to correct partitions.';
    END
END
GO
-- =============================================
-- VERIFICATION QUERIES
-- =============================================
-- View partition information
SELECT 
    OBJECT_NAME(p.object_id) AS TableName,
    p.partition_number AS PartitionNumber,
    prv.value AS BoundaryValue,
    p.rows AS [RowCount],
    fg.name AS FileGroupName
FROM sys.partitions p
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id
INNER JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
LEFT JOIN sys.partition_range_values prv ON pf.function_id = prv.function_id 
    AND p.partition_number = prv.boundary_id + 1
INNER JOIN sys.destination_data_spaces dds ON ps.data_space_id = dds.partition_scheme_id 
    AND p.partition_number = dds.destination_id
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id
WHERE p.object_id = OBJECT_ID('Event_FileManager')
ORDER BY p.partition_number;

-- View which partition a specific date falls into
SELECT $PARTITION.PF_Event_FileManager_Daily('2025-12-03') AS PartitionNumber;

-- Count rows per partition
SELECT 
    p.partition_number,
    prv.value AS BoundaryValue,
    p.rows AS [RowCount]
FROM sys.partitions p
LEFT JOIN sys.partition_range_values prv 
    ON prv.function_id = (SELECT function_id FROM sys.partition_functions WHERE name = 'PF_Event_FileManager_Daily')
    AND p.partition_number = prv.boundary_id + 1
WHERE p.object_id = OBJECT_ID('Event_FileManager')
AND p.index_id IN (0,1)
ORDER BY p.partition_number;
