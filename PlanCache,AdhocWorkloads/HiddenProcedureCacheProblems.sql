-- 4 SQL 2K8
SELECT SUM(single_pages_kb + multi_pages_kb)/1000 AS "CurrentSizeOfTokenCache(MB)"
FROM sys.dm_os_memory_clerks
WHERE [name] = 'TokenAndPermUserStore'

-- 4 SQL 2O12
SELECT SUM(page_size_in_bytes + pages_kb)/1000 AS "CurrentSizeOfTokenCache(MB)"
FROM sys.dm_os_memory_clerks
WHERE [name] = 'TokenAndPermUserStore'

--if it's under 10MB, IT`S FINE, MORE THAN 50MB; THAT MEANS THERE IS A HIDDEN CACHE PROBLEM, RESOLUTION: REDUCE ADHOC QUERIES (TURN IT TO SP`S) OR ENABLE SP_CONFIGURE 'optimize for ad hoc workloads',1