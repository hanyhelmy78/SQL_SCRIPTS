----------------------------------------------------------------
-------- Ultimate Compression Savings Estimation Check ---------
----------------------------------------------------------------
-- Author: Eitan Blumin | https://www.eitanblumin.com
-- Create Date: 2019-12-08
-- Last Update: 2020-09-06
-- Source: http://bit.ly/SQLCompressionEstimation
-- Full Link: https://gist.github.com/EitanBlumin/85cf620f7267b234d677f9c3027fb7ce
----------------------------------------------------------------
-- Description:
-- ------------
-- This script performs compression savings estimation check for both PAGE and ROW
-- compression for an ENTIRE DATABASE.
-- For each index which passes the check, a corresponding ALTER INDEX command
-- is printed for you to use in order to apply the compression.
-- The script also compares the results of the PAGE and ROW estimations and automatically
-- selects the one with the better savings as the command to print, based on the provided thresholds.
-- This script uses mathematical rounding functions FLOOR and CEILING in a manner which makes it more "cautious".
--
-- Some of the algorithms in this script were adapted from the following resources:
-- https://www.sqlservercentral.com/blogs/introducing-what_to_compress-v2
-- https://github.com/microsoft/tigertoolbox/tree/master/Evaluate-Compression-Gains
----------------------------------------------------------------
-- Change Log:
-- -----------
-- 2020-09-30 - added @MaxDOP parameter
-- 2020-09-06 - added support for readable secondaries, added MAXDOP 1 for the query from operational stats to avoid access violation bug
-- 2020-03-30 - added filter to ignore indexes and tables with unsupported LOB/FILESTREAM columns
-- 2020-03-16 - added informational and status messages in output script
-- 2020-03-15 - tweaked default parameter values a bit, and added server uptime message
-- 2020-02-26 - added best guess for unknown compression recommendations, improved performance for DBs with many objects
-- 2020-02-19 - added support for Azure SQL DB
-- 2020-02-18 - cleaned the code a bit and fixed some bugs
-- 2020-02-17 - added specific database support, adjusted tabs to match github standard, added compatibility checks
-- 2020-02-16 - added threshold parameters, and additional checks based on partition stats and operational stats
-- 2019-12-09 - added ONLINE rebuild option
-- 2019-12-24 - flipped to traditional ratio calculation; added READ UNCOMMITTED isolation level; added minimum difference thresholds for PAGE vs. ROW considerations
----------------------------------------------------------------
-- 
-- IMPORTANT !!!
-- -------------
--
-- 1. Don't forget to change the @DatabaseName parameter value to the one you want to check.
--
-- 2. BE MINDFUL IN PRODUCTION ENVIRONMENTS !
--
--		- If you want to be extra careful, run this script with @FeasibilityCheckOnly set to 1. This will perform only basic checks for compression candidates
--		  based on usage and operational stats only, without running [sp_estimate_data_compression_savings].
--
--		- Running this script with @FeasibilityCheckOnly = 0 may take a very long time on big databases with many tables, and significant IO + CPU stress may be noticeable.
--
--		- Schema-level locks may be held for a while per each table, and will possibly block other sessions performing DDL operations.
--
--		- This script uses [sp_estimate_data_compression_savings] which copies 5 % of your data into TempDB and compresses it there.
--		  If you have very large tables, you must be very careful not to fill out the disk.
--		  Please use the following cautionary threshold parameters to avoid such scenarios: @MaxSizeMBForActualCheck, @TempDBSpaceUsageThresholdPercent
----------------------------------------------------------------
-- Parameters:
-- -----------
DECLARE
	-- Choose what to check:
	 @DatabaseName				SYSNAME		= NULL		-- Specify the name of the database to check. If NULL, will use current.
	,@FeasibilityCheckOnly			BIT		= 1		-- If 1, will only check for potential compression candidates, without using sp_estimate_data_compression_savings and without generating remediation scripts
	,@CheckPerPartition			BIT		= 0		-- If 1, will perform separate estimation checks per partition
	,@MinimumSizeMB				INT		= 256		-- Minimum table/partition size in MB in order to perform estimation checks on it

	-- Cautionary thresholds:
	,@MaxSizeMBForActualCheck		INT		= 50000		-- If a table/partition is bigger than this size (in MB), then sp_estimate_data_compression_savings will NOT be executed for it
	,@TempDBSpaceUsageThresholdPercent	INT		= 60		-- A percentage number between 1 and 100, representing how much of the disk space available to TempDB is allowed to be used for the estimation checks
	 
	-- Threshold parameters controlling recommendation algorithms based on partition stats:
	,@MinimumCompressibleDataPercent	INT		= 45		-- Minimum percent of compressible in-row data, in order to consider any compression
	,@MinimumScanPercentForPage		INT		= 65		-- Minimum percent of range scans, in order to deem PAGE compression preferable
	,@MinimumScanPercentForRow		INT		= 45		-- Minimum percent of range scans, in order to deem ROW compression preferable
	,@MaximumUpdatePercentForPage		INT		= 30		-- Maximum percent of updates, in order to deem PAGE compression preferable
	,@MaximumUpdatePercentForRow		INT		= 50		-- Maximum percent of updates, in order to deem ROW compression preferable

	-- Threshold parameters controlling recommendation algorithms based on savings estimation check:
	,@CompressionRatioThreshold		FLOAT		= 45		-- Number between 0 and 100 representing the minimum compressed data ratio, relative to current size, for which a check will pass
	,@CompressionSizeSavedMBThreshold	FLOAT		= 200		-- Minimum estimated saved space in MB resulting from compression (affects both PAGE and ROW compressions)
	,@MinimumRatioDifferenceForPage		FLOAT		= 10		-- Minimum difference in percentage between ROW and PAGE compression types, in order to deem PAGE compression preferable
	,@MinimumSavingsMBDifferenceForPage	FLOAT		= 40		-- Minimum difference in saved space in MB between ROW and PAGE compression types, in order to deem PAGE compression preferable

	-- Parameters controlling the structure of output scripts:
	,@OnlineRebuild				BIT		= 1		-- If 1, will generate REBUILD commands with the ONLINE option turned on
	,@SortInTempDB				BIT		= 1		-- If 1, will generate REBUILD commands with the SORT_IN_TEMPDB option turned on
	,@MaxDOP					INT		= NULL	-- If not NULL, will add a MaxDOP option accordingly. Set to 1 to prevent parallelism and reduce workload.

