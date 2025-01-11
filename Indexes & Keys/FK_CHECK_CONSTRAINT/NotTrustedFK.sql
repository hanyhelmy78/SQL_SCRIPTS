SELECT o.name TableName, i.name FKName
FROM sys.foreign_keys i
INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0

/* 
ALTER TABLE  WITH CHECK CHECK CONSTRAINT ;
*/