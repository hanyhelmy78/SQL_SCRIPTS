-- query to allocate the space usage for each index
SELECT OBJECT_NAME(i.OBJECT_ID) AS TableName,
 i.name AS IndexName,
 i.index_id AS IndexID,
 (8 * SUM(a.used_pages)/1024) AS 'Index_size(MB)'
 FROM sys.indexes AS i
 JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
 JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
 where i.object_id = object_id('HIS_InvoiceDetail')
 GROUP BY i.OBJECT_ID,i.index_id,i.name
 ORDER BY (8 * SUM(a.used_pages)/1024) desc
 
-- query to allocate the total index size per table
exec sp_spaceused 'HIS_InvoiceDetail'
  
select * from sys.allocation_units order by used_pages desc