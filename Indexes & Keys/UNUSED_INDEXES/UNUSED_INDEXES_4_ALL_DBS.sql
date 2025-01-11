--USE DBA
Go
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[UnusedIndex]
AS
    BEGIN
        SET NOCOUNT ON

        DECLARE @name NVARCHAR(200)
        DECLARE db_cursor CURSOR
        FOR
            SELECT  name
            FROM    master.dbo.sysdatabases
            WHERE   name NOT IN ( 'master', 'model', 'msdb', 'tempdb' )  
		DECLARE @Name2 NVARCHAR(200)= QUOTENAME(@name)
        OPEN db_cursor   
        FETCH NEXT FROM db_cursor INTO @Name2   
    
        WHILE @@FETCH_STATUS = 0
            BEGIN   
                DECLARE @SQL NVARCHAR(MAX)= N'
Use ' + @Name2 + '  
SELECT ''' + @Name2
                    + ''' As Database_name,
o.name AS ObjectName
, i.name AS IndexName
,((a.used_pages*8)/1024)/1024 AS Indexsize_GB
, dm_ius.user_seeks AS UserSeek
, dm_ius.user_scans AS UserScans
,dm_ius.last_user_seek
,dm_ius.last_user_scan
, dm_ius.user_lookups AS UserLookups
, dm_ius.user_updates AS UserUpdates
, p.TableRows
, ''DROP INDEX'' + QUOTENAME(i.name)
+ '' ON '' + QUOTENAME(s.name) + ''.'' + QUOTENAME(OBJECT_NAME(dm_ius.object_id)) as '' DROP STATEMENT ''
,GETDATE() AS Execution_time
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id AND dm_ius.object_id = i.object_id
INNER JOIN sys.objects o on dm_ius.object_id = o.object_id
INNER JOIN sys.schemas s on o.schema_id = s.schema_id
        JOIN sys.partitions AS PP ON PP.object_id = i.object_id
                                     AND PP.index_id = i.index_id
        JOIN sys.allocation_units AS a ON a.container_id = PP.partition_id
INNER JOIN (
SELECT SUM(p.rows) TableRows, p.index_id, p.object_id
 FROM sys.partitions p GROUP BY p.index_id, p.object_id
 ) p
 ON p.index_id = dm_ius.index_id AND dm_ius.object_id = p.object_id
WHERE OBJECTPROPERTY(dm_ius.object_id,''IsUserTable'') = 1
AND dm_ius.database_id = DB_ID()
AND i.type_desc = ''NONCLUSTERED''
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
AND  dm_ius.user_seeks =0
AND  dm_ius.user_scans =0
ORDER BY o.name ASC , I.name ASC '
                EXEC sp_executesql @SQL
                PRINT @SQL
                FETCH NEXT FROM db_cursor INTO @Name2   
            END   

        CLOSE db_cursor   
        DEALLOCATE db_cursor	
    END 
GO