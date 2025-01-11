SELECT DB_NAME(ius.[database_id]) AS [Database],
OBJECT_NAME(ius.[object_id]) AS [TableName],
MAX(ius.[last_user_lookup]) AS [last_user_lookup],
MAX(ius.[last_user_scan]) AS [last_user_scan],
MAX(ius.[last_user_seek]) AS [last_user_seek],
MAX(ius.[last_user_update]) AS [last_user_update]
FROM sys.dm_db_index_usage_stats AS ius
WHERE ius.[database_id] = DB_ID()
GROUP BY ius.[database_id], ius.[object_id]
ORDER BY [last_user_update] DESC