select 
	total_physical_memory_kb / 1024 as phys_mem_mb,
	available_physical_memory_kb / 1024 as avail_phys_mem_mb,
	system_cache_kb /1024 as sys_cache_mb,
	(kernel_paged_pool_kb+kernel_nonpaged_pool_kb) / 1024 
		as kernel_pool_mb,
	total_page_file_kb / 1024 as total_page_file_mb,
	available_page_file_kb / 1024 as available_page_file_mb,
	system_memory_state_desc
from sys.dm_os_sys_memory