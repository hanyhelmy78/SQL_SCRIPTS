SELECT
DB_NAME(DB_ID()) [DB_Name],
CASE WHEN TYPE = 'C' THEN 'Check Constraint'
	 WHEN TYPE = 'D' THEN 'Default'
	 WHEN TYPE = 'FN' THEN 'Function' 
	 WHEN TYPE = 'IF' THEN 'Table-valued Function' 
	 WHEN TYPE = 'IT' THEN 'Internal table' 
	 WHEN TYPE = 'K' THEN 'Primary Key'
	 WHEN TYPE = 'P' THEN 'Stored Procedure' 
	 WHEN TYPE = 'PC' THEN 'Assembly (CLR) stored-procedure' 
	 WHEN TYPE = 'S' THEN 'System base table'
	 WHEN TYPE = 'SQ' THEN 'Sequence' 
	 WHEN TYPE = 'TR' THEN 'DML trigger' 
	 WHEN TYPE = 'U' THEN 'User Table'
	 WHEN TYPE = 'V' THEN 'View' END AS TYPE,
COUNT(*) AS Object_Count,
SUM(LinesOfCode) AS LinesOfCode
FROM (
SELECT
TYPE,
LEN(definition)- LEN(REPLACE(definition,CHAR(10),'')) AS LinesOfCode,
OBJECT_NAME(OBJECT_ID) AS NameOfObject
FROM sys.all_sql_modules a
JOIN sysobjects s
ON a.OBJECT_ID = s.id
WHERE OBJECTPROPERTY(OBJECT_ID,'IsMSShipped') = 0
) SubQuery
GROUP BY TYPE