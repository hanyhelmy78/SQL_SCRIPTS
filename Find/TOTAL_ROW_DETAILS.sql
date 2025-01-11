SELECT o.name TableName,--o.object_id,
ddps.Row_Count
FROM sys.indexes AS i
INNER JOIN sys.objects AS o ON i.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.dm_db_partition_stats AS ddps ON i.OBJECT_ID = ddps.OBJECT_ID
AND i.index_id = ddps.index_id
WHERE i.index_id < 2
--and o.name like 'C$%' --'%Report_%'
AND o.is_ms_shipped = 0 -- UNCOMMENT THIS TO IGNORE SYSTEM TABLES
--AND o.name LIKE '%$%'
ORDER BY ddps.row_count DESC