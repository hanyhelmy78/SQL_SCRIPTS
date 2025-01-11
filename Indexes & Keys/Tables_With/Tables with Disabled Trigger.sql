SELECT [table] = t.name
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE EXISTS 
  (
    SELECT 1 FROM sys.triggers AS tr
      WHERE tr.parent_id = t.[object_id]
      AND tr.is_disabled = 1);