--------------------------------------------------------------------
--     		  DO NOT CHANGE ANYTHING BELOW THIS LINE       	  --
--------------------------------------------------------------------

SET NOCOUNT, ARITHABORT, XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Variable declaration
DECLARE @CMD NVARCHAR(MAX), @AvailableTempDBSpaceMB INT, @ErrMsg NVARCHAR(MAX)
DECLARE @CurrDB SYSNAME, @Schema SYSNAME, @Table SYSNAME, @ObjectId INT, @IndexId INT, @IndexName SYSNAME, @Partition INT, @CompressionType VARCHAR(4), @EstimationCheckRecommended BIT, @TotalSizeMB INT, @InRowPercent INT, @ScanPercent INT, @UpdatePercent INT
DECLARE @Results AS TABLE ([object_name] SYSNAME, [schema_name] SYSNAME, index_id INT, partition_number INT, size_w_current_compression_KB FLOAT, size_w_requested_compression_KB FLOAT, sample_size_current_KB INT, sample_size_requested_KB INT)
DECLARE @RebuildOptions NVARCHAR(MAX), @ChecksSkipped BIT

-- Compatibility checks
SELECT @ErrMsg = ISNULL(@ErrMsg + ', ', N'Sorry, this SQL Server version is not supported. Missing object(s): ') + objectname
FROM (
SELECT objectname = CONVERT(nvarchar(500), 'sys.tables')
UNION ALL SELECT 'sys.dm_os_volume_stats' WHERE CONVERT(varchar(300),SERVERPROPERTY('Edition')) <> 'SQL Azure'
UNION ALL SELECT 'sys.master_files' WHERE CONVERT(varchar(300),SERVERPROPERTY('Edition')) <> 'SQL Azure'
UNION ALL SELECT 'sys.dm_db_index_operational_stats'
UNION ALL SELECT 'sys.dm_db_partition_stats'
UNION ALL SELECT 'sys.sp_estimate_data_compression_savings'
UNION ALL SELECT 'sys.indexes'
UNION ALL SELECT 'sys.partitions') AS t
WHERE OBJECT_ID(objectname) IS NULL;

IF @ErrMsg IS NOT NULL
BEGIN
	RAISERROR(@ErrMsg,16,1)
	GOTO Quit;
END

-- Init local variables and defaults
SET @RebuildOptions = N''
IF @OnlineRebuild = 1 SET @RebuildOptions = @RebuildOptions + N', ONLINE = ON'
IF @SortInTempDB = 1  SET @RebuildOptions = @RebuildOptions + N', SORT_IN_TEMPDB = ON'
IF @MaxDOP IS NOT NULL SET @RebuildOptions = @RebuildOptions + N', MAXDOP = ' + CONVERT(nvarchar(4000), @MaxDOP)
SET @ChecksSkipped = 0;
SET @FeasibilityCheckOnly = ISNULL(@FeasibilityCheckOnly, 1)

