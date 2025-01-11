SELECT OBJECT_NAME(object_id) AS table_name, forwarded_record_count, avg_fragmentation_in_percent, page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID('trx_details'), DEFAULT, DEFAULT, 'DETAILED');

ALTER TABLE trx_details REBUILD--, ONLINE = ON;