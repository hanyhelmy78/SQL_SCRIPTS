select * from sys.dm_exec_query_memory_grants --LOOK @ requested, granted, required, used, and ideal memory_kb coulmns

/*Common causes for this include:
1- Missing indexes causing large sort or hash operations
2- Out-of-date statistics causing incorrectly large cardinality estimates
3- Large numbers of concurrent queries running that all require memory to run, or where many of the queries have incorrectly large memory grant requirements
**FIX:
=======
1- LOOK @ THE MAX MEMORY % & MEMORY GRANT % IN RESOURCE GOVERNOR & INCREASE IT IF REQUIRED.
2- TUNE THE QUERY RETURNED BY THE ABOVE SELECT STATEMENT, GET THE QUERY FROM SESSION_ID THEN ACTIVITY MONITOR*/