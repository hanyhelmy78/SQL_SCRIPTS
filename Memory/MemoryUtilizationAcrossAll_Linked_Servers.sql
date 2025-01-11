/*
 Purpose: 
 Returns information about memory utilization for multiple SQL instances.
 
 Inputs: none

 History:
 07/18/2016 DMason Created
*/

CREATE TABLE #Servers (
    InstanceName SYSNAME PRIMARY KEY,
    MajorVersion INT,
    [Max SQL Server Memory (MB)] INT,
    [Host Server Memory (GB)] NUMERIC(10, 2),
    [Page Life Expectancy] INT,
    [Page Reads/sec] NUMERIC(10, 2)
)
--Populate server names from linked servers.
INSERT INTO #Servers (InstanceName)
SELECT name InstanceName
FROM master.sys.servers 
WHERE name <> @@SERVERNAME
AND product = 'SQL Server'

--Populate the major version.
DECLARE @Tsql NVARCHAR(MAX) = ''
SELECT @Tsql = @Tsql +
    'UPDATE #Servers SET 
        MajorVersion = CAST(MajorVer AS INT)
        FROM OPENQUERY([' + InstanceName + '],
            ''
    DECLARE @MajorVer SMALLINT
    SET @MajorVer = CAST(PARSENAME(CAST(SERVERPROPERTY(''''ProductVersion'''') AS VARCHAR), 4) AS SMALLINT)
    SELECT @MajorVer AS MajorVer
            '')
        WHERE InstanceName = ''' + InstanceName + ''';' + CHAR(13) + CHAR(10)
FROM #Servers

EXEC sp_executesql @Tsql

DECLARE @Instance SYSNAME
DECLARE @MajorVer INT
DECLARE curInstance CURSOR FAST_FORWARD READ_ONLY FOR
    SELECT InstanceName, MajorVersion FROM #Servers

OPEN curInstance
FETCH NEXT FROM curInstance INTO @Instance, @MajorVer

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Tsql = 
        'UPDATE #Servers SET 
            [Max SQL Server Memory (MB)] = CAST(MaxMemMB AS INT),
            [Host Server Memory (GB)] = CAST(HostServerMemory_GB AS NUMERIC(10, 2)),
            [Page Life Expectancy] = CAST(PageLifeExpectancy AS INT),
            [Page Reads/sec] = CAST(PgReadsPerSec AS NUMERIC(10, 2))
            FROM OPENQUERY([' + @Instance + '],
                ''

        DECLARE @HostServerMemory_GB NUMERIC(10, 2)
        DECLARE @Tsql NVARCHAR(MAX) = 
'

    IF @MajorVer >= 11    --SQL 2012 or higher
        SET @Tsql = @Tsql + '''''SELECT TOP(1) @Mem = CAST(ROUND(i.physical_memory_kb / 1024.0 / 1024 , 2) AS NUMERIC(10, 2))
    FROM sys.dm_os_sys_info i''''
        EXEC sp_executesql @Tsql, N''''@Mem NUMERIC(10, 2) OUTPUT'''', @HostServerMemory_GB output WITH RESULT SETS NONE'
    ELSE    --SQL 2008 R2 or less
        SET @Tsql = @Tsql + '''''SELECT TOP(1) @Mem = CAST(ROUND(physical_memory_in_bytes / 1024.0 / 1024 / 1024, 2) AS NUMERIC(10, 2))
    FROM sys.dm_os_sys_info''''
        EXEC sp_executesql @Tsql, N''''@Mem NUMERIC(10, 2) OUTPUT'''', @HostServerMemory_GB output'

SET @Tsql = @Tsql + '

--Memory, Page Life Expectancy, Page Reads/sec
SELECT c.value AS MaxMemMB, @HostServerMemory_GB HostServerMemory_GB, ple.PageLifeExpectancy,
    CAST(prs.cntr_value / 1.0 / i.SecondsSinceStartup AS NUMERIC(10, 2)) PgReadsPerSec
FROM sys.configurations c
CROSS APPLY
(
    SELECT TOP(1) 
        DATEDIFF(ss, sqlserver_start_time, CURRENT_TIMESTAMP) AS SecondsSinceStartup
    FROM sys.dm_os_sys_info
) i,
(
    SELECT object_name, counter_name, cntr_value AS PageLifeExpectancy
    FROM sys.dm_os_performance_counters
    WHERE [object_name] LIKE ''''%Buffer Manager%''''
    AND [counter_name] = ''''Page life expectancy''''
) ple,
(
    SELECT object_name, counter_name, cntr_value
    FROM sys.dm_os_performance_counters 
    WHERE [object_name] LIKE ''''%Buffer Manager%''''
    AND [counter_name] = ''''Page reads/sec''''
) prs
WHERE c.name like ''''Max_server memory%'''';

                '')
            WHERE InstanceName = ''' + @Instance + '''' + CHAR(13) + CHAR(10)
    --PRINT @Tsql
----------------------------------------------------
    BEGIN TRY
        EXEC sp_executesql @Tsql
    END TRY
    BEGIN CATCH
        PRINT @Instance
        PRINT ERROR_MESSAGE()
        PRINT CHAR(13) + CHAR(10)
    END CATCH

    FETCH NEXT FROM curInstance INTO @Instance, @MajorVer
END

CLOSE curInstance
DEALLOCATE curInstance

SELECT s.InstanceName, s.[Max SQL Server Memory (MB)], s.[Host Server Memory (GB)], 
    s.[Page Life Expectancy], s.[Page Reads/sec]
FROM #Servers s
DROP TABLE #Servers
GO