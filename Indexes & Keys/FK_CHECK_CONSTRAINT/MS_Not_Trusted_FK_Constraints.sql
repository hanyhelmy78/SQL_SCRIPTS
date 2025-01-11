SELECT QUOTENAME(SCHEMA_NAME(i.schema_id)) + '.' + QUOTENAME(o.name) AS TableName,
    i.name AS ConstraintName,
    'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(i.schema_id)) + '.' + QUOTENAME(o.name) + ' WITH CHECK CHECK CONSTRAINT [' + i.name + ']' AS CheckCommand
FROM  sys.check_constraints AS i
    INNER JOIN
    sys.objects AS o
    ON i.parent_object_id = o.OBJECT_ID
WHERE  i.is_not_trusted = 1
    AND i.is_not_for_replication = 0
UNION ALL
SELECT QUOTENAME(SCHEMA_NAME(i.schema_id)) + '.' + QUOTENAME(o.name) AS TableName,
    i.name AS ConstraintName,
    'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(i.schema_id)) + '.' + QUOTENAME(o.name) + ' WITH CHECK CHECK CONSTRAINT [' + i.name + ']' AS CheckCommand
FROM  sys.foreign_keys AS i
    INNER JOIN
    sys.objects AS o
    ON i.parent_object_id = o.OBJECT_ID
WHERE  i.is_not_trusted = 1
    AND i.is_not_for_replication = 0
ORDER BY TableName, ConstraintName;
GO