SELECT OBJECT_NAME(OBJECT_ID) AS OBJECT_NAME, page_latch_wait_count, page_latch_wait_in_ms
FROM sys.dm_db_index_operational_stats(db_id(),NULL,NULL,NULL)
WHERE page_latch_wait_count > 0
ORDER BY page_latch_wait_in_ms DESC
GO