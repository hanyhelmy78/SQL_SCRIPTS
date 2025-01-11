SELECT [table] = t.name 
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE EXISTS
  (
    SELECT 1 FROM sys.identity_columns AS i
      WHERE i.[object_id] = t.[object_id]);