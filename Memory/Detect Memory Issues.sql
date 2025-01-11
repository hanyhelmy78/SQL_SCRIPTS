USE master
GO
/* Query 1: If the result says Available physical memory is high. This is good for the system and nothing to worry about.*/
SELECT total_physical_memory_kb/1024 [Total Physical Memory in MB],
available_physical_memory_kb/1024 [Physical Memory Available in MB],
system_memory_state_desc
FROM sys.dm_os_sys_memory;

/* Query 2: indicates if there is a memory low issue or not, if both the values are zero that is a good thing. If any of the LOW values is 1, it is a matter of concern and one should start investigating the memory issue.*/ 

SELECT physical_memory_in_use_kb/1024 [Physical Memory Used in MB],
process_physical_memory_low [Physical Memory Low],
process_virtual_memory_low [Virtual Memory Low]
FROM sys.dm_os_process_memory;

/* Query 3: if the target committed memory is less than total memory in 1st query, we are good */

SELECT committed_kb/1024 [SQL Server Committed Memory in MB],
committed_target_kb/1024 [SQL Server Target Committed Memory in MB]
FROM sys.dm_os_sys_info;