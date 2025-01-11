;With cte_IndexesOnFKs AS(
  SELECT fkc.parent_object_id 'object_id',ic.index_id
  FROM sys.foreign_key_columns (NOLOCK) AS fkc
  JOIN sys.index_columns (NOLOCK) AS ic 
    ON fkc.parent_object_id=ic.object_id AND fkc.parent_column_id=ic.column_id
  WHERE fkc.constraint_column_id=1 AND ic.key_ordinal=1 AND ic.index_id>1
)
, cte_InterestingIndexes AS(
SELECT object_id,index_id,i.name FROM sys.indexes (NOLOCK) i
WHERE i.type=2
  AND i.is_disabled = 0
  AND i.is_hypothetical = 0
  AND i.is_primary_key=0
  AND i.is_unique_constraint=0
  AND i.is_unique=0
EXCEPT SELECT iofk.object_id,iofk.index_id,ind.name FROM cte_IndexesOnFKs AS iofk JOIN sys.indexes (NOLOCK) ind ON iofk.object_id = ind.object_id AND iofk.index_id = ind.index_id
),cte_InterestingIndexes2 AS (
  SELECT SCHEMA_NAME(o.schema_id) schema_name, o.schema_id, 
    OBJECT_NAME(i.object_id) object_name, i.object_id, 
    i.name index_name, i.index_id, 
    (SUM(au.used_pages)*8) index_size_kb
  FROM cte_InterestingIndexes i (NOLOCK)
    JOIN sys.objects o (NOLOCK) ON i.object_id = o.object_id
    JOIN sys.schemas s (NOLOCK) ON o.schema_id = s.schema_id
    JOIN sys.partitions p (NOLOCK) ON i.object_id = p.object_id AND i.index_id = p.index_id
    JOIN sys.allocation_units au (NOLOCK) ON p.partition_id = au.container_id
  WHERE o.type = 'U'
  GROUP BY o.schema_id, i.object_id, i.index_id, i.name
  HAVING (SUM(au.used_pages)*8) > 102400 
)
,cte_IndexUsage AS (
  SELECT ii.schema_name, ii.schema_id, ii.object_name, ii.object_id, ii.index_name, ii.index_id, ii.index_size_kb,
    ISNULL(ius.user_scans,0)+ISNULL(ius.user_seeks,0)+ISNULL(ius.user_lookups,0) index_usage,
    ISNULL(ius.user_updates,0) index_updates,
    CASE WHEN ISNULL(ius.user_updates,1)=0 THEN 1 ELSE ISNULL(ius.user_updates,1) END index_updates_for_sorting,
    last_index_usage_date = 
      CASE WHEN ISNULL(last_user_seek, CONVERT(DATETIME, '19000101')) > ISNULL(last_user_scan, CONVERT(DATETIME, '19000101')) 
        AND ISNULL(last_user_seek, CONVERT(DATETIME, '19000101')) > ISNULL(last_user_lookup, '19000101') then last_user_seek
      WHEN ISNULL(last_user_scan, CONVERT(DATETIME, '19000101')) > ISNULL(last_user_seek, CONVERT(DATETIME, '19000101')) 
        AND ISNULL(last_user_scan, CONVERT(DATETIME, '19000101')) > ISNULL(last_user_lookup, '19000101') then last_user_scan
      WHEN ISNULL(last_user_lookup, CONVERT(DATETIME, '19000101')) > ISNULL(last_user_seek, CONVERT(DATETIME, '19000101')) 
        AND ISNULL(last_user_lookup, CONVERT(DATETIME, '19000101')) > ISNULL(last_user_scan, '19000101') then last_user_lookup END
  FROM cte_InterestingIndexes2 ii (NOLOCK)
  LEFT JOIN sys.dm_db_index_usage_stats (NOLOCK) ius ON ii.object_id = ius.object_id AND ii.index_id = ius.index_id
  WHERE ISNULL(ius.user_scans,0)+ISNULL(ius.user_seeks,0)+ISNULL(ius.user_lookups,0) < 10
    AND ISNULL(ius.user_updates, 0) > 0
)
SELECT @@SERVERNAME AS instance_name,
  DB_NAME() database_name,
  schema_name,
  object_name,
  index_name, 
  index_size_kb,
  index_usage,
  index_updates,
  ISNULL(last_index_usage_date, CONVERT(DATETIME, '19000101')) last_index_usage_date
FROM cte_IndexUsage iu
ORDER BY index_updates_for_sorting*index_size_kb DESC