-- Validate mandatory percentage parameters
SELECT @ErrMsg = ISNULL(@ErrMsg + CHAR(10), N'Invalid parameter(s): ') + CONVERT(nvarchar(max), N'' + VarName + N' must be a value between 1 and 100')
FROM
(VALUES
	 ('@MinimumCompressibleDataPercent',@MinimumCompressibleDataPercent)
	,('@MinimumScanPercentForPage',@MinimumScanPercentForPage)
	,('@MinimumScanPercentForRow',@MinimumScanPercentForRow)
	,('@MaximumUpdatePercentForPage',@MaximumUpdatePercentForPage)
	,('@MaximumUpdatePercentForRow',@MaximumUpdatePercentForRow)
	,('@TempDBSpaceUsageThresholdPercent',@TempDBSpaceUsageThresholdPercent)
	,('@CompressionRatioThreshold',@CompressionRatioThreshold)
	,('@MinimumRatioDifferenceForPage',@MinimumRatioDifferenceForPage)
) AS v(VarName,VarValue)
WHERE VarValue NOT BETWEEN 1 AND 100 OR VarValue IS NULL
OPTION (RECOMPILE);

IF @ErrMsg IS NOT NULL
BEGIN
	RAISERROR(@ErrMsg,16,1);
	GOTO Quit;
END

IF @FeasibilityCheckOnly = 0 AND CONVERT(varchar(300),SERVERPROPERTY('Edition')) <> 'SQL Azure'
BEGIN
	-- Check free space remaining for TempDB
	SET @CMD = N'USE tempdb;
SELECT @AvailableTempDBSpaceMB = SUM(ISNULL(available_space_mb,0)) FROM
(
-- Get available space inside data files
SELECT 
  vs.volume_mount_point
, available_space_mb = SUM(ISNULL(f.size - FILEPROPERTY(f.[name], ''SpaceUsed''),0)) / 128 
			+ SUM(CASE
				-- If auto growth is disabled
				WHEN f.max_size = 0 THEN 0
				-- If remaining growth size is smaller than remaining disk space, use remaining growth size till max size
				WHEN f.max_size > 0 AND (f.max_size - f.size) / 128 < (vs.available_bytes / 1024 / 1024) THEN (f.max_size - f.size) / 128
				-- Else, do not count available growth for this file
				ELSE 0
			END)
FROM sys.master_files AS f
CROSS APPLY sys.dm_os_volume_stats (f.database_id, f.file_id)  AS vs
WHERE f.database_id = 2
AND f.type = 0
GROUP BY vs.volume_mount_point

UNION ALL

-- Get available space on disk for auto-growth
SELECT 
  vs.volume_mount_point
, available_space_mb = vs.available_bytes / 1024 / 1024
FROM sys.master_files AS f
CROSS APPLY sys.dm_os_volume_stats (f.database_id, f.file_id)  AS vs
WHERE f.database_id = 2
AND f.type = 0
-- If max size is unlimited, or difference between current size and max size is bigger than available disk space
AND (f.max_size = -1 OR (f.max_size > 0 AND (f.max_size - f.size) / 128 > (vs.available_bytes / 1024 / 1024)))
GROUP BY vs.volume_mount_point, vs.available_bytes
) AS q OPTION (RECOMPILE);'

	EXEC sp_executesql @CMD, N'@AvailableTempDBSpaceMB INT OUTPUT', @AvailableTempDBSpaceMB OUTPUT

	-- Use @TempDBSpaceUsageThresholdPercent as a cautionary multiplier
	SET @AvailableTempDBSpaceMB = @AvailableTempDBSpaceMB * 1.0 * (@TempDBSpaceUsageThresholdPercent / 100.0)

	IF @MaxSizeMBForActualCheck > FLOOR(@AvailableTempDBSpaceMB / 0.05)
	BEGIN
		RAISERROR(N'ALERT: %d percent of available TempDB Disk Space is less than 5 percent of specified @MaxSizeMBForActualCheck (%d). Please adjust @MaxSizeMBForActualCheck and/or @TempDBSpaceUsageThresholdPercent accordingly.', 16, 1, @TempDBSpaceUsageThresholdPercent, @MaxSizeMBForActualCheck);
		GOTO Quit;
	END
	ELSE IF ISNULL(@MaxSizeMBForActualCheck,0) <= 0 -- If @MaxSizeMBForActualCheck was not specified, use available TempDB space instead
		SET @MaxSizeMBForActualCheck = FLOOR(@AvailableTempDBSpaceMB / 0.05);
END

IF @OnlineRebuild = 1 AND ISNULL(CONVERT(int, SERVERPROPERTY('EngineEdition')),0) NOT IN (3,5,8)
BEGIN
	RAISERROR(N'-- WARNING: @OnlineRebuild is set to 1, but current SQL edition does not support ONLINE rebuilds.', 0, 1);
END

