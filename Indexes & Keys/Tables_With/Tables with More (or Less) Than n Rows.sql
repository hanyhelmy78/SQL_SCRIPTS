DECLARE @threshold INT;
SET @threshold = 10000000;

SELECT [table] = t.name
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE EXISTS
  (
    SELECT 1 FROM sys.partitions AS p
      WHERE p.[object_id] = t.[object_id]
        AND p.index_id IN (0,1)
      GROUP BY p.[object_id]
      HAVING SUM(p.[rows]) > @threshold)
ORDER BY t.name