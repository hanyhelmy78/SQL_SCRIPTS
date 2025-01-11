SELECT [table] = t.name
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE EXISTS
  (
    SELECT 1 FROM sys.columns AS c
      WHERE c.[object_id] = t.[object_id]
      AND c.system_type_id = 241); -- 241 = xml
 