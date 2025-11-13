--On the primary replica of the AG and DAG
--Alter DAG to SYNC the remote ag (forwarder)
--ALTER AVAILABILITY GROUP DAG_Test MODIFY AVAILABILITY GROUP ON 'AG2' WITH (AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT);

--Verification
SELECT drs.synchronization_state, drs.synchronization_state_desc, drs.synchronization_health, drs.synchronization_health_desc, drs.is_commit_participant
FROM sys.availability_groups ag
JOIN sys.dm_hadr_database_replica_states drs ON ag.group_id = drs.group_id
WHERE ag.is_distributed = 1
and ag.name = 'DAG_Test';

--Verification script flag: Yes or Not yet
SELECT case when 
(count(*) * 4) = (sum(drs.synchronization_state + drs.synchronization_health + cast(drs.is_suspended as int)))
and
count(*) = sum(cast(drs.is_commit_participant as int))
then 'Yes' else 'Not yet' end Dag_ready_to_failover
FROM sys.availability_groups ag
JOIN sys.dm_hadr_database_replica_states drs ON ag.group_id = drs.group_id
WHERE ag.is_distributed = 1
and ag.name = 'DAG_Test';
