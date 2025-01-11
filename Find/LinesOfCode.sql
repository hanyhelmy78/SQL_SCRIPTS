SELECT
DB_NAME(DB_ID()) [DB_Name],
TYPE,
COUNT(*)   AS Object_Count,
SUM(LinesOfCode) AS LinesOfCode
FROM (
SELECT
 TYPE,
LEN(definition)- LEN(REPLACE(definition,CHAR(10),'')) AS LinesOfCode,
OBJECT_NAME(OBJECT_ID) AS  NameOfObject
FROM sys.all_sql_modules a
JOIN sysobjects  s
ON a.OBJECT_ID = s.id
-- AND xtype IN('TR', 'P', 'FN', 'IF', 'TF', 'V')
WHERE OBJECTPROPERTY(OBJECT_ID,'IsMSShipped') = 0
) SubQuery
GROUP BY TYPE