DECLARE @threshold INT;
SET @threshold = 50;

;WITH c([object_id], [column count]) AS
(
  SELECT [object_id], COUNT(*)
    FROM sys.columns
    GROUP BY [object_id]
    HAVING COUNT(*) > @threshold
)
SELECT t.name,
    c.[column count]
  FROM c
  INNER JOIN sys.tables AS t
  ON c.[object_id] = t.[object_id]
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  ORDER BY c.[column count] DESC;