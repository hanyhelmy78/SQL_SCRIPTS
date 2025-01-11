SELECT cntr_value
FROM sys.dm_os_performance_counters
WHERE
object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Page life expectancy'

SELECT *
FROM sys.dm_os_performance_counters