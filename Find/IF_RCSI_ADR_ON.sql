SELECT name
, is_read_committed_snapshot_on
, is_accelerated_database_recovery_on
FROM  sys.databases
WHERE name = db_name();