DECLARE @dbid int
SELECT @dbid = db_id('hisgenx')

SELECT db_Name(database_id) DatabaseName,
	   cast(getdate() as Date) as Date,
       TableName = object_name(s.object_id),
       Reads = SUM(user_seeks + user_scans + user_lookups), 
	   Writes =  SUM(user_updates)

FROM sys.dm_db_index_usage_stats AS s
INNER JOIN sys.indexes AS i
ON s.object_id = i.object_id
AND s.index_id = i.index_id
WHERE objectproperty(s.object_id,'IsUserTable') = 1
  and object_name(s.object_id) is not null
AND s.database_id = @dbid
GROUP BY object_name(s.object_id), database_id
ORDER BY db_Name(database_id)--, writes DESC