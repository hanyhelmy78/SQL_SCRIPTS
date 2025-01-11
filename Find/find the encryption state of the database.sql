SELECT db_name(database_id) AS 'database_name'
   ,encryption_state_desc
FROM sys.dm_database_encryption_keys
WHERE database_id = db_id()