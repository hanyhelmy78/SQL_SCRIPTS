SELECT
t.name as TableName, col.name AS ColumnName, i.name AS PrimaryKey_Name
FROM 
   sys.tables t 
   INNER JOIN sys.indexes i ON t.object_id = i.object_id
   INNER JOIN sys.index_columns c ON t.object_id = c.object_id 
                                     AND i.index_id = c.index_id 
   INNER JOIN sys.columns col ON c.object_id = col.object_id 
                                     AND c.column_id = col.column_id 
WHERE 
   i.is_primary_key = 1 AND t.name IN (SELECT name from sys.tables)
ORDER BY t.name, c.key_ordinal