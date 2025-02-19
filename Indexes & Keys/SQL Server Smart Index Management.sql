/*
   Developed by: Mohit K. Gupta
   Avaliable at: http://www.sqlcan.com

 - COPYRIGHT NOTICE -

Microsoft Public License (Ms-PL)

This license governs use of the accompanying software. If you use the software,
you accept this license. If you do not accept the license, do not use the software.

1. Definitions

The terms "reproduce," "reproduction," "derivative works," and "distribution" have
the same meaning here as under U.S. copyright law.

A "contribution" is the original software, or any additions or changes to the software.

A "contributor" is any person that distributes its contribution under this license.

"Licensed patents" are a contributor's patent claims that read directly on its contribution.

2. Grant of Rights

(A) Copyright Grant- Subject to the terms of this license, including the license conditions
    and limitations in section 3, each contributor grants you a non-exclusive, worldwide,
    royalty-free copyright license to reproduce its contribution, prepare derivative works
    of its contribution, and distribute its contribution or any derivative works that you
    create.

(B) Patent Grant- Subject to the terms of this license, including the license conditions
    and limitations in section 3, each contributor grants you a non-exclusive, worldwide,
    royalty-free license under its licensed patents to make, have made, use, sell, offer
    for sale, import, and/or otherwise dispose of its contribution in the software or
    derivative works of the contribution in the software.

3. Conditions and Limitations

(A) No Trademark License- This license does not grant you rights to use any contributors'
    name, logo, or trademarks.

(B) If you bring a patent claim against any contributor over patents that you claim are
    infringed by the software, your patent license from such contributor to the software
    ends automatically.

(C) If you distribute any portion of the software, you must retain all copyright, patent,
    trademark, and attribution notices that are present in the software.

(D) If you distribute any portion of the software in source code form, you may do so only
    under this license by including a complete copy of this license with your distribution.
    If you distribute any portion of the software in compiled or object code form, you may
    only do so under a license that complies with this license.

(E) The software is licensed "as-is." You bear the risk of using it. The contributors give
    no express warranties, guarantees or conditions. You may have additional consumer rights
    under your local laws which this license cannot change. To the extent permitted under
    your local laws, the contributors exclude the implied warranties of merchantability,
    fitness for a particular purpose and non-infringement.

- COPYRIGHT NOTICE - */
--------------------------------------------------------------------------------------
-- Database Index Maintenance Script
--
-- Developed by: Mohit K. Gupta
--               mogupta@microsoft.com
--
-- Last Updated: Oct. 9, 2020
--
-- Version: 2.00
--
-- 2.00 Updated for Partitions and SQL 2019.
--------------------------------------------------------------------------------------
USE [master]
GO

-- If database SQLSIM already exists, drop it.
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'SQLSIM')
BEGIN
	ALTER DATABASE SQLSIM SET OFFLINE WITH ROLLBACK IMMEDIATE
	ALTER DATABASE SQLSIM SET ONLINE
	DROP DATABASE SQLSIM
END

-- Create a new database setting the recovery model to SIMPLE.
CREATE DATABASE [SQLSIM]
GO

ALTER DATABASE [SQLSIM] SET RECOVERY SIMPLE 
GO

USE [SQLSIM]
GO

-- Setup up the SQLSIM Meta-data tables used to maintain the indexes
IF OBJECT_ID('dbo.MaintenanceWindow') IS NOT NULL
	DROP TABLE dbo.MaintenanceWindow

CREATE TABLE dbo.MaintenanceWindow (
	MaintenanceWindowID			int							NOT NULL	IDENTITY(1,1) 
	   CONSTRAINT pkMaintenanceWindow_MaintenanceWindowID	PRIMARY KEY,
	MaintenanceWindowName		nvarchar(255)				NOT NULL,
	MaintenanceWindowStartTime	time						NOT NULL
	   CONSTRAINT dfSTNullValue								DEFAULT ('0:00'),
	MaintenanceWindowEndTime	time						NOT NULL
	   CONSTRAINT dfETNullValue								DEFAULT ('0:00'),
    MainteanceWindowWeekdays    varchar(255)                NOT NULL
       CONSTRAINT MainteanceWindowWeekdays                  DEFAULT ('None'),
	[MaintenanceWindowDateModifer]  AS (CASE WHEN [MaintenanceWindowStartTime]>[MaintenanceWindowEndTime] THEN (-1) ELSE (0) END) PERSISTED NOT NULL
);

CREATE UNIQUE NONCLUSTERED INDEX uqMaintenanceWindowName ON dbo.MaintenanceWindow(MaintenanceWindowName);

INSERT INTO MaintenanceWindow (MaintenanceWindowName,MaintenanceWindowStartTime,MaintenanceWindowEndTime,MainteanceWindowWeekdays)
     VALUES ('No Maintenance','0:00','0:00','None'),
			('HOT Tables','23:00','1:00','None'),
			('Maintenance Window #1','1:00','1:45','None');

IF OBJECT_ID('dbo.DatabaseStatus') IS NOT NULL
	DROP TABLE dbo.DatabaseStatus

CREATE TABLE dbo.DatabaseStatus (
    DatabaseID				 int				NOT NULL,
    IsLogFileFull            bit                NOT NULL
);

IF OBJECT_ID('dbo.MetaData') IS NOT NULL
	DROP TABLE dbo.MetaData

CREATE TABLE dbo.MetaData (
    LastIndexUsageScanDate   datetime           NOT NULL
        CONSTRAINT dfLastIndexUsageScanDate     DEFAULT ('1900-01-01')
);

IF OBJECT_ID('dbo.DatabasesToSkip') IS NOT NULL
	DROP TABLE dbo.DatabasesToSkip
	
CREATE TABLE dbo.DatabasesToSkip (
	DatabaseName sysname NOT NULL
		CONSTRAINT pkDatabasesToSkip_DBName PRIMARY KEY);

IF OBJECT_ID('dbo.MasterIndexCatalog') IS NOT NULL
	DROP TABLE dbo.MasterIndexCatalog

CREATE TABLE dbo.MasterIndexCatalog (
	ID						 bigint				NOT NULL	IDENTITY(1,1)
		CONSTRAINT pkMasterIndexCatalog_ID		PRIMARY KEY,
	DatabaseID				 int				NOT NULL,
	DatabaseName			 nvarchar(255)		NOT NULL,
	SchemaID				 int				NOT NULL,
	SchemaName				 nvarchar(255)		NOT NULL,
	TableID					 bigint				NOT NULL,
	TableName				 nvarchar(255)		NOT NULL,
	IndexID					 int				NOT NULL,
	IndexName				 nvarchar(255)		NOT NULL,
	PartitionNumber			 int				NOT NULL,
	IndexFillFactor			 tinyint 			NULL
		CONSTRAINT dfIndexFillFactor			DEFAULT(95),
	IsDisabled				 bit				NOT NULL
	    CONSTRAINT dfIsDisabled					DEFAULT(0),	
	IndexPageLockAllowed	 bit				NULL
		CONSTRAINT dfIsPageLockAllowed			DEFAULT(1),	
	OfflineOpsAllowed		 bit				NULL
		CONSTRAINT dfOfflineOpsAllowed			DEFAULT(0),
    RangeScanCount           bigint             NOT NULL
        CONSTRAINT dfRangeScanCount             DEFAULT(0),
    SingletonLookupCount     bigint             NOT NULL
        CONSTRAINT dfSingletonLookupCount       DEFAULT(0),
    LastRangeScanCount       bigint             NOT NULL
        CONSTRAINT dfLastRangeScanCount         DEFAULT(0),
    LastSingletonLookupCount bigint             NOT NULL
        CONSTRAINT dfLastSingletonLookupCount   DEFAULT(0),
    OnlineOpsSupported		 bit				NULL
        CONSTRAINT dfOnlineOpsSupported			DEFAULT(1),
    SkipCount                int                NOT NULL
        CONSTRAINT dfSkipCount                  DEFAULT(0),
    MaxSkipCount             int                NOT NULL
        CONSTRAINT dfMaxSkipCount               DEFAULT(0),
	MaintenanceWindowID		 int				NULL
		CONSTRAINT dfMaintenanceWindowID		DEFAULT(1)
		CONSTRAINT fkMaintenanceWindowID_MasterIndexCatalog_MaintenanceWindowID FOREIGN KEY REFERENCES MaintenanceWindow(MaintenanceWindowID),
	LastScanned				 datetime			NOT NULL
		CONSTRAINT dfLastScanned				DEFAULT('1900-01-01'),
	LastManaged				 datetime		    NULL
		CONSTRAINT dfLastManaged				DEFAULT('1900-01-01'),
    LastEvaluated            datetime           NOT NULL
        CONSTRAINT dfLastEvaluated              DEFAULT(GetDate())
)

