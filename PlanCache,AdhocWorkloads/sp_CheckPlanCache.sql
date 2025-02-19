/*============================================================================
  File:     sp_CheckPlanCache

Summary: This procedure looks at cache and totals the single-use plans to report the percentage of memory consumed (and therefore wasted) from single-use plans.
			
  Date:     April 2010

  Version:	2008.
------------------------------------------------------------------------------
  Written by Kimberly L. Tripp, SQLskills.com

  For more scripts and sample code, check out http://www.SQLskills.com

  This script is intended only as a supplement to demos and lectures given by SQLskills instructors.  
  
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
============================================================================*/
USE master
go

if OBJECTPROPERTY(OBJECT_ID('sp_CheckPlanCache'), 'IsProcedure') = 1
	DROP PROCEDURE sp_CheckPlanCache
go

CREATE PROCEDURE sp_CheckPlanCache
	(@Percent	decimal(6,3) OUTPUT,
	 @WastedMB	decimal(19,3) OUTPUT)
AS
SET NOCOUNT ON

DECLARE @ConfiguredMemory	decimal(19,3)
	, @PhysicalMemory		decimal(19,3)
	, @MemoryInUse			decimal(19,3)
	, @SingleUsePlanCount	bigint

CREATE TABLE #ConfigurationOptions
(
	[name]				nvarchar(35)
	, [minimum]			int
	, [maximum]			int
	, [config_value]	int				-- in bytes
	, [run_value]		int				-- in bytes
);
INSERT #ConfigurationOptions EXEC ('sp_configure ''max server memory''');

SELECT @ConfiguredMemory = run_value/1024/1024 
FROM #ConfigurationOptions 
WHERE name = 'max server memory (MB)'

SELECT @PhysicalMemory = total_physical_memory_kb/1024 
FROM sys.dm_os_sys_memory

SELECT @MemoryInUse = physical_memory_in_use_kb/1024 
FROM sys.dm_os_process_memory

-- REMOVED THE PREPARED PART OF THE SP AS: "Using Prepared Parameterized statements/queries not only improves plan reuse and compilation overhead, but it also reduces the SQL Injection attack risk involved with Passing Parameters 
SELECT @WastedMB = sum(cast((CASE WHEN USECOUNTS = 1 AND objtype IN ('Adhoc')--, 'Prepared') 
								THEN size_in_bytes ELSE 0 END) AS DECIMAL(12,2)))/1024/1024 
	, @SingleUsePlanCount = sum(CASE WHEN usecounts = 1 AND objtype IN ('Adhoc')--, 'Prepared') 
								THEN 1 ELSE 0 END)
	, @Percent = @WastedMB/@MemoryInUse * 100
FROM sys.dm_exec_cached_plans

SELECT	[TotalPhysicalMemory (MB)] = @PhysicalMemory
	, [TotalConfiguredMemory (MB)] = @ConfiguredMemory
	, [MaxMemoryAvailableToSQLServer (%)] = @ConfiguredMemory/@PhysicalMemory * 100
	, [MemoryInUseBySQLServer (MB)] = @MemoryInUse
	, [TotalSingleUsePlanCache (MB)] = @WastedMB
	, TotalNumberOfSingleUsePlans = @SingleUsePlanCount
	, [PercentOfConfiguredCacheWastedForSingleUsePlans (%)] = @Percent
GO

EXEC sys.sp_MS_marksystemobject 'sp_CheckPlanCache'
GO
----------------------------------------------------------------------
-- Logic (in a job?) to decide whether or not to clear - using the SP.
----------------------------------------------------------------------
--DECLARE @Percent		decimal(6, 3)
--	  , @WastedMB		decimal(19,3)
--	  , @StrMB		nvarchar(20)
--	  , @StrPercent	nvarchar(20)
--EXEC sp_CheckPlanCache @Percent output, @WastedMB output

--SELECT @StrMB = CONVERT(nvarchar(20), @WastedMB)
--		, @StrPercent = CONVERT(nvarchar(20), @Percent)

--IF @Percent > 10 OR @WastedMB > 100
--	BEGIN
--		DBCC FREESYSTEMCACHE('SQL Plans') -- THIS COMMAND IS USED 2 MANUALLY REMOVE UNUSED ENTRIES FROM THE SPECIFIC CACHE SQLPLANS (4 ADHOC QUERIES).
--		RAISERROR ('%s MB (%s percent) was allocated to single-use plan cache. Single-use plans have been cleared.', 10, 1, @StrMB, @StrPercent)
--	END
--ELSE
--	BEGIN
--		RAISERROR ('Only %s MB (%s percent) is allocated to single-use plan cache - No Need To Clear Cache Now.', 10, 1, @StrMB, @StrPercent)
--			-- Note: this is only a warning message and not an actual error.
--	END
--GO