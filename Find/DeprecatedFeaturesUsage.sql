SELECT OBJECT_NAME,
counter_name,
instance_name AS 'Deprecated Feature',
cntr_value AS 'Number of Times Used'
FROM sys.dm_os_performance_counters
WHERE OBJECT_NAME LIKE '%:Deprecated%'
AND cntr_value > 0
ORDER BY 'Number of Times Used' DESC
GO