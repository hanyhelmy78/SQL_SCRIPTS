-- =============================================
-- Author:    Mustafa EL-masry
-- Create date: 01/03/2015
-- Updated : 10/03/2015 
-- new Update :To cover all the databases in one single click ,  Select the int or Bigint Columns for Clsuter index
-- Description: Create Clustered index on All heap tables
-- =============================================
USE msdb
GO
CREATE Proc Check_Heap_Tables
AS
begin
	SET NOCOUNT ON
DECLARE @Databasename VARCHAR(200)
-- database name  
DECLARE db_cursor_1 CURSOR
FOR
    SELECT  name
    FROM    sys.databases
    WHERE   database_id > 4
            AND name <> 'distribution'
            AND state_desc = 'ONLINE'
OPEN db_cursor_1  
FETCH NEXT FROM db_cursor_1 INTO @Databasename   

WHILE @@FETCH_STATUS = 0
    BEGIN   
        PRINT ' SET NOCOUNT ON
		GO'
        DECLARE @sql NVARCHAR(MAX)= 'USE ' + QUOTENAME(@Databasename)
            + '; 
CREATE TABLE #Table_Policy (ID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,DatabaseName Nvarchar(200),Table_Name NVARCHAR(100),Rows_Count INT,Is_Heap INT,Is_Clustered INT,num_Of_nonClustered INT );
WITH cte AS(SELECT   table_name = o.name ,o.[object_id] ,i.index_id ,i.type ,i.type_desc FROM sys.indexes i INNER JOIN sys.objects o ON i.[object_id] = o.[object_id] WHERE    o.type IN ( ''U'' )AND o.is_ms_shipped = 0 AND i.is_disabled = 0 AND i.is_hypothetical = 0 AND i.type <= 2 ),
cte2 AS(SELECT * FROM cte c PIVOT(COUNT(type) FOR type_desc IN ( [HEAP], [CLUSTERED], [NONCLUSTERED]))pv)INSERT INTO #Table_Policy(DatabaseName,Table_Name,Rows_Count,Is_Heap , Is_Clustered ,num_Of_nonClustered)
SELECT  '''+@Databasename+''',c2.table_name ,[rows] = MAX(p.rows) ,is_heap = SUM([HEAP]) ,is_clustered = SUM([CLUSTERED]) ,num_of_nonclustered = SUM([NONCLUSTERED])FROM cte2 c2 INNER JOIN sys.partitions p ON c2.[object_id] = p.[object_id]
AND c2.index_id = p.index_id GROUP BY table_name  --DMV
SELECT  * FROM    #Table_Policy WHERE   Rows_Count >= 100000000
print ''USE ' + QUOTENAME(@Databasename)
            + ';''  
DECLARE @name NVARCHAR(100)
DECLARE db_cursor CURSOR
FOR
    SELECT  Table_Name  FROM    #Table_Policy    WHERE   num_Of_nonClustered = 0
            AND Is_Heap = 1
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO  @name
WHILE @@FETCH_STATUS = 0
    BEGIN   
        DECLARE @name2 NVARCHAR(100)
        DECLARE db_cursor2 CURSOR
        FOR
            WITH    CTE
                      AS ( SELECT TOP 1 COLUMN_NAME
                           FROM INFORMATION_SCHEMA.COLUMNS
                           WHERE TABLE_NAME = @name AND DATA_TYPE IN ( ''int'' )
                           UNION
                           SELECT TOP 1 COLUMN_NAME
                           FROM INFORMATION_SCHEMA.COLUMNS
                           WHERE TABLE_NAME = @name AND DATA_TYPE IN ( ''bigint'' )
                           UNION
                           SELECT TOP 1 COLUMN_NAME
                           FROM INFORMATION_SCHEMA.COLUMNS
                           WHERE TABLE_NAME = @name AND DATA_TYPE IN ( ''NVARCHAR'' )
                           UNION
                           SELECT TOP 1 COLUMN_NAME FROM     INFORMATION_SCHEMA.COLUMNS
                           WHERE TABLE_NAME = @name
                                    AND DATA_TYPE IN ( ''Varchar'' )
                           UNION
                           SELECT TOP 1
                                    COLUMN_NAME
                           FROM     INFORMATION_SCHEMA.COLUMNS
                           WHERE    TABLE_NAME = @name
                                    AND DATA_TYPE IN ( ''Char'' )
                         )
            SELECT TOP 1
                    COLUMN_NAME
            FROM    CTE
        OPEN db_cursor2   
        FETCH NEXT FROM db_cursor2 INTO @name2
        WHILE @@FETCH_STATUS = 0
            BEGIN
                DECLARE @SQL2 NVARCHAR(MAX)= N''Create Clustered index [indx_''
                    + @name + ''] on ['' + @name + '']
                           ('' + @name2
                    + '' ASC) with (Fillfactor=80,Data_Compression=page)
                           GO''
                 PRINT @SQL2
                FETCH NEXT FROM db_cursor2 INTO @name2   
            END    
        CLOSE db_cursor2   
        DEALLOCATE db_cursor2
        FETCH NEXT FROM db_cursor INTO @name   
    END    
CLOSE db_cursor   
DEALLOCATE db_cursor
GO
DROP TABLE #Table_Policy
go'
        PRINT @sql
        FETCH NEXT FROM db_cursor_1 INTO @Databasename   
    END 
CLOSE db_cursor_1  
DEALLOCATE     db_cursor_1 
END