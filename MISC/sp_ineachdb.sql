EXEC dbo.sp_ineachdb @command = 
N'SELECT db_name() AS ''dbname'', COUNT(*) AS ''table_count'' FROM sys.tables;';
--==============================================================================
CREATE TABLE #Table_Counts (
    dbname SYSNAME
    ,table_count INT
    );
 
INSERT #Table_Counts
EXEC dbo.sp_ineachdb N'SELECT db_name() AS ''dbname'', COUNT(*) AS ''table_count'' FROM sys.tables;';
 
SELECT dbname
    ,table_count
FROM #Table_Counts
WHERE table_count >= 10
ORDER BY table_count DESC;
GO
DROP TABLE #Table_Counts;
--===================================================================================
EXEC sp_ineachdb
@command = N'ALTER DATABASE ? SET PAGE_VERIFY CHECKSUM WITH NO_WAIT;',
@database_list = 'StackOverflow2013, ExampleDB, AdventureWorks2019';