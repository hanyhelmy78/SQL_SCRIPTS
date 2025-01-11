SELECT COUNT(DISTINCT memory_node_id) AS NUMA_Nodes FROM sys.dm_os_memory_clerks WHERE memory_node_id !=64

-- If the machine is NUMA, then cap the MAXDOP setting at the number of CPUs per NUMA node, or 8 whichever is less.
-- https://support.microsoft.com/en-us/help/2806535/recommendations-and-guidelines-for-the-max-degree-of-parallelism-confi