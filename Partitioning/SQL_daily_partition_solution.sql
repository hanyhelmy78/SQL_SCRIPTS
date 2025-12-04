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