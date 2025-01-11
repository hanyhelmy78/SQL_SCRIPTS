DECLARE @schema SYSNAME;
SET @schema = N'dbo';

SELECT [table] = t.name
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE s.name = @schema
ORDER BY t.name