SELECT object_name, counter_name, cntr_value 
from sys.dm_os_performance_counters 
WHERE [object_name] LIKE '%Buffer Manager%' AND [counter_name] = 'page life expectancy'

SELECT object_name, counter_name, cntr_value 
from sys.dm_os_performance_counters 
WHERE [object_name] LIKE '%Buffer Manager%' AND [counter_name] = 'Buffer cache hit ratio'