-- ENABLED TRACES
DBCC TRACESTATUS(-1)

-- THIS IS to turn off successful BKP logging
DBCC TRACEON (3226,-1)
DBCC TRACEOFF(3226,-1)

/* Limits the amount of information returned to users who aren't members of the sysadmin fixed server role, by masking the parameters of some error messages using '***'. This can help prevent disclosure of sensitive information.
This trace flag can only be specified during server startup */
DBCC TRACEON (3625,-1)
DBCC TRACEOFF(3625,-1)

-- THIS IS 2 Enable the replication log reader AGENT to move forward even if the async secondaries IS NOT SYNCHING 
DBCC TRACEON (1448,-1);
DBCC TRACEOFF(1448,-1);

-- SQL SERVER will partition memory if CMEMTHREAD contention is detected. Turning on TF 8048 forces the memory partitioning across the numa nodes without having to hit the internal thresholds

DBCC TRACEON (8048,-1);
DBCC TRACEOFF(8048,-1);

-- All files in the filegroup grow by the same amount, Starting with SQL Server 2016 this trace flag 1117 has no effect.
DBCC TRACEON (1117,-1);
DBCC TRACEOFF(1117,-1);

-- Recommended to reduce resource allocation contention in SQL Server tempdb database that is experiencing heavy usage, Starting with SQL Server 2016 this trace flag has no effect.
DBCC TRACEON (1118,-1);
DBCC TRACEOFF(1118,-1);