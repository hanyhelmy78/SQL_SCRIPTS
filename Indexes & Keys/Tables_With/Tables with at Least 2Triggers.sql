DECLARE @min_count INT;
SET @min_count = 2;

SELECT t.name
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE EXISTS
  (
    SELECT 1 FROM sys.triggers AS tr
      WHERE tr.parent_id = t.[object_id]
      GROUP BY tr.parent_id
      HAVING COUNT(*) >= @min_count);