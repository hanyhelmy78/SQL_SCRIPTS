SELECT [table] = s.name + N'.' + t.name
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE EXISTS
  (
    SELECT 1 FROM sys.foreign_keys AS fk
      INNER JOIN sys.tables AS pt -- "parent table"
      ON fk.referenced_object_id = pt.[object_id]
      INNER JOIN sys.schemas AS ps
      ON pt.[schema_id] = ps.[schema_id]
      WHERE fk.parent_object_id = t.[object_id]
      AND ps.name = N'dbo'
      AND pt.name = N'his_patient');