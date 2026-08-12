/*
1- If the existing clustered index is not aligned with the column used for partitioning, then this technique doesn’t work.
2- Nonclustered indexes of the original table should NOT be created on the partition scheme for the new partitioned table.
*/
DROP TABLE IF EXISTS dbo.HumongousTable;
DROP TABLE IF EXISTS dbo.HumongousTable_Temp;

IF EXISTS (SELECT *
           FROM   sys.partition_schemes
           WHERE  name = 'PS_MonthlySlidingWindow')
    BEGIN
        EXECUTE sp_executesql N'DROP PARTITION SCHEME PS_MonthlySlidingWindow';
        EXECUTE sp_executesql N'DROP PARTITION FUNCTION PF_MonthlySlidingWindow';
    END
GO

CREATE TABLE dbo.HumongousTable /* Non-partitioned */ (
    Id          INT            IDENTITY NOT NULL,
    Name        NVARCHAR (100) NOT NULL,
    Description NVARCHAR (500) NULL,
    LogDate     DATETIME2      NOT NULL,
    CONSTRAINT PK_HumungousTable UNIQUE CLUSTERED (LogDate, Id)
);

INSERT dbo.HumongousTable (Name, Description, LogDate)
SELECT CAST (text AS NVARCHAR (100)),
       CAST (text AS NVARCHAR (500)),
       GETUTCDATE()
FROM   sys.messages;

UPDATE dbo.HumongousTable
SET    LogDate = dateadd(second, id * -1, logdate);
GO
-- ******************************************************************************
/* This part takes zero seconds and does no size-of-data scans:
Create the partition function */

CREATE PARTITION FUNCTION PF_MonthlySlidingWindow(DATETIME2)
    AS RANGE RIGHT
    FOR VALUES (
    /* Here is the new trick: NO PARTITION BOUNDARIES TO START WITH */
    ); 
    
/* Create the partition scheme */

CREATE PARTITION SCHEME PS_MonthlySlidingWindow
    AS PARTITION PF_MonthlySlidingWindow
    ALL TO ([PRIMARY]); 
    
/* create an empty non-partitioned table matching HumongousTable exactly */

CREATE TABLE dbo.HumongousTable_Temp /* Non-partitioned */ (
    Id          INT            IDENTITY NOT NULL,
    Name        NVARCHAR (100) NOT NULL,
    Description NVARCHAR (500) NULL,
    LogDate     DATETIME2      NOT NULL,
    CONSTRAINT PK_HumungousTable_Temp UNIQUE CLUSTERED (LogDate, Id)); 

/* Now create all Non clustered indexes that exist on the original source table.   
Then switch the current data, SWITCH IS METADATA ONLY */

ALTER TABLE dbo.HumongousTable SWITCH TO dbo.HumongousTable_Temp; 

/* rebuild (the NOW EMPTY) PK_HumungousTable on the partition scheme */

CREATE UNIQUE CLUSTERED INDEX PK_HumungousTable
    ON dbo.HumongousTable(LogDate, Id) 
    WITH (DROP_EXISTING = ON) -- Must do!
    ON PS_MonthlySlidingWindow (LogDate); 

/* switch data back, STILL FAST | ZERO SECONDS! */

ALTER TABLE HumongousTable_Temp SWITCH TO HumongousTable PARTITION 1;

IF NOT EXISTS (SELECT *
               FROM   dbo.HumongousTable_Temp)
    BEGIN
        DROP TABLE IF EXISTS dbo.HumongousTable_Temp;
    END

DECLARE @Month AS DATETIME2 = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);

WHILE @Month < '20300101' /* or whenever you plan to retire */
    BEGIN
        SET @Month = DATEADD(MONTH, 1, @Month);
        ALTER PARTITION FUNCTION PF_MonthlySlidingWindow( )
            SPLIT RANGE (@Month);
        ALTER PARTITION SCHEME PS_MonthlySlidingWindow NEXT USED [PRIMARY];
    END 

/* About 42 new partitions: */
SELECT COUNT(*) AS NumberOfPartitions
FROM   sys.partitions
WHERE  object_id = OBJECT_ID('dbo.HumongousTable');
