-- ENABLED TRACES

DBCC TRACESTATUS(-1)

-- THIS IS 2 Enable the replication log reader AGENT to move forward even if the async secondaries IS NOT SYNCHING 
DBCC TRACEON (1448,-1);
DBCC TRACEOFF(1448,-1);

-- Recommended to reduce resource allocation contention in SQL Server tempdb database that is experiencing heavy usage
DBCC TRACEON (1118,-1);
DBCC TRACEOFF(1118,-1);

-- THIS IS to turn off successful BKP logging
DBCC TRACEON (3226,-1)
DBCC TRACEOFF(3226,-1)