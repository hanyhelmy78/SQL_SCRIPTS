--- YOU MUST EXECUTE THE FOLLOWING SCRIPT IN SQLCMD MODE.
:Connect HISND2

ALTER AVAILABILITY GROUP [SQLGRP] FAILOVER;
GO
GO
--=============================================================
ALTER DATABASE <dbname> SET HADR SUSPEND;

ALTER DATABASE <dbname> SET HADR OFF;
GO

select database_id, synchronization_state_desc, database_state_desc from sys.dm_hadr_database_replica_states
