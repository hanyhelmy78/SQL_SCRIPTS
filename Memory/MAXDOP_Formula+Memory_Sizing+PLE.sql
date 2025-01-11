/* General Recommendation is to reserve 1 GB RAM for the OS for each 4 GB of RAM installed from 4–16 GB, and then 1 GB for every 8 GB RAM installed above 16 GB RAM

FORMULA 4 CRITICAL PLE VALUE: PLE should be 300 for every 4 GB of RAM on your server. ÇÞÓã ÇáÑÇãÇÊ Úáì 4 æÇÖÑÈ * 300

FORMULA 4 MAXDOP SETTING:
=========================
1- Server with single NUMA node --> Less than or equal to 8 logical processors --> Keep MAXDOP at the # of logical processors.
2- Server with single NUMA node	--> Greater than eight logical processors --> Keep MAXDOP at 8
3- Server with multiple NUMA nodes --> Less than or equal to 16 logical processors per NUMA node --> Keep MAXDOP at the # of logical processors per NUMA node.
4- Server with multiple NUMA nodes --> Greater than 16 logical processors per NUMA node	Keep --> MAXDOP at half the number of logical processors per NUMA node with a MAX value of 16

https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/configure-the-max-degree-of-parallelism-server-configuration-option?view=sql-server-ver16&source=docs#:~:text=DOP)%20feedback.-,Recommendations,-In%20SQL%20Server */

-- # OF LOGICAL PROCESSORS ON THE SERVER: 

EXEC sys.xp_readerrorlog 0, 1, N'detected', N'socket';

-- # OF NUMA NODES
SELECT COUNT(DISTINCT memory_node_id) AS NUMA_Nodes FROM sys.dm_os_memory_clerks WITH (NOLOCK) WHERE memory_node_id !=64

-- PLE 4 A SINGLE CPU SOCKET
SELECT  object_name,
        counter_name,
        cntr_value AS [value]
FROM    sys.dm_os_performance_counters WITH (NOLOCK)
WHERE   LTRIM(RTRIM(object_name)) = 'SQLServer:Buffer Manager'
       AND LTRIM(RTRIM(counter_name)) = 'Page life expectancy';

-- PLE 4 A MULTI NUMA NODES-CPU SOCKETS
SELECT object_name,
       counter_name,
       instance_name AS [NUMA Node] ,
       cntr_value AS [value]
FROM sys.dm_os_performance_counters WITH (NOLOCK)
WHERE LTRIM(RTRIM(counter_name)) = 'Page life expectancy'
  AND LTRIM(RTRIM(object_name)) = 'SQLServer:Buffer Node'