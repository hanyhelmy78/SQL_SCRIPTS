SELECT [table] = t.name 
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE NOT EXISTS
  (
    SELECT 1 FROM sys.key_constraints AS k
      WHERE k.[type] = N'PK'
      AND k.parent_object_id = t.[object_id])
ORDER BY t.name;