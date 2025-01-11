/* Find Collation of SQL Server Database */
SELECT DATABASEPROPERTYEX('SSISDB', 'Collation')
GO
/* Find Collation of SQL Server Database Table Column */
USE SSISDB
GO
SELECT name 'Column Name', collation_name,*
FROM sys.columns
WHERE OBJECT_ID IN (SELECT OBJECT_ID
FROM sys.objects
WHERE type = 'U'
AND collation_name IS NOT NULL
)