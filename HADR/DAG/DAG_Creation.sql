-- Against the source AG, we need to run the following, filling in the appropriate AG names and URLs

CREATE AVAILABILITY GROUP <Distributed AG Name>
WITH (DISTRIBUTED) AVAILABILITY GROUP ON <source AG name>
WITH (
        LISTENER_URL = '<source listener URL>:<source mirroring endpoint port>'
-- the port specified in the listener URL is the port number that the mirroring endpoint is listening on (5022)
        ,AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT
        ,FAILOVER_MODE = MANUAL
        ,SEEDING_MODE = AUTOMATIC)
    ,<destination AG name>
WITH (
        LISTENER_URL = '<destination listener URL>:<destination mirroring endpoint port>'
        ,AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT
        ,FAILOVER_MODE = MANUAL
        ,SEEDING_MODE = AUTOMATIC)
-- *****************************************************************************************
-- Run the following against the destination AG:

ALTER AVAILABILITY GROUP <Distributed AG Name>
JOIN AVAILABILITY GROUP ON '<source AG name>'
WITH (
        LISTENER_URL = '<source listener URL>:<source mirroring endpoint port>'
        ,AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT
        ,FAILOVER_MODE = MANUAL
        ,SEEDING_MODE = AUTOMATIC)
    ,'<destination AG name>'
WITH (
        LISTENER_URL = '<destination listener URL>:<destination mirroring endpoint port>'
        ,AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT
        ,FAILOVER_MODE = MANUAL
        ,SEEDING_MODE = AUTOMATIC)
/*
Switch the Distributed AG to Synchronous Commit:
Run the following code against both the source and the destination to switch the availability mode to synchronous.
*/
ALTER AVAILABILITY GROUP <Distributed AG Name> MODIFY AVAILABILITY GROUP ON
'<source AG>' WITH (AVAILABILITY_MODE = SYNCHRONOUS_COMMIT),
'<destination AG>' WITH (AVAILABILITY_MODE = SYNCHRONOUS_COMMIT);
/*
Check Replication is Up To Date:
Run the following on both the source and destination instances.
We want to see the synchronisation state showing as ‘SYNCHRONIZED’ and the last_hardened_lsn for each database on one server matching the value for its corresponding database on the opposite server.
*/
SELECT AGs.name, db_name(database_id) DBName, synchronization_state_desc, last_hardened_lsn
FROM sys.dm_hadr_database_replica_states replicaStates
JOIN sys.availability_groups AGs ON AGs.group_id = replicaStates.group_id
WHERE (is_distributed = 1) OR (is_primary_replica = 1)
/*
Failover the Distributed AG:
Run this on the source server.
*/
ALTER AVAILABILITY GROUP <Distributed AG Name> SET (ROLE = SECONDARY);

-- Run the following against the destination server.

ALTER AVAILABILITY GROUP <Distributed AG Name> FORCE_FAILOVER_ALLOW_DATA_LOSS;

-- Run the HC script again

SELECT AGs.name, db_name(database_id) DBName, synchronization_state_desc, last_hardened_lsn
FROM sys.dm_hadr_database_replica_states replicaStates
JOIN sys.availability_groups AGs ON AGs.group_id = replicaStates.group_id
WHERE (is_distributed = 1) OR (is_primary_replica = 1)