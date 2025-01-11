--Finding Unused non-clustered indexes.
SELECT  OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName ,
        OBJECT_NAME(i.object_id) AS TableName ,
        i.name ,
        ius.user_seeks ,
        ius.user_scans ,
        ius.user_lookups ,
        ius.user_updates
FROM    sys.dm_db_index_usage_stats AS ius
        JOIN sys.indexes AS i ON i.index_id = ius.index_id
                                 AND i.object_id = ius.object_id
WHERE   ius.database_id = DB_ID()
        AND i.is_unique_constraint = 0 -- no unique indexes
        AND i.is_primary_key = 0
        AND i.is_disabled = 0
        AND i.type > 1 -- don't consider heaps/clustered index
		AND ius.user_seeks = 0
		AND ius.user_scans = 0
        --AND ((ius.user_seeks + ius.user_scans + ius.user_lookups) < ius.user_updates
        --      OR (ius.user_seeks = 0
        --      AND ius.user_scans = 0))
order by user_updates

-- to find the Leftover Fake Indexes From Tuning Wizards
SELECT * FROM sys.indexes WHERE is_hypothetical = 1
--drop index _dta_index_HIS_Patient_5_2105214700__K2 on HIS_Patient