DECLARE @ObjectsToCheck AS TABLE
(
	[database_name] SYSNAME,
	[schema_name] SYSNAME,
	[table_id] INT,
	[table_name] SYSNAME,
	[index_id] INT,
	[index_name] SYSNAME NULL,
	[partition_number] INT NULL,
	size_MB INT,
	in_row_percent INT,
	range_scans_percent INT,
	updates_percent INT
);

-- The following code, making use of @CurrDB variable, is written in a way which would make
-- it easier to rewrite so that it can check multiple databases
/* start of potential for-each-db */
SET @CurrDB = ISNULL(@DatabaseName, DB_NAME())
PRINT N'------------------------------------------------------------------------------------'
PRINT N'------------- Compression Savings Estimation Check by Eitan Blumin -----------------'
PRINT N'--- Source: https://gist.github.com/EitanBlumin/85cf620f7267b234d677f9c3027fb7ce ---'
PRINT N'------------------------------------------------------------------------------------'
PRINT N'--- for Server: ' + @@SERVERNAME + N' , Database: ' + QUOTENAME(@CurrDB)
PRINT N'------------------------------------------------------------------------------------'

DECLARE @SqlStartTime DATETIME, @UpTimeDays INT, @SqlStartTimeString VARCHAR(25);
SELECT @SqlStartTime = sqlserver_start_time FROM sys.dm_os_sys_info;
SET @UpTimeDays = DATEDIFF(dd, @SqlStartTime, GETDATE())
SET @SqlStartTimeString = CONVERT(varchar(25), @SqlStartTime, 121)

RAISERROR(N'--- SQL Server is operational since %s (~%d days)', 0, 1, @SqlStartTimeString, @UpTimeDays) WITH NOWAIT;

-- Check whether TempDB is located on same disk as specified database
IF @SortInTempDB = 1 AND CONVERT(varchar(300),SERVERPROPERTY('Edition')) <> 'SQL Azure'
BEGIN
	IF EXISTS (
		SELECT fs.volume_mount_point
		FROM sys.master_files AS df
		CROSS APPLY sys.dm_os_volume_stats(df.database_id, df.file_id) AS fs
		WHERE df.type = 0
		AND df.database_id = DB_ID(@CurrDB)

		INTERSECT
					
		SELECT fs.volume_mount_point
		FROM sys.master_files AS df
		CROSS APPLY sys.dm_os_volume_stats(df.database_id, df.file_id) AS fs
		WHERE df.type = 0
		AND df.database_id = 2
		)
	RAISERROR(N'-- WARNING: @SortInTempDB is set to 1, but TempDB is located on the same disk drive as specified database "%s".', 0, 1, @CurrDB);
END

-- Make sure specified database is accessible
IF DB_ID(@CurrDB) IS NULL OR DATABASEPROPERTYEX(@CurrDB, 'Updateability') <> 'READ_WRITE' OR DATABASEPROPERTYEX(@CurrDB, 'Status') <> 'ONLINE'
BEGIN
	IF @FeasibilityCheckOnly = 0 OR DB_ID(@CurrDB) IS NULL OR DATABASEPROPERTYEX(@CurrDB, 'Status') <> 'ONLINE'
	BEGIN
		RAISERROR(N'Database "%s" is not valid for compression estimation check. Please make sure it is accessible and writeable.',16,1,@CurrDB);
		GOTO Quit;
	END
	ELSE
		RAISERROR(N'-- NOTE: Database "%s" is not writeable. You will not be able to rebuild its indexes here until it is writeable.',10,1,@CurrDB);
END

