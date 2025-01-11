SELECT object_name(i.object_id) TABLE_NAME, i.name INDEX_NAME, s.user_updates, s.user_seeks, s.user_scans, s.user_lookups 
from sys.indexes i left join sys.dm_db_index_usage_stats s on s.object_id = i.object_id and i.index_id = s.index_id 
and s.database_id = 5 -- select * from sys.databases
where objectproperty(i.object_id, 'IsIndexable') = 1 and s.index_id is null or (s.user_updates > 0 and s.user_seeks = 0 and s.user_scans = 0 and s.user_lookups = 0) order by object_name(i.object_id)