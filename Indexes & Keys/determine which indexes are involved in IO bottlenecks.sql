-- trying to determine which indexes are involved in I/O bottlenecks.

select object_name(object_id) as 'ObjectName', page_io_latch_wait_in_ms, index_id
from sys.dm_db_index_operational_stats (db_id(),null,null,null) 
order by page_io_latch_wait_in_ms desc --page_lock_wait_in_ms, row_lock_wait_in_ms