-- Get list of all un-compressed tables/partitions in the specified database
-- Use a temp table in order to improve performance for databases with many tables
SET @CMD = N'USE ' + QUOTENAME(@CurrDB) + N';
IF OBJECT_ID(''tempdb..#objects'') IS NOT NULL DROP TABLE #objects;
CREATE TABLE #objects
(
  [schema_name] SYSNAME
, [object_id] INT
, [table_name] SYSNAME
, [index_id] INT NULL
, [index_name] SYSNAME NULL
, [partition_number] INT NULL
, [size_MB] INT
, [in_row_percent] INT
);

INSERT INTO #objects
SELECT
	  OBJECT_SCHEMA_NAME(t.object_id)
	, t.object_id
	, t.name
	, p.index_id
	, ix.name
	, partition_number = ' + CASE WHEN @CheckPerPartition = 1 THEN N'p.partition_number' ELSE N'NULL' END + N'
	, size_MB = CEILING(SUM(ISNULL(sps.in_row_data_page_count,0) + ISNULL(sps.row_overflow_used_page_count,0) + ISNULL(sps.lob_reserved_page_count,0)) / 128.0)
	, in_row_percent = ISNULL(
				FLOOR(SUM(ISNULL(sps.in_row_data_page_count,0)) * 1.0 
				/ NULLIF(SUM(ISNULL(sps.in_row_data_page_count,0) + ISNULL(sps.row_overflow_used_page_count,0) + ISNULL(sps.lob_reserved_page_count,0)),0)
				* 100.0), 0)
FROM sys.tables AS t WITH(NOLOCK)
INNER JOIN sys.partitions AS p WITH(NOLOCK) ON t.object_id = p.object_id AND p.data_compression = 0
INNER JOIN sys.indexes AS ix WITH(NOLOCK) ON ix.object_id = t.object_id AND ix.index_id = p.index_id
INNER JOIN sys.dm_db_partition_stats AS sps WITH(NOLOCK) ON sps.partition_id = p.partition_id
WHERE 
-- Ignore system objects
    t.is_ms_shipped = 0
AND t.object_id > 255
AND OBJECT_SCHEMA_NAME(t.object_id) <> ''sys''
-- Ignore indexes or tables with unsupported LOB/FILESTREAM columns
AND NOT EXISTS
(
SELECT NULL
FROM sys.columns AS c
INNER JOIN sys.types AS t 
ON c.system_type_id = t.system_type_id
AND c.user_type_id = t.user_type_id
LEFT JOIN sys.index_columns AS ixc
ON ixc.object_id = c.object_id
AND ixc.column_id = c.column_id
AND ix.index_id = ixc.index_id
WHERE (t.[name] in (''text'', ''ntext'', ''image'') OR c.is_filestream = 1)
AND ix.object_id = c.object_id
AND (ix.index_id IN (0,1) OR ixc.index_id IS NOT NULL)
)
GROUP BY
	  t.object_id
	, t.name
	, p.index_id
	, ix.name' 
	+ CASE WHEN @CheckPerPartition = 1 THEN N', p.partition_number' ELSE '' END
+ CASE WHEN ISNULL(@MinimumSizeMB,0) > 0 THEN N'
HAVING
	CEILING(SUM(ISNULL(sps.in_row_data_page_count,0) + ISNULL(sps.row_overflow_used_page_count,0) + ISNULL(sps.lob_reserved_page_count,0)) / 128.0) >= ' + CONVERT(nvarchar, @MinimumSizeMB) 
ELSE N'' END + N'
OPTION (RECOMPILE);

SELECT
	  DB_NAME()
	, p.[schema_name]
	, p.object_id
	, p.table_name
	, p.index_id
	, p.index_name
	, p.partition_number
	, p.size_MB
	, p.in_row_percent
	, range_scans_percent = ISNULL(
				FLOOR(SUM(ISNULL(ios.range_scan_count,0)) * 1.0 /
				NULLIF(SUM(
					ISNULL(ios.range_scan_count,0) +
					ISNULL(ios.leaf_delete_count,0) + 
					ISNULL(ios.leaf_insert_count,0) + 
					ISNULL(ios.leaf_page_merge_count,0) + 
					ISNULL(ios.leaf_update_count,0) + 
					ISNULL(ios.singleton_lookup_count,0)
				), 0) * 100.0), 0)
	, updates_percent = ISNULL(
				CEILING(SUM(ISNULL(ios.leaf_update_count, 0)) * 1.0 /
				NULLIF(SUM(
					ISNULL(ios.range_scan_count,0) +
					ISNULL(ios.leaf_delete_count,0) + 
					ISNULL(ios.leaf_insert_count,0) + 
					ISNULL(ios.leaf_page_merge_count,0) + 
					ISNULL(ios.leaf_update_count,0) + 
					ISNULL(ios.singleton_lookup_count,0)
				), 0) * 100.0), 0)
FROM #objects AS p WITH(NOLOCK)
OUTER APPLY sys.dm_db_index_operational_stats(db_id(),p.object_id,p.index_id,p.partition_number) AS ios
GROUP BY
	  p.object_id
	, p.schema_name
	, p.table_name
	, p.index_id
	, p.index_name
	, p.partition_number
	, p.size_MB
	, p.in_row_percent
OPTION (RECOMPILE, MAXDOP 1);'

INSERT INTO @ObjectsToCheck
EXEC sp_executesql @CMD;

/* end of potential for-each-db */

-- Init temp table to hold final results
IF OBJECT_ID('tempdb..#ResultsAll') IS NOT NULL DROP TABLE #ResultsAll;
CREATE TABLE #ResultsAll (
	  [database_name] SYSNAME
	, [schema_name] SYSNAME
	, [table_name] SYSNAME
	, [index_name] SYSNAME NULL
	, partition_number INT NULL
	, size_MB INT NULL
	, in_row_percent INT NULL
	, scan_percent INT NULL
	, update_percent INT NULL
	, compression_type VARCHAR(4)
	, compression_ratio FLOAT
	, compression_size_saving_KB FLOAT
	, is_compression_feasible BIT
	, is_compression_recommended BIT
)