IF OBJECT_ID('dbo.MaintenanceHistory') IS NOT NULL
	DROP TABLE dbo.MaintenanceHistory

CREATE TABLE dbo.MaintenanceHistory (
	HistoryID				bigint					NOT NULL	IDENTITY (1,1)
		CONSTRAINT pkMaintenanceHistory_HistoryID	PRIMARY KEY,
	MasterIndexCatalogID	bigint					NOT NULL
		CONSTRAINT fkMasterIndexCatalogID_MasterIndexCatalog_ID FOREIGN KEY REFERENCES MasterIndexCatalog(ID),
	Page_Count				bigint					NOT NULL,
	Fragmentation			float					NOT NULL,
	OperationType			varchar(25)				NOT NULL,
	OperationStartTime		datetime				NOT NULL,
	OperationEndTime		datetime				NOT NULL,
	ErrorDetails			varchar(8000)			NOT NULL,
)

GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'upUpdateMasterIndexCatalog')
    DROP PROCEDURE upUpdateMasterIndexCatalog
GO

CREATE PROCEDURE dbo.upUpdateMasterIndexCatalog
@DefaultMainteanceWindowName VARCHAR(255) = 'No Maintenance',
@DefaultMainteanceWindowID INT = 1
AS
BEGIN

	DECLARE @DatabaseID		int
	DECLARE @DatabaseName	nvarchar(255)
	DECLARE @SQL			varchar(8000)

	IF (@DefaultMainteanceWindowName <> 'No Maintenance')
		SELECT @DefaultMainteanceWindowID = MaintenanceWindowID
		  FROM dbo.MaintenanceWindow
		 WHERE MaintenanceWindowName = @DefaultMainteanceWindowName

	IF (@DefaultMainteanceWindowID IS NULL)
		SET @DefaultMainteanceWindowID = 1

	CREATE TABLE #DatabaseToManage
	(DatabaseID		int,
     DatabaseName	nvarchar(255));

	-- Only select user database databases that are online and writable.
	-- Only database that are in DatabasesToManage -- Controlled by DBA Team --

	INSERT INTO #DatabaseToManage
		 SELECT database_id, name
	       FROM sys.databases
	      WHERE database_id > 4		-- USER DB`S
			AND user_access = 0     -- MULTI_USER
	        AND state = 0			-- ONLINE
	        AND is_read_only = 0    -- READ_WRITE
			AND is_in_standby = 0   -- Log Shipping Standby
			AND name NOT IN (SELECT DatabaseName FROM dbo.DatabasesToSkip)

	-- Remove databses from list that are part of AG but not primary replica.
	DELETE
	  FROM #DatabaseToManage
	 WHERE DatabaseName IN (    SELECT d.name
                                  FROM sys.databases d
                            INNER JOIN sys.dm_hadr_availability_replica_states rs ON d.replica_id = rs.replica_id
                            INNER JOIN sys.availability_groups ag ON rs.group_id = ag.group_id
                                 WHERE rs.role_desc = 'SECONDARY')

	-- Remove databases that are Mirror partner --
	DELETE
	  FROM #DatabaseToManage
	 WHERE DatabaseName IN (SELECT db_name(database_id) FRom sys.database_mirroring WHERE mirroring_role = 2)

	-- Table used to track current state of tlog space.  Once TLog has reached capacity setting.
    DELETE FROM dbo.DatabaseStatus
    INSERT INTO dbo.DatabaseStatus
    SELECT DatabaseID, 0
      FROM #DatabaseToManage

	DECLARE cuDatabaeScan
	 CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY
	    FOR SELECT DatabaseID, DatabaseName
	          FROM #DatabaseToManage
	
	OPEN cuDatabaeScan
	
		FETCH NEXT FROM cuDatabaeScan
		INTO @DatabaseID, @DatabaseName
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			-- Update Master Index Catalog with meta-data, new objects identified.
			SET @SQL = 'INSERT INTO dbo.MasterIndexCatalog (DatabaseID, DatabaseName, SchemaID, SchemaName, TableID, TableName, PartitionNumber, IndexID, IndexName, IndexFillFactor)
			            SELECT ' + CAST(@DatabaseID AS varchar) + ', ''' + @DatabaseName + ''', s.schema_id, s.name, t.object_id, t.name, p.partition_number, i.index_id, i.name, i.fill_factor
						  FROM [' + @DatabaseName + '].sys.schemas s
                          JOIN [' + @DatabaseName + '].sys.tables t ON s.schema_id = t.schema_id
                          JOIN [' + @DatabaseName + '].sys.indexes i on t.object_id = i.object_id
						  JOIN [' + @DatabaseName + '].sys.partitions p on t.object_id = p.object_id
						                                            AND i.index_id = p.index_id
                         WHERE i.is_hypothetical = 0
						   AND i.index_id >= 1
						   AND i.type IN (1,2,3,5,6) -- Only index excluded in HEAP, SPATIAL Indexes, Memory Indexes
						   AND t.is_ms_shipped = 0
                           AND NOT EXISTS (SELECT *
                                             FROM dbo.MasterIndexCatalog MIC
                                            WHERE MIC.DatabaseID = ' + CAST(@DatabaseID AS varchar) + '
                                              AND MIC.SchemaID = s.schema_id
                                              AND MIC.TableID = t.object_id
                                              AND MIC.IndexID = i.index_id
											  AND MIC.PartitionNumber = p.partition_number)'
			
			EXEC(@SQL)
			
			-- Update Master Index Catalog with meta-data, remove objects that do not exist any more.
			SET @SQL = 'DELETE FROM MaintenanceHistory
			                  WHERE MasterIndexCatalogID
			                     IN ( SELECT ID
			                            FROM dbo.MasterIndexCatalog MIC
			                           WHERE NOT EXISTS (SELECT *
			                                               FROM [' + @DatabaseName + '].sys.schemas s
														   JOIN [' + @DatabaseName + '].sys.tables t     ON s.schema_id = t.schema_id
														   JOIN [' + @DatabaseName + '].sys.indexes i    on t.object_id = i.object_id
						                                   JOIN [' + @DatabaseName + '].sys.partitions p on t.object_id = p.object_id
						                                                                                 AND i.index_id = p.index_id
														  WHERE MIC.DatabaseID = ' + CAST(@DatabaseID AS varchar) + '
                                                            AND MIC.SchemaID = s.schema_id
                                                            AND MIC.TableID = t.object_id
                                                            AND MIC.IndexID = i.index_id
															AND MIC.PartitionNumber = p.partition_number)
							             AND MIC.DatabaseID = ' + CAST(@DatabaseID AS varchar) + ')'
                                              
			
			EXEC(@SQL)
			
			SET @SQL = 'DELETE FROM MasterIndexCatalog
			                  WHERE NOT EXISTS (SELECT *
			                                      FROM [' + @DatabaseName + '].sys.schemas s
							  				      JOIN [' + @DatabaseName + '].sys.tables t     ON s.schema_id = t.schema_id
												  JOIN [' + @DatabaseName + '].sys.indexes i    on t.object_id = i.object_id
						                          JOIN [' + @DatabaseName + '].sys.partitions p on t.object_id = p.object_id
						                                                                       AND i.index_id = p.index_id
											     WHERE DatabaseID = ' + CAST(@DatabaseID AS varchar) + '
                                                   AND SchemaID = s.schema_id
                                                   AND TableID = t.object_id
                                                   AND IndexID = i.index_id
												   AND PartitionNumber = p.partition_number)
	                            AND DatabaseID = ' + CAST(@DatabaseID AS varchar)
                                              
			
			EXEC(@SQL)
			
			FETCH NEXT FROM cuDatabaeScan
			INTO @DatabaseID, @DatabaseName
			
		END
		
	CLOSE cuDatabaeScan
	
	DEALLOCATE cuDatabaeScan
	
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'upUpdateIndexUsageStats')
    DROP PROCEDURE upUpdateIndexUsageStats
GO

CREATE PROCEDURE upUpdateIndexUsageStats
AS
BEGIN

    DECLARE @LastRestartDate DATETIME

    SELECT @LastRestartDate = create_date
      FROM sys.databases
     WHERE database_id = 2

    IF EXISTS (SELECT * FROM dbo.MetaData WHERE LastIndexUsageScanDate > @LastRestartDate)
    BEGIN
        -- Server has restarted since last data collection.
        UPDATE dbo.MasterIndexCatalog
           SET LastRangeScanCount = range_scan_count,
               LastSingletonLookupCount = singleton_lookup_count,
               RangeScanCount = RangeScanCount + range_scan_count,
               SingletonLookupCount = SingletonLookupCount + singleton_lookup_count
          FROM sys.dm_db_index_operational_stats(null,null,null,null) IOS
          JOIN dbo.MasterIndexCatalog MIC ON IOS.database_id = MIC.DatabaseID
                                         AND IOS.object_id = MIC.TableID
                                         AND IOS.index_id = MIC.IndexID
										 AND IOS.partition_number = MIC.PartitionNumber
    END
    ELSE
    BEGIN
        -- Server did not restart since last collection.
        UPDATE dbo.MasterIndexCatalog
           SET LastRangeScanCount = LastRangeScanCount + (range_scan_count - LastRangeScanCount),
               LastSingletonLookupCount = LastSingletonLookupCount + (singleton_lookup_count - LastSingletonLookupCount),
               RangeScanCount = RangeScanCount + (range_scan_count - LastRangeScanCount),
               SingletonLookupCount = SingletonLookupCount + (singleton_lookup_count - LastSingletonLookupCount)
          FROM sys.dm_db_index_operational_stats(null,null,null,null) IOS
          JOIN dbo.MasterIndexCatalog MIC ON IOS.database_id = MIC.DatabaseID
                                         AND IOS.object_id = MIC.TableID
                                         AND IOS.index_id = MIC.IndexID
										 AND IOS.partition_number = MIC.PartitionNumber

    END

    IF ((SELECT COUNT(*) FROM dbo.MetaData) = 1)
    BEGIN
        UPDATE dbo.MetaData
            SET LastIndexUsageScanDate = GetDate()
    END
    ELSE
    BEGIN
        INSERT INTO dbo.MetaData (LastIndexUsageScanDate) VALUES (GetDate())
    END

END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'upMaintainIndexes')
	DROP PROCEDURE upMaintainIndexes
GO

CREATE PROCEDURE [dbo].[upMaintainIndexes]
@IgnoreRangeScans BIT = 0,
@PrintOnlyNoExecute INT = 0,
@MAXDOPSetting INT = 4,
@LastOpTimeGap INT = 5,
@MaxLogSpaceUsageBeforeStop FLOAT = 80,
@LogNOOPMsgs BIT = 0,
@DebugMode BIT = 0
AS
BEGIN

	SET NOCOUNT ON

    -- Start of Stored Procedure
	DECLARE @MaintenanceWindowName	    varchar(255)
	DECLARE @SQL					    varchar(8000)
	DECLARE @DatabaseID				    int
	DECLARE @DatabaseName			    nvarchar(255)
	DECLARE @SchemaName				    nvarchar(255)
	DECLARE @TableID				    bigint
	DECLARE @TableName				    nvarchar(255)
	DECLARE @IndexID				    int
	DECLARE @PartitionNumber			int
	DECLARE @IndexName				    nvarchar(255)
	DECLARE @IndexFillFactor		    tinyint 
	DECLARE @IndexOperation			    varchar(25)
	DECLARE @OfflineOpsAllowed		    bit
	DECLARE @OnlineOpsSupported		    bit
	DECLARE @RebuildOnline			    bit
	DECLARE @ServerEdition			    int
	DECLARE @MWStartTime			    datetime
	DECLARE @MWEndTime				    datetime
	DECLARE @OpStartTime			    datetime
	DECLARE @OpEndTime				    datetime
	DECLARE @LastManaged			    datetime
	DECLARE @LastScanned			    datetime
    DECLARE @LastEvaluated              datetime
    DECLARE @SkipCount                  int
    DECLARE @MaxSkipCount               int
	DECLARE @MAXDOP					    int
	DECLARE @DefaultOpTime			    int
	DECLARE @FiveMinuteCheck		    int
	DECLARE @FFA					    int --Fill Factor Adjustment
    DECLARE @LogSpacePercentage         float
    DECLARE @ReasonForNOOP				varchar(255)
	
	SET NOCOUNT ON

	IF (@DebugMode = 1)
		PRINT 'Starting Index Mainteance Script on ' + CONVERT(VARCHAR(255),GETDATE(),121)

	SET @MAXDOP = @MAXDOPSetting	 -- Degree of Parallelism to use for Index Rebuilds

	SET @FiveMinuteCheck = @LastOpTimeGap*60*1000 -- When the script is with in 5 minutes of maintenance window; it will not try to run any more
											      --  operations.

    SELECT MaintenanceWindowID,
           MaintenanceWindowName,
           CASE WHEN GETDATE() > CAST(DATEADD(Day,1,CONVERT(CHAR(10),GETDATE(),111)) + ' 00:00:00.000' AS DateTime) THEN  -- If the current time is after midnight; then we need to decrement the 
              DATEADD(DAY,MaintenanceWindowDateModifer,CAST(CONVERT(CHAR(10),GETDATE(),111) + ' ' + CONVERT(CHAR(10),MaintenanceWindowStartTime,114) AS DATETIME))
           ELSE
              CAST(CONVERT(CHAR(10),GETDATE(),111) + ' ' + CONVERT(CHAR(10),MaintenanceWindowStartTime,114) AS DATETIME)
           END AS MaintenanceWindowStartTime,
           CASE WHEN MaintenanceWindowDateModifer = -1 THEN
              DATEADD(DAY,MaintenanceWindowDateModifer*-1,CAST(CONVERT(CHAR(10),GETDATE(),111) + ' ' + CONVERT(CHAR(10),MaintenanceWindowEndTime,114) AS DATETIME))
           ELSE
              CAST(CONVERT(CHAR(10),GETDATE(),111) + ' ' + CONVERT(CHAR(10),MaintenanceWindowEndTime,114) AS DATETIME)
           END AS MaintenanceWindowEndTime
      INTO #RelativeMaintenanceWindows
      FROM MaintenanceWindow
     WHERE MainteanceWindowWeekdays LIKE '%' + DATENAME(DW,GETDATE()) + '%'
 
      SELECT TOP 1 @MaintenanceWindowName = MaintenanceWindowName,
             @MWStartTime = MaintenanceWindowStartTime,
             @MWEndTime = MaintenanceWindowEndTime
        FROM #RelativeMaintenanceWindows
       WHERE MaintenanceWindowStartTime <= GETDATE() AND MaintenanceWindowEndTime >= GETDATE()
    ORDER BY MaintenanceWindowStartTime ASC

	IF (@MaintenanceWindowName IS NULL)
	BEGIN
		IF (@DebugMode = 1)
			PRINT 'No maintenance window found.  Stopping script on ' + CONVERT(VARCHAR(255),GETDATE(),121)
		RETURN	
	END

	IF (@DebugMode = 1)
		PRINT '... Running maintenance script for ' + @MaintenanceWindowName

    -- We need to calculate the Default Op Time, the default value in V1 was 1 HOUR (60*60*1000)
    -- However this doesn't work for small maintenance windows.  Small maintenance windows
    -- are ideal for small tables, therefore the default option on these should also be recalculated
    -- to match the small maintenance window.
    --
    -- Default Op will now assume that it will take approx 1/10 of time allocated to a maintenance
    -- window.

    SET @DefaultOpTime = DATEDIFF(MILLISECOND,@MWStartTime,@MWEndTime) / 10

    -- We are starting maintenance schedule all over therefore
    -- We'll assume the database is in health state, (i.e. transaction log is not at capacity).
    --
    -- However after the first index gets maintained we will re-check to make sure this is still valid state.
    UPDATE dbo.DatabaseStatus
       SET IsLogFileFull = 0

	SELECT @ServerEdition = CAST(SERVERPROPERTY('EngineEdition') AS int) -- 3 = Enterprise, Developer, Enterprise Eval
	
	DECLARE cuIndexList
	 CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY
	    FOR SELECT DatabaseID, DatabaseName, SchemaName, TableID, TableName, IndexID, PartitionNumber, IndexName, IndexFillFactor, OfflineOpsAllowed, LastManaged, LastScanned, LastEvaluated, SkipCount, MaxSkipCount
	          FROM dbo.MasterIndexCatalog MIC
	          JOIN dbo.MaintenanceWindow  MW   ON MIC.MaintenanceWindowID = MW.MaintenanceWindowID
	         WHERE MW.MaintenanceWindowName = @MaintenanceWindowName
               AND ((MIC.RangeScanCount > 0 AND @IgnoreRangeScans = 0) OR (@IgnoreRangeScans = 1))
          ORDER BY MIC.LastManaged ASC, MIC.SkipCount ASC, RangeScanCount DESC
	
	OPEN cuIndexList
	
		FETCH NEXT FROM cuIndexList
		INTO @DatabaseID, @DatabaseName, @SchemaName, @TableID, @TableName, @IndexID, @PartitionNumber, @IndexName, @IndexFillFactor, @OfflineOpsAllowed, @LastManaged, @LastScanned, @LastEvaluated, @SkipCount, @MaxSkipCount
		
		WHILE @@FETCH_STATUS = 0
		BEGIN  -- START -- CURSOR

			IF (@DebugMode = 1)
				PRINT '... Assessing Index: ' + @DatabaseName + '.' + @SchemaName + '.' + @TableName + '(' + @IndexName + ' Partition: ' + CAST(@PartitionNumber AS VARCHAR) + ')'

            -- Only manage the current index if current database's tlog is not full, index skip count has been reached
            -- and there is still time in maintenance window.
            IF (((NOT EXISTS (SELECT * FROM dbo.DatabaseStatus WHERE DatabaseID = @DatabaseID AND IsLogFileFull = 1)) AND
                             (@SkipCount >= @MaxSkipCount)) AND
                             ((DATEADD(MILLISECOND,@FiveMinuteCheck,GETDATE())) < @MWEndTime))
            BEGIN -- START -- Maintain Indexes for Databases where TLog is not Full.

				IF (@DebugMode = 1)
					PRINT '... ... Evaluating Index'

			    SET @IndexOperation = 'NOOP'      --No Operation
				SET @ReasonForNOOP = 'No Reason.' --Default value.
			    SET @RebuildOnline = 1		      --If rebuild is going to execute it should be online.

				-- Update critical settings before maintaing to make sure the indexes are not disabled.
			    SET @SQL = 'UPDATE dbo.MasterIndexCatalog
			                   SET IsDisabled = i.is_disabled,
			                       IndexPageLockAllowed = i.allow_page_locks
			                  FROM dbo.MasterIndexCatalog MIC
			                  JOIN [' + @DatabaseName + '].sys.indexes i
			                    ON MIC.DatabaseID = ' + CAST(@DatabaseID AS varchar) + '
			                   AND MIC.TableID = i.object_id 
			                   AND MIC.IndexID = i.index_id
							  JOIN [' + @DatabaseName + '].sys.partitions p
							    ON i.object_id = p.object_id
						       AND i.index_id = p.index_id
                             WHERE i.object_id = ' + CAST(@TableID AS varchar) + '
                               AND i.index_id = ' + CAST(@IndexID AS varchar)  + '
							   AND p.partition_number = ' + CAST(@PartitionNumber AS varchar)
                               
			    EXEC (@SQL)

			    DECLARE @IsDisabled				BIT
			    DECLARE @IndexPageLockAllowed	BIT

			    SELECT @IsDisabled = IsDisabled, @IndexPageLockAllowed = IndexPageLockAllowed
			      FROM dbo.MasterIndexCatalog MIC
			     WHERE MIC.DatabaseID = @DatabaseID
			       AND MIC.TableID = @TableID
			       AND MIC.IndexID = @IndexID
				   AND MIC.PartitionNumber = @PartitionNumber

                -- Since it is not skipped; the skip counter is reinitialized to 0.				
				UPDATE dbo.MasterIndexCatalog
				   SET SkipCount = 0,
                       LastEvaluated = GetDate()
				 WHERE DatabaseID = @DatabaseID
				   AND TableID = @TableID
				   AND IndexID = @IndexID 
				   AND PartitionNumber = @PartitionNumber
			 
			    IF (@IsDisabled = 0)
			    BEGIN -- START -- Decide on Index Operation
	
				    DECLARE @FragmentationLevel float
				    DECLARE @PageCount			bigint
				
				    SET @OpStartTime = GETDATE()
				
				    SELECT @FragmentationLevel = avg_fragmentation_in_percent, @PageCount = page_count
				      FROM sys.dm_db_index_physical_stats(@DatabaseID,@TableID,@IndexID,@PartitionNumber,'LIMITED')

				    SET @OpEndTime = GETDATE()
				
                    INSERT INTO dbo.MaintenanceHistory (MasterIndexCatalogID, Page_Count, Fragmentation, OperationType, OperationStartTime, OperationEndTime, ErrorDetails)
                    SELECT MIC.ID, @PageCount, @FragmentationLevel, 'FragScan', @OpStartTime, @OpEndTime, 'Index fragmentation scan completed; fragmentation level.'
                     FROM dbo.MasterIndexCatalog MIC
                    WHERE MIC.DatabaseID = @DatabaseID
                        AND MIC.TableID = @TableID
                        AND MIC.IndexID = @IndexID
						AND MIC.PartitionNumber = @PartitionNumber

				    UPDATE dbo.MasterIndexCatalog
				       SET LastScanned = @OpEndTime
				     WHERE DatabaseID = @DatabaseID
				       AND TableID = @TableID
				       AND IndexID = @IndexID 
					   AND PartitionNumber = @PartitionNumber
				
				    -- If fragmentation level is less then 10 we do not need to look at the index
				    -- does not matter if it is hot or other.
				    IF ((@FragmentationLevel >= 10.0) AND (@PageCount > 64))
				    BEGIN
				
					    -- Evaluate if the index supports online operations or not.

                        -- Lob Column Types
                        -- image, ntext, text, binary  Can't do online operations on Clustered Index if there are 
						-- LOB columns.
						IF (@IndexID = 1)
                        BEGIN

                            -- A cluster index can only be online if there are no lob column types
                            -- in underline table definition.

                            SET @SQL = 'DECLARE @RowsFound int
                                       
                                       SELECT @RowsFound = COUNT(*)
									     FROM [' + @DatabaseName + '].sys.indexes i
                                         JOIN [' + @DatabaseName + '].sys.tables t
                                           ON i.object_id = t.object_id
                                         JOIN [' + @DatabaseName + '].sys.columns c
                                           ON t.object_id = c.object_id
							             JOIN [' + @DatabaseName + '].sys.partitions p
							               ON i.object_id = p.object_id
						                  AND i.index_id = p.index_id
                                        WHERE i.index_id = 1
                                          AND c.system_type_id IN (34,35,99,173)
                                          AND i.object_id = ' + CAST(@TableID AS varchar) + '
										  AND p.partition_number = ' + CAST(@PartitionNumber AS VARCHAR) + '

								    IF (@RowsFound > 0)
								    BEGIN
									
										-- When updating the Online Supported same rule will apply to all
										-- partitions.
									    UPDATE dbo.MasterIndexCatalog
										   SET OnlineOpsSupported = 0
										 WHERE DatabaseID = ' + CAST(@DatabaseID AS varchar) + '
										   AND TableID = ' + CAST(@TableID AS varchar) + '
										   AND IndexID = ' + CAST(@IndexID AS varchar) + '
											   
								    END'
                        END
						ELSE
						BEGIN

							SET @SQL = ' UPDATE dbo.MasterIndexCatalog
											SET OnlineOpsSupported = 1
										   FROM dbo.MasterIndexCatalog MIC
										   JOIN [' + @DatabaseName + '].sys.indexes i (NOLOCK)
											 ON MIC.DatabaseID = ' + CAST(@DatabaseID AS varchar) + '
											AND MIC.TableID = i.object_id 
											AND MIC.IndexID = i.index_id
										  WHERE i.object_id = ' + CAST(@TableID AS varchar) + '
											AND i.index_id = ' + CAST(@IndexID AS varchar) 

						END

					    EXEC (@SQL)
					
					    SELECT @OnlineOpsSupported = OnlineOpsSupported
					      FROM dbo.MasterIndexCatalog MIC
					     WHERE MIC.DatabaseID = @DatabaseID
					       AND MIC.TableID = @TableID
					       AND MIC.IndexID = @IndexID
						   AND MIC.PartitionNumber = @PartitionNumber
							
					    -- Index has some fragmentation and is at least 64 pages.  So we want to evaluate
					    -- if it should be maintained or not.  If it is HOT Table, it should be
					    -- maintained; however if it is not HOT Table, then it will only be maintained
					    -- if it has at least 1000 pages.
					    IF ((@MaintenanceWindowName = 'HOT Tables') OR
				            ((@MaintenanceWindowName <> 'HOT Tables') AND (@PageCount >= 1000)))
					    BEGIN
					
						    -- Either it is a hot index with 64 pages or index has at least 1000
						    -- pages and the fragmentation needs to be addressed.
						    IF ((@FragmentationLevel < 30.0) AND (@IndexPageLockAllowed = 1))
						    BEGIN
						
							    SET @IndexOperation = 'REORGANIZE'
						
						    END
						    ELSE
						    BEGIN
							
							    IF ((@FragmentationLevel < 30.0) AND (@IndexPageLockAllowed = 0))
							    BEGIN
							
								    -- Index Organization is not allowed because page lock is not allowed for the index.
								    -- Therefore only option is to rebuild the index, however to rebuild index online
								    -- online operations must be supported.
							
								    IF (((@OnlineOpsSupported = 0) OR (@ServerEdition <> 3)) AND (@OfflineOpsAllowed = 0))
								    BEGIN
									    -- Online operation not supported by table or edition.
									    -- However offline operations are not allowed and table cannot be
									    -- Reorganized because Page Locks are not allowed.
									
									    INSERT INTO dbo.MaintenanceHistory (MasterIndexCatalogID, Page_Count, Fragmentation, OperationType, OperationStartTime, OperationEndTime, ErrorDetails)
									    SELECT MIC.ID, @PageCount, @FragmentationLevel, 'ERROR', GETDATE(), GETDATE(),
									           'Failed to maintain index because Online not supported, offline not allowed, and page locks not allowed to do reorganize online.'
                                          FROM dbo.MasterIndexCatalog MIC
								         WHERE MIC.DatabaseID = @DatabaseID
								           AND MIC.TableID = @TableID
								           AND MIC.IndexID = @IndexID 
										   AND MIC.PartitionNumber = @PartitionNumber
								       
										SET @ReasonForNOOP = 'Error in index maintenance, please reference additional details in history log.'
										
								    END
								    ELSE
								    BEGIN

									    IF (((@OnlineOpsSupported = 0) OR (@ServerEdition <> 3)) AND (@OfflineOpsAllowed = 1))
									    BEGIN
										    SET @IndexOperation = 'REBUILD'
										    SET @RebuildOnline = 0
									    END
                                        ELSE
                                        BEGIN
                                            SET @IndexOperation = 'NOOP'
                                            SET @ReasonForNOOP = 'Index does not support index reorganization or offline index rebuild however fragmentation has not reached critical point (30%+) to rebuild.'
                                        END

                                        -- Apr. 25, 2014 - this functionality is being removed.  Systems which do not allow reorganize
                                        --                 can be rebuild to manage fragmentation, however we do not want to manage
                                        --                 the fragmentation at a low value.  Having low fragmentation
                                        --                 this functionality was still triggering a rebuild.  Which is costly
                                        --                 operation for large indexes. Replaced with code above, i.e.
                                        --                 Index Operation = NOOP.

                                        /*
									    ELSE
									    BEGIN
									
										    IF ((@OnlineOpsSupported = 1) AND (@ServerEdition = 3) AND (@OfflineOpsAllowed = 0))
										    BEGIN
											    SET @IndexOperation = 'REBUILD'
											    SET @RebuildOnline = 1
										    END
										
									    END
                                        */
								
								    END
								
							    END
							    ELSE
							    BEGIN
							
								    -- If script came to this phase; then it must mean the fragmentation is
								    -- higher then 30%.  Therefore index must be rebuilt.
								       
								    IF ((@OnlineOpsSupported = 1) AND (@ServerEdition = 3))
								    BEGIN
									    SET @IndexOperation = 'REBUILD'
									    SET @RebuildOnline = 1
								    END
								    ELSE
								    BEGIN
									    -- Online operations are not supported by the table or edition.
									
									    IF (@OfflineOpsAllowed = 1)
									    BEGIN
										    SET @IndexOperation = 'REBUILD'
										    SET @RebuildOnline = 0
									    END
									    ELSE
									    BEGIN
									
										    IF (@IndexPageLockAllowed = 1)
										    BEGIN
											    SET @IndexOperation = 'REORGANIZE'
										    END
										    ELSE
										    BEGIN
											    INSERT INTO dbo.MaintenanceHistory (MasterIndexCatalogID, Page_Count, Fragmentation, OperationType, OperationStartTime, OperationEndTime, ErrorDetails)
											    SELECT MIC.ID, @PageCount, @FragmentationLevel, 'ERROR', GETDATE(), GETDATE(),
												       'Failed to maintain index because Online not supported, offline not allowed, and page locks not allowed to do reorganize online.'
											      FROM dbo.MasterIndexCatalog MIC
											     WHERE MIC.DatabaseID = @DatabaseID
											       AND MIC.TableID = @TableID
											       AND MIC.IndexID = @IndexID 
												   AND MIC.PartitionNumber = @PartitionNumber
											       
												SET @ReasonForNOOP = 'Error in index maintenance, please reference additional details in history log.'
										    END
										
									    END
									
								    END
								
							    END
							
						    END

					    END
					    ELSE
					    BEGIN
							SET @ReasonForNOOP = 'Small table not part of HOT maintenance window.'
						END 

				    END
				    ELSE
				    BEGIN
						SET @ReasonForNOOP = 'Small table (less then 64KB) or low fragmentation (less then 10%).'
					END
								
			    END -- END -- Decide on Index Operation
				ELSE
				BEGIN -- START -- Index is disabled just record reason for NOOP
					SET @ReasonForNOOP = 'Index disabled.'
					IF (@DebugMode = 1)
						PRINT '... ... Index disabled.'
				END -- END -- Index is disabled just record reason for NOOP
				
			    IF (@IndexOperation <> 'NOOP')
			    BEGIN -- START -- Calculate and Execute Index Operation
				
				    -- Decisions around Index Operation has been made; therefore its time to do the actual work.
				    -- However before we can execute we must evaluate the maintenance window requirements.
				
				    DECLARE @IndexReorgTime		int
				    DECLARE @IndexRebuildTime	int
				    DECLARE @OpTime				int
				    DECLARE @EstOpEndTime		datetime
				 
					-- Calculate the approx time for index operation.  This can be one of three values.
					--
					-- Chosing the largest of the three.
					-- Default Value : Mainteance Window Size / 10.
					-- Previous Operation History : Average
					-- Object of Similar Size (+/- 15%) : Average

					IF (@DebugMode = 1)
						PRINT '... ... Index Op Selected: ' + @IndexOperation

					DECLARE @StdDivTime FLOAT
					DECLARE @AvgTime FLOAT
					DECLARE @HistCount INT
					DECLARE @PartitionCount INT

					SELECT @PartitionCount = COUNT(*) 
				      FROM dbo.MasterIndexCatalog MIC
					 WHERE MIC.DatabaseID = @DatabaseID
					   AND MIC.TableID = @TableID
					   AND MIC.IndexID = @IndexID

					-- Step #1: Do we have history for current object?
					SELECT @HistCount = COUNT(*) 
				      FROM dbo.MaintenanceHistory MH
					  JOIN dbo.MasterIndexCatalog MIC
						ON MH.MasterIndexCatalogID = MIC.ID
					 WHERE MH.OperationType LIKE @IndexOperation + '%'
					   AND MIC.DatabaseID = @DatabaseID
					   AND MIC.TableID = @TableID
					   AND MIC.IndexID = @IndexID
					   AND MIC.PartitionNumber = @PartitionNumber

					IF (@HistCount > 0)
					BEGIN

						IF (@DebugMode = 1)
							PRINT '... ... Calculating operation time cost.'

						-- Step #1: Calculate standard diviation to help us eliminate outliers.
						SELECT @StdDivTime = STDEV(DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime))
						  FROM dbo.MaintenanceHistory MH
						  JOIN dbo.MasterIndexCatalog MIC
							ON MH.MasterIndexCatalogID = MIC.ID
						 WHERE MH.OperationType LIKE @IndexOperation + '%'
						   AND MIC.DatabaseID = @DatabaseID
						   AND MIC.TableID = @TableID
						   AND MIC.IndexID = @IndexID
						   AND MIC.PartitionNumber = @PartitionNumber

						-- Step #2: Calculate the average time.
						SELECT @AvgTime = AVG(DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime))
						  FROM dbo.MaintenanceHistory MH
						  JOIN dbo.MasterIndexCatalog MIC
							ON MH.MasterIndexCatalogID = MIC.ID
						 WHERE MH.OperationType LIKE @IndexOperation + '%'
						   AND MIC.DatabaseID = @DatabaseID
						   AND MIC.TableID = @TableID
						   AND MIC.IndexID = @IndexID
						   AND MIC.PartitionNumber = @PartitionNumber

						-- Step #3: Calculate the average time removing excluding outliers.
						SELECT @AvgTime = AVG(DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime))
						  FROM dbo.MaintenanceHistory MH
						  JOIN dbo.MasterIndexCatalog MIC
							ON MH.MasterIndexCatalogID = MIC.ID
						 WHERE MH.OperationType LIKE @IndexOperation + '%'
						   AND MIC.DatabaseID = @DatabaseID
						   AND MIC.TableID = @TableID
						   AND MIC.IndexID = @IndexID
						   AND MIC.PartitionNumber = @PartitionNumber
						   AND DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime) > (@AvgTime - @StdDivTime)
						   AND DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime) < (@AvgTime + @StdDivTime)

						IF (@DebugMode = 1)
							PRINT '... ... Cost Calculated (ms): ' + CAST(@AvgTime AS VARCHAR)
					END
					ELSE
					BEGIN

						IF (@DebugMode = 1)
							PRINT '... ... New index unknown cost, calculating based on similar index sizes.'

						-- Step #1: Calculate standard diviation to help us eliminate outliers.
						SELECT @StdDivTime = STDEV(DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime))
						  FROM dbo.MaintenanceHistory MH
						  JOIN dbo.MasterIndexCatalog MIC
							ON MH.MasterIndexCatalogID = MIC.ID
						 WHERE MH.OperationType LIKE @IndexOperation + '%'
						   AND MH.Page_Count >= @PageCount - (@PageCount * .15)
						   AND MH.Page_Count <= @PageCount + (@PageCount * .15)

						-- Step #2: Calculate the average time.
						SELECT @AvgTime = AVG(DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime))
						  FROM dbo.MaintenanceHistory MH
						  JOIN dbo.MasterIndexCatalog MIC
							ON MH.MasterIndexCatalogID = MIC.ID
						 WHERE MH.OperationType LIKE @IndexOperation + '%'
						   AND MH.Page_Count >= @PageCount - (@PageCount * .15)
						   AND MH.Page_Count <= @PageCount + (@PageCount * .15)

						-- Step #3: Calculate the average time removing excluding outliers.
						SELECT @AvgTime = AVG(DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime))
						  FROM dbo.MaintenanceHistory MH
						  JOIN dbo.MasterIndexCatalog MIC
							ON MH.MasterIndexCatalogID = MIC.ID
						 WHERE MH.OperationType LIKE @IndexOperation + '%'
						   AND MH.Page_Count >= @PageCount - (@PageCount * .15)
						   AND MH.Page_Count <= @PageCount + (@PageCount * .15)
						   AND DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime) > (@AvgTime - @StdDivTime)
						   AND DATEDIFF(MILLISECOND,MH.OperationStartTime,MH.OperationEndTime) < (@AvgTime + @StdDivTime)

						IF (@DebugMode = 1)
							PRINT '... ... Cost Calculated (ms): ' + CAST(@AvgTime AS VARCHAR)
					END

					IF (@AvgTime = 0)
						SET @OpTime = @DefaultOpTime
					Else
						SET @OpTime = @AvgTime
				
				    SET @EstOpEndTime = DATEADD(MILLISECOND,@OpTime,GETDATE())
				
					IF (@DebugMode = 1)
						PRINT '... ... Estimated Operation Completion DateTime ' + CONVERT(VARCHAR(255),@EstOpEndTime,121)

				    -- Confirm operation will complete before the Maintenance Window End Time.
				    IF (@EstOpEndTime < @MWEndTime)
				    BEGIN

						IF (@DebugMode = 1)
							PRINT '... ... ... Possible to maintain index.'
				    
						-- Index is being maintained so we will decrement the MaxSkipCount by 1; minimum value is 0.
						-- Only adjust if it is actual execution.
						IF (@PrintOnlyNoExecute = 0)
							UPDATE dbo.MasterIndexCatalog
							   SET MaxSkipCount = CASE WHEN (@LastManaged = '1900-01-01 00:00:00.000') AND @MaxSkipCount > 0 THEN @MaxSkipCount - 1
													   WHEN (@LastManaged = '1900-01-01 00:00:00.000') AND @MaxSkipCount < 0 THEN 0
													   WHEN (@MaxSkipCount - DATEDIFF(DAY,@LastManaged,GETDATE()) < 1) THEN 0
													   ELSE @MaxSkipCount - DATEDIFF(DAY,@LastManaged,GETDATE()) END
							 WHERE DatabaseID = @DatabaseID
							   AND TableID = @TableID
							   AND IndexID = @IndexID 
							   AND PartitionNumber = @PartitionNumber
					
					    SET @SQL = 'USE [' + @DatabaseName + ']
								    ALTER INDEX [' + @IndexName + ']
								    ON [' + @SchemaName + '].[' + @TableName + '] '
					            
					    IF (@IndexOperation = 'REORGANIZE')
					    BEGIN
						    SET @SQL = @SQL + 
								       ' REORGANIZE'
							IF (@PartitionCount > 1)
								SET @SQL = @SQL + ' PARTITION=' + CAST(@PartitionNumber AS VARCHAR)
					    END
					    ELSE
					    BEGIN

							IF (@PrintOnlyNoExecute = 0)
							BEGIN

								IF (@DebugMode = 1)
									PRINT '... ... Adjusting Fill Factor.  Before adjustment: ' + CAST(@IndexFillFactor AS VARCHAR)

								IF (@IndexFillFactor = 0)
								BEGIN
									SET @IndexFillFactor = 95
									SET @FFA = 0
								END
								ELSE
								BEGIN

									-- Adjust fill factor by 0 to 15%; for each day it didn't get maintained
									-- it will adjust fill factor by smaller number.
									--
									-- e.g. If index was maintained just yesterday; it'll adjust it by 15%
									--      If index was maintained 8 days ago; it will adjust it by 1%
									--      If index was maintained 9+ days ago; it will adjust it by 0%

									SET @FFA = ((8-DATEDIFF(DAY,@LastManaged,GETDATE()))*2)+1

									IF (@FFA < 1)
									   SET @FFA = 0

									IF (@FFA > 15)
									   SET @FFA = 15
								END
								
								SET @IndexFillFactor = @IndexFillFactor - @FFA
								
								IF (@IndexFillFactor < 70)
								BEGIN
									SET @IndexFillFactor = 70
									INSERT INTO dbo.MaintenanceHistory (MasterIndexCatalogID, Page_Count, Fragmentation, OperationType, OperationStartTime, OperationEndTime, ErrorDetails)
									SELECT MIC.ID, @PageCount, @FragmentationLevel, 'WARNING', GETDATE(), GETDATE(),
											'Index fill factor is dropping below 70%.  Please evaluate if the index is using a wide key, which might be causing excessive fragmentation.'
										FROM dbo.MasterIndexCatalog MIC
										WHERE MIC.DatabaseID = @DatabaseID
										AND MIC.TableID = @TableID
										AND MIC.IndexID = @IndexID 
										AND MIC.PartitionNumber = @PartitionNumber
								END
								
								IF (@DebugMode = 1)
									PRINT '... ... Adjusting Fill Factor.  After adjustment: ' + CAST(@IndexFillFactor AS VARCHAR)

								UPDATE dbo.MasterIndexCatalog
								   SET IndexFillFactor = @IndexFillFactor
								 WHERE DatabaseID = @DatabaseID
								   AND TableID = @TableID
								   AND IndexID = @IndexID 
								   AND PartitionNumber = @PartitionNumber
							END

						    SET @SQL = @SQL + 
								       ' REBUILD '

							IF (@PartitionCount > 1)
								SET @SQL = @SQL + ' PARTITION=' + CAST(@PartitionNumber AS VARCHAR)

							SET @SQL = @SQL + ' WITH (FILLFACTOR = ' + CAST(@IndexFillFactor AS VARCHAR) + ', 
									            SORT_IN_TEMPDB = ON,'


						    IF (@RebuildOnline = 1)
						    BEGIN
							    SET @SQL = @SQL + 
                                       ' MAXDOP = ' + CASE WHEN @IndexPageLockAllowed = 0 THEN '1' ELSE CAST(@MAXDOP AS VARCHAR) END + ', ' +
								       ' ONLINE = ON'
						    END
                            ELSE
                            BEGIN
							    SET @SQL = @SQL + 
                                       ' MAXDOP = ' + CAST(@MAXDOP AS VARCHAR)
                            END

						    SET @SQL = @SQL + ');'
					
					    END
					
					    SET @OpStartTime = GETDATE()
					
						IF (@PrintOnlyNoExecute = 1)
							Print @SQL
						ELSE
						BEGIN
							IF (@DebugMode = 1)
								PRINT '... ... ... Starting index mainteance operation. ' + CONVERT(VARCHAR(255),GETDATE(),121)
							EXEC (@SQL)
							IF (@DebugMode = 1)
								PRINT '... ... ... Finished index mainteance operation. ' + CONVERT(VARCHAR(255),GETDATE(),121)
						END
					
					    SET @OpEndTime = GETDATE()
					
						-- Only update if actual execution.
						IF (@PrintOnlyNoExecute = 0)
							UPDATE dbo.MasterIndexCatalog
							   SET LastManaged = @OpEndTime
							 WHERE DatabaseID = @DatabaseID
							   AND TableID = @TableID
							   AND IndexID = @IndexID 
							   AND PartitionNumber = @PartitionNumber
				
						-- Only Log if actual execution.
						IF (@PrintOnlyNoExecute = 0)
							INSERT INTO dbo.MaintenanceHistory (MasterIndexCatalogID, Page_Count, Fragmentation, OperationType, OperationStartTime, OperationEndTime, ErrorDetails)
							SELECT MIC.ID,
								   @PageCount,
								   @FragmentationLevel,
								   CASE WHEN @RebuildOnline = 1 THEN
									  @IndexOperation + ' (ONLINE)'
								   ELSE
									  @IndexOperation + ' (OFFLINE)'
								   END, @OpStartTime, @OpEndTime,'Completed. Command executed (' + @SQL + ')'
							  FROM dbo.MasterIndexCatalog MIC
							 WHERE MIC.DatabaseID = @DatabaseID
							   AND MIC.TableID = @TableID
							   AND MIC.IndexID = @IndexID 
							   AND MIC.PartitionNumber = @PartitionNumber
				
                        -- Check to make sure the transaction log file on the current database is not full.
                        -- If the transaction log file is full, we cannot maintain any more indexes for current database.

						IF (@DebugMode =1)
							PRINT '... ... ... Checking for TLog space'

                        IF EXISTS (SELECT * FROM tempdb.sys.all_objects WHERE name LIKE '#TLogSpace%')
                            DELETE FROM #TLogSpace
                        ELSE
                            CREATE TABLE #TLogSpace (DBName sysname, LogSize float, LogSpaceUsed float, LogStatus smallint)

                        INSERT INTO #TLogSpace
                        EXEC ('DBCC SQLPERF(LOGSPACE)')

                        SELECT @LogSpacePercentage = LogSpaceUsed
                          FROM #TLogSpace
                         WHERE DBName = db_name(@DatabaseID)

                        IF (@LogSpacePercentage > @MaxLogSpaceUsageBeforeStop)
                        BEGIN
							IF (@DebugMode =1)
								PRINT '... ... ... Log usage reached maximum.  No more indexes for database [' + @DatabaseName + '].'

						    INSERT INTO dbo.MaintenanceHistory (MasterIndexCatalogID, Page_Count, Fragmentation, OperationType, OperationStartTime, OperationEndTime, ErrorDetails)
						    SELECT MIC.ID, @PageCount, @FragmentationLevel, 'WARNING', GETDATE(), GETDATE(),
						           'Database reached Max Log Space Usage limit, therefore no further indexes will be maintained in this maintenance window current database.'
                              FROM dbo.MasterIndexCatalog MIC
					         WHERE MIC.DatabaseID = @DatabaseID
					           AND MIC.TableID = @TableID
					           AND MIC.IndexID = @IndexID 
							   AND MIC.PartitionNumber = @PartitionNumber

                            UPDATE dbo.DatabaseStatus
                               SET IsLogFileFull = 1
                             WHERE DatabaseID = @DatabaseID
                        END

				    END
				    ELSE
				    BEGIN -- BEING -- Index Skipped due to Maintenance Window constraint
				
					    IF (@LastManaged < DATEADD(DAY,-14,GETDATE()))
					    BEGIN

                            -- If we have not been able to maintain this index due to estimated mainteance cost
							-- based on statistics analysis above, we should flag this for the dba team.
							--
							-- This means this index is too large to maintain for current mainteance windows defined.
							-- Team should look at creating a larger window for this index.
										
						    INSERT INTO dbo.MaintenanceHistory (MasterIndexCatalogID, Page_Count, Fragmentation, OperationType, OperationStartTime, OperationEndTime, ErrorDetails)
						    SELECT MIC.ID, @PageCount, @FragmentationLevel, 'WARNING', GETDATE(), GETDATE(),
						           'Index has not been managed in last 14 day due to maintenance window constraint.'
                              FROM dbo.MasterIndexCatalog MIC
					         WHERE MIC.DatabaseID = @DatabaseID
					           AND MIC.TableID = @TableID
					           AND MIC.IndexID = @IndexID 
								       
					    END

						-- Index was skipped due to maintenance window constraints.
                        -- i.e. if this index was to be maintained based on previous history it would go past the
                        -- maintenance window threshold.  Therefore it was skipped.  However if it is maintained
                        -- at start of maintenance window it should get maintained next cycle.

						UPDATE dbo.MasterIndexCatalog
						   SET SkipCount = @MaxSkipCount
						 WHERE DatabaseID = @DatabaseID
						   AND TableID = @TableID
						   AND IndexID = @IndexID 
						   AND PartitionNumber = @PartitionNumber
					
					    SET @EstOpEndTime = DATEADD(MILLISECOND,@FiveMinuteCheck,GETDATE())
					
					    -- We have reached the end of mainteance window therefore
					    -- we do not want to maintain any additional indexes.
					    IF (@EstOpEndTime > @MWEndTime)
						    RETURN
					
				    END -- END -- Index Skipped due to Maintenance Window constraint
			    END -- END -- Calculate and Execute Index Operation
			    ELSE
			    BEGIN -- START -- No Operation for current Index.
			    
					-- If index is not disabled we need to do some calculation regarding FFA, because if NOOP was chosen
					-- for an active index, it means it is not fragmented therefore we can adjust the Fill Factor setting 
					-- to better tune it for next time it becomes fragmented.
					--
					-- However if index is disabled we do not need to do anything just record it in history table the state
					-- and reason for NOOP.  Only adjust Fill Factor setting if it is actual run.
					
					IF ((@IsDisabled = 0) AND (@PrintOnlyNoExecute = 0))
					BEGIN -- START -- No Operation for current index and it is not disabled
					
						IF (@DebugMode = 1)
							PRINT '... ... Adjusting Fill Factor.  Before adjustment: ' + CAST(@IndexFillFactor AS VARCHAR)

						IF (@IndexFillFactor = 0)
						BEGIN
							SET @IndexFillFactor = 95
							SET @FFA = 0
						END
						ELSE
						BEGIN
							SET @FFA = DATEDIFF(DAY,@LastScanned,Getdate())

							IF (@FFA < 1)
								SET @FFA = 1

							IF (@FFA > 5)
								SET @FFA = 5
						END
									
						SET @IndexFillFactor = @IndexFillFactor + @FFA
									
						IF (@IndexFillFactor > 99)
							SET @IndexFillFactor = 99
							
						IF (@DebugMode = 1)
							PRINT '... ... Adjusting Fill Factor.  After adjustment: ' + CAST(@IndexFillFactor AS VARCHAR)

						UPDATE dbo.MasterIndexCatalog
						   SET IndexFillFactor = @IndexFillFactor,
							   MaxSkipCount = CASE WHEN (@LastScanned = '1900-01-01 00:00:00.000') AND @MaxSkipCount >= 0 THEN @MaxSkipCount + 1
												   WHEN (@LastScanned = '1900-01-01 00:00:00.000') AND @MaxSkipCount < 0 THEN 0
												   WHEN (@MaxSkipCount + DATEDIFF(DAY,@LastScanned,GetDate()) > 30) THEN 30
												   ELSE @MaxSkipCount + DATEDIFF(DAY,@LastScanned,GetDate()) END
						 WHERE DatabaseID = @DatabaseID
						   AND TableID = @TableID
						   AND IndexID = @IndexID
						   AND PartitionNumber = @PartitionNumber

					END -- END -- No Operation for current index and it is not disabled

					IF (@LogNOOPMsgs = 1)
						INSERT INTO dbo.MaintenanceHistory (MasterIndexCatalogID, Page_Count, Fragmentation, OperationType, OperationStartTime, OperationEndTime, ErrorDetails)
						SELECT MIC.ID,
							   @PageCount,
							   @FragmentationLevel,
							  'NOOP', @OpStartTime, @OpEndTime, @ReasonForNOOP
						 FROM dbo.MasterIndexCatalog MIC
						WHERE MIC.DatabaseID = @DatabaseID
						  AND MIC.TableID = @TableID
						  AND MIC.IndexID = @IndexID 
						  AND MIC.PartitionNumber = @PartitionNumber
							
			    END -- END -- No Operation for current Index.
			
            END -- END -- Maintain Indexes for Databases where TLog is not Full.
            ELSE
            BEGIN -- START -- Either TLog is Full or Skip Count has not reached Max Skip Count or We are out of time!

				IF (@DebugMode = 1)
					PRINT '... ... Skipping Index - Index Skipped or Mainteance Window Reached or TLog Full'

                -- There is no operation to execute if database TLog is full.  However if 
                -- skip count has not been reached.  We must increment Skip Count for next time.
                --
                -- However if Database TLog is full then the index in fact did not get skipped, it got ignored.
                -- Therefore skip counter should not be adjusted; neither should the last evaluated date
                -- as index was not evaluated due to tlog being full.

                IF ((NOT EXISTS (SELECT * FROM dbo.DatabaseStatus WHERE DatabaseID = @DatabaseID AND IsLogFileFull = 1)) AND
                    (DATEADD(MILLISECOND,@FiveMinuteCheck,GETDATE())) < @MWEndTime)
                BEGIN -- START -- Database T-Log Is Not Full And We Are Not Out Of Time; i.e. Index was skipped due to skip count.
                    IF (@SkipCount <= @MaxSkipCount)
                    BEGIN -- START -- Increment Skip Count

						-- Only Adjust Skip Count Values if Normal Run
						IF (@PrintOnlyNoExecute = 0)
						BEGIN

							IF (@DebugMode = 1)
								PRINT '... ... Increasing skip count.'

							UPDATE dbo.MasterIndexCatalog
							   SET SkipCount = @SkipCount + DATEDIFF(DAY,@LastEvaluated,GetDate()),
								   LastEvaluated = GetDate()
							 WHERE DatabaseID = @DatabaseID
							   AND TableID = @TableID
							   AND IndexID = @IndexID 
							   AND PartitionNumber = @PartitionNumber
						END

                    END -- END -- Increment Skip Count
                END -- END -- Database T-Log Is Not Full And We Are Not Out Of Time
                ELSE
                BEGIN
                    IF ((NOT EXISTS (SELECT * FROM dbo.DatabaseStatus WHERE DatabaseID = @DatabaseID AND IsLogFileFull = 1)) AND
                        (DATEADD(MILLISECOND,@FiveMinuteCheck,GETDATE())) > @MWEndTime)
                    BEGIN -- START -- Database T-Log Is Not Full But We Are Out Of Time
						IF (@DebugMode = 1)
								PRINT '... ... Reached end of mainteance window.'
                        GOTO TheEnd
                    END -- END -- Database T-Log Is Not Full But We Are Out Of Time
                END
            END -- END -- Either TLog is Full or Skip Count has not reached Max Skip Count

			FETCH NEXT FROM cuIndexList
			INTO @DatabaseID, @DatabaseName, @SchemaName, @TableID, @TableName, @IndexID, @PartitionNumber, @IndexName, @IndexFillFactor, @OfflineOpsAllowed, @LastManaged, @LastScanned, @LastEvaluated, @SkipCount, @MaxSkipCount
		
		END -- END -- CURSOR
		
	CLOSE cuIndexList
	
	DEALLOCATE cuIndexList
	-- End of Stored Procedure

TheEnd:
IF (@DebugMode = 1)
	PRINT 'Finishing index mainteance at ' + CONVERT(VARCHAR(255),GETDATE(),121)

END
GO