--USE <DB_NAME>
SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName,
	   ind.name AS IndexName, 
	   ROUND(indexstats.avg_fragmentation_in_percent,2) avg_fragmentation_in_percent,
       indexstats.index_type_desc AS IndexType
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats INNER JOIN 
		sys.indexes ind WITH(NOLOCK)
ON  ind.object_id = indexstats.object_id
AND ind.index_id = indexstats.index_id
WHERE indexstats.avg_fragmentation_in_percent >= 20
ORDER BY indexstats.avg_fragmentation_in_percent DESC
OPTION (MaxDop 8);

-- Greater than 70% -->> REBUILD & between 30% & 70% -->> REORG

-- ALTER INDEX PK_CDA_DEFINITIONS ON CDA_DEFINITIONS REBUILD;