-- Init cursor to traverse all un-compressed tables that were found
DECLARE TablesToCheck CURSOR
LOCAL FORWARD_ONLY FAST_FORWARD
FOR
SELECT 
	  o.[database_name]
	, o.[schema_name]
	, o.[table_id]
	, o.[table_name]
	, o.[index_id]
	, o.[index_name]
	, o.[partition_number]
	, ct.CompressionType
	, o.size_MB
	, o.in_row_percent
	, o.range_scans_percent
	, o.updates_percent
FROM @ObjectsToCheck AS o
CROSS JOIN (VALUES('PAGE'),('ROW')) AS ct(CompressionType) -- check both ROW and PAGE compression for each

OPEN TablesToCheck

FETCH NEXT FROM TablesToCheck 
INTO @CurrDB, @Schema, @ObjectId, @Table, @IndexId, @IndexName, @Partition, @CompressionType, @TotalSizeMB, @InRowPercent, @ScanPercent, @UpdatePercent

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @sp_estimate_data_compression_savings NVARCHAR(1000);
	SET @sp_estimate_data_compression_savings = QUOTENAME(@CurrDB) + '.sys.sp_estimate_data_compression_savings'

	SET @EstimationCheckRecommended = CASE
						WHEN @InRowPercent < @MinimumCompressibleDataPercent THEN 0
						WHEN @CompressionType = 'PAGE' AND @ScanPercent >= @MinimumScanPercentForPage AND @UpdatePercent <= @MaximumUpdatePercentForPage THEN 1
						WHEN @CompressionType = 'ROW' AND @ScanPercent >= @MinimumScanPercentForRow AND @UpdatePercent <= @MaximumUpdatePercentForRow THEN 1
						WHEN ISNULL(@ScanPercent,0) = 0 AND ISNULL(@UpdatePercent,0) = 0 THEN 1
						ELSE 0
					END

	RAISERROR(N'--Database [%s], table [%s].[%s], index [%s], partition %d: size: %d MB, in-row data: %d percent, range scans: %d percent, updates: %d percent. Compression type: %s',0,1
				,@CurrDB,@Schema,@Table,@IndexName,@Partition,@TotalSizeMB,@InRowPercent,@ScanPercent,@UpdatePercent,@CompressionType) WITH NOWAIT;

	IF @FeasibilityCheckOnly = 0 AND @TotalSizeMB <= @MaxSizeMBForActualCheck AND @TotalSizeMB * 0.05 < @AvailableTempDBSpaceMB
	BEGIN
		IF @EstimationCheckRecommended = 1
		BEGIN
			BEGIN TRY
			-- Calculate compression savings estimation
			INSERT INTO @Results
			EXEC @sp_estimate_data_compression_savings
						 @schema_name		= @Schema,  
						 @object_name		= @Table,
						 @index_id		= @IndexId,
						 @partition_number	= @Partition,   
						 @data_compression	= @CompressionType;
			END TRY
			BEGIN CATCH
				DECLARE @EstimationErrMsg NVARCHAR(MAX)
				SET @EstimationErrMsg = ERROR_MESSAGE()
				RAISERROR(N'-- ERROR while running sp_estimate_data_compression_savings: %s',0,1,@EstimationErrMsg);
			END CATCH
		END
		ELSE
		BEGIN
			RAISERROR(N'-- Not a good candidate for compression. Skipping estimation check.',0,1);
			SET @ChecksSkipped = 1;
		END
	END
	ELSE IF @FeasibilityCheckOnly = 1
		SET @ChecksSkipped = 1
	ELSE
	BEGIN
		RAISERROR(N'-- Too big for TempDB. Skipping estimation check.',0,1);
		SET @ChecksSkipped = 1;
	END

	-- Save to main results table
	INSERT INTO #ResultsAll
	SELECT 
		  [database_name]		= @CurrDB
		, [schema_name]			= @Schema
		, table_name			= @Table
		, index_name			= @IndexName
		, partition_number		= @Partition
		, size_MB			= @TotalSizeMB
		, in_row_percent		= @InRowPercent
		, scan_percent			= @ScanPercent
		, update_percent		= @UpdatePercent
		, compression_type		= @CompressionType
		, compression_ratio		= 100 - (SUM(ISNULL(r.size_w_requested_compression_KB,0)) * 100.0 / NULLIF(SUM(ISNULL(r.size_w_current_compression_KB,0)),0))
		, compression_size_saving_KB	= SUM(ISNULL(r.size_w_current_compression_KB,0)) - SUM(ISNULL(r.size_w_requested_compression_KB,0))
		, is_compression_feasible	= @EstimationCheckRecommended
		, is_compression_recommended	= CASE
						WHEN @FeasibilityCheckOnly = 1 OR @EstimationCheckRecommended = 0 THEN NULL
						WHEN
							100 - (SUM(ISNULL(r.size_w_requested_compression_KB,0)) * 100.0 / NULLIF(SUM(ISNULL(r.size_w_current_compression_KB,0)),0)) >= @CompressionRatioThreshold 
						AND (SUM(ISNULL(r.size_w_current_compression_KB,0)) - SUM(ISNULL(r.size_w_requested_compression_KB,0))) / 1024.0 >= @CompressionSizeSavedMBThreshold
						THEN 1
						ELSE 0 END
	FROM
		@Results AS r
	OPTION (RECOMPILE);

	DELETE @Results;

	FETCH NEXT FROM TablesToCheck 
	INTO @CurrDB, @Schema, @ObjectId, @Table, @IndexId, @IndexName, @Partition, @CompressionType, @TotalSizeMB, @InRowPercent, @ScanPercent, @UpdatePercent
END

CLOSE TablesToCheck
DEALLOCATE TablesToCheck

IF @ChecksSkipped = 1
BEGIN
	PRINT N'-- One or more tables were not checked. Please adjust threshold parameter values and make sure you have enough free disk space if you want to run those checks anyway.'
END

-- Return results to client
SELECT
	 database_name
	,[schema_name]
	,[table_name]
	,full_table_name		= QUOTENAME([schema_name]) + '.' + QUOTENAME([table_name])
	,index_name
	,partition_number		= ISNULL(CONVERT(VARCHAR,partition_number),'ALL')
	,size_MB
	,compressible_data		= CONVERT(varchar(10), in_row_percent) + ' %'
	,scan_percent			= CONVERT(varchar(10), scan_percent) + ' %'
	,update_percent			= CONVERT(varchar(10), update_percent) + ' %'
	,compression_type
	,compression_ratio		= ROUND(compression_ratio,3)
	,compression_size_saving_MB	= compression_size_saving_KB / 1024.0
	,is_compression_candidate	= CASE WHEN is_compression_feasible = 1 THEN 'Yes' ELSE 'No' END
	,is_compression_recommended 	= CASE
						WHEN is_compression_recommended IS NULL AND is_compression_feasible = 1 THEN 
						CASE
							WHEN in_row_percent < @MinimumCompressibleDataPercent THEN N'No'
							WHEN scan_percent >= @MinimumScanPercentForPage AND update_percent <= @MaximumUpdatePercentForPage THEN
								CASE WHEN compression_type = 'PAGE' THEN 'Yes' ELSE 'No' END
							WHEN scan_percent >= @MinimumScanPercentForRow  AND update_percent <= @MaximumUpdatePercentForRow THEN
								CASE WHEN compression_type = 'ROW' THEN 'Yes' ELSE 'No' END
							WHEN compression_type = 'PAGE' AND ISNULL(scan_percent,0) = 0 AND ISNULL(update_percent,0) = 0 THEN 'Yes'
							ELSE 'No'
						END + ' (best guess)'
						WHEN is_compression_recommended = 1 THEN 'Yes' ELSE 'No' END
	,remediation_command		= 
					CASE WHEN ISNULL(is_compression_recommended,0) = 0 THEN N'-- ' ELSE N'' END
				+ N'USE ' + QUOTENAME([database_name]) + N'; ALTER ' + ISNULL(N'INDEX ' + QUOTENAME(index_name) + N' ON ', N'TABLE ') + QUOTENAME([schema_name]) + '.' + QUOTENAME([table_name]) 
				+ N' REBUILD PARTITION = ' + ISNULL(CONVERT(nvarchar,partition_number), N'ALL') 
				+ N' WITH (DATA_COMPRESSION = ' + compression_type + @RebuildOptions + N');'
FROM
	#ResultsAll
ORDER BY
	  [database_name] ASC
	, compression_size_saving_KB DESC
	, compression_ratio DESC
	, size_MB DESC
OPTION (RECOMPILE);

