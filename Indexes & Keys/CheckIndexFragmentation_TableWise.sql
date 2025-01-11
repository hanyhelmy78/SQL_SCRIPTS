DECLARE @db_id SMALLINT;
DECLARE @object_id INT;
SET @db_id = DB_ID(N'DB_NAME');
SET @object_id = OBJECT_ID(N'TABLE_NAME');
IF @object_id IS NULL 
BEGIN
   PRINT N'Invalid object';
END
ELSE
BEGIN
   SELECT IPS.Index_type_desc, 
      IPS.avg_fragmentation_in_percent, 
      IPS.avg_fragment_size_in_pages, 
      IPS.avg_page_space_used_in_percent, 
      IPS.record_count, 
      IPS.ghost_record_count,
      IPS.fragment_count, 
      IPS.avg_fragment_size_in_pages
FROM sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL , 'DETAILED') AS IPS
order by avg_fragmentation_in_percent desc
END
GO