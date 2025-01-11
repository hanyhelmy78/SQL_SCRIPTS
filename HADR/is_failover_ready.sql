-- ON SECONDARY NODE ***********************************************************************
Select database_name, is_failover_ready--, *
from sys.dm_hadr_database_replica_cluster_states 
where replica_id in (select replica_id from sys.dm_hadr_availability_replica_states) --and is_failover_ready = 0
ORDER BY database_name