IF @@ROWCOUNT > 0 AND @FeasibilityCheckOnly = 0
BEGIN
	-- Begin generating remediation script that takes into consideration all checks
	-- including ROW vs. PAGE considerations
	DECLARE @StatusMsg NVARCHAR(MAX), @PrevDB SYSNAME;
	SET @PrevDB = N'';
	SET @CMD = NULL;
	PRINT N'-----------------------------------------------------------------------'
	PRINT N'---------- Recommendation Script Begins Below -------------------------'
	PRINT N'-----------------------------------------------------------------------'

	DECLARE Rebuilds CURSOR
	LOCAL FORWARD_ONLY FAST_FORWARD
	FOR
	SELECT
	  [database_name]
	, RemediationCmd = N'USE ' + QUOTENAME([database_name]) + N'; ALTER ' + ISNULL(N'INDEX ' + QUOTENAME(index_name) + N' ON ', N'TABLE ') + QUOTENAME([schema_name]) + '.' + QUOTENAME([table_name]) + N'
	REBUILD PARTITION = ' + ISNULL(CONVERT(nvarchar,partition_number), N'ALL') + N' WITH (DATA_COMPRESSION = ' + compression_type + @RebuildOptions + N');'
	, StatusMessage = QUOTENAME([database_name]) + N': ' + ISNULL(N'INDEX ' + QUOTENAME(index_name) + N' ON ', N'TABLE ') + QUOTENAME([schema_name]) + N'.' + QUOTENAME([table_name])
					+ N' PARTITION = ' + ISNULL(CONVERT(nvarchar,partition_number), N'ALL') + N', DATA_COMPRESSION = ' + compression_type
	FROM
	(
	SELECT
	  [database_name]
	, [schema_name]
	, table_name
	, index_name
	, compression_size_saving_KB
	, compression_ratio
	, compression_type
	, partition_number
	, SavingsRating = ROW_NUMBER() OVER (
				PARTITION BY 
					  [database_name]
					, table_name
					, index_name 
					, partition_number
				ORDER BY 
					compression_ratio + (CASE WHEN compression_type = 'ROW' THEN @MinimumRatioDifferenceForPage ELSE 0 END) DESC, 
					compression_size_saving_KB + (CASE WHEN compression_type = 'ROW' THEN ISNULL(@MinimumSavingsMBDifferenceForPage,0) * 1024.0 ELSE 0 END) DESC
				)
	FROM
		#ResultsAll
	WHERE
		is_compression_recommended = 1
	) AS q
	WHERE SavingsRating = 1
	ORDER BY
	  [database_name] ASC
	, compression_size_saving_KB DESC
	, compression_ratio DESC

	OPEN Rebuilds
	FETCH NEXT FROM Rebuilds INTO @CurrDB, @CMD, @StatusMsg

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @CurrDB <> @PrevDB
		BEGIN
			PRINT N'USE ' + QUOTENAME(@CurrDB) + N';
DECLARE @Size INT, @DB SYSNAME;
SELECT @Size = SUM(FILEPROPERTY([name], ''SpaceUsed'')) / 128.0 FROM sys.database_files WHERE type = 0;
SET @DB = DB_NAME();

RAISERROR(N''Space used for data in "%s" BEFORE compression: %d MB'', 0, 1, @DB, @Size) WITH NOWAIT;
GO'
			SET @PrevDB = @CurrDB;
		END

		PRINT N'DECLARE @time VARCHAR(25) = CONVERT(varchar(25), GETDATE(), 121); RAISERROR(N''%s - ' + REPLACE(REPLACE(@StatusMsg, '''', ''''''), '%', '') + N''',0,1,@time) WITH NOWAIT;'
		PRINT @CMD
		PRINT N'GO'

		FETCH NEXT FROM Rebuilds INTO @CurrDB, @CMD, @StatusMsg
		
		IF @@FETCH_STATUS <> 0 OR @CurrDB <> @PrevDB
		BEGIN
			PRINT N'USE ' + QUOTENAME(@PrevDB) + N';
DECLARE @Size INT, @DB SYSNAME;
SELECT @Size = SUM(FILEPROPERTY([name], ''SpaceUsed'')) / 128.0 FROM sys.database_files WHERE type = 0;
SET @DB = DB_NAME();

RAISERROR(N''Space used for data in "%s" AFTER compression: %d MB'', 0, 1, @DB, @Size) WITH NOWAIT;
GO'
		END
	END
	PRINT N'DECLARE @time VARCHAR(25) = CONVERT(varchar(25), GETDATE(), 121); RAISERROR(N''%s - Done'',0,1,@time) WITH NOWAIT;'

	CLOSE Rebuilds
	DEALLOCATE Rebuilds

	PRINT N'-----------------------------------------------------------------------'
	PRINT N'----------- Recommendation Script Ends Here  --------------------------'
	PRINT N'-----------------------------------------------------------------------'
END
ELSE IF @FeasibilityCheckOnly = 1
BEGIN
	PRINT N'-----------------------------------------------------------------------'
	PRINT N'-------- Feasibility Check Only - No Script Generated -----------------'
	PRINT N'-----------------------------------------------------------------------'
END
ELSE
BEGIN
	PRINT N'-----------------------------------------------------------------------'
	PRINT N'----------- No Candidates for Compression Found -----------------------'
	PRINT N'-----------------------------------------------------------------------'
END
Quit: