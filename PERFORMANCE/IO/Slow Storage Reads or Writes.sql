-- Reads
SELECT mf.Name
 FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
 INNER JOIN sys.master_files AS mf ON fs.database_id = mf.database_id
 AND fs.[file_id] = mf.[file_id]
 WHERE ( io_stall_read_ms / ( 1.0 + num_of_reads ) ) > 200 ;
 
 -- Writes
 SELECT mf.Name
 FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
 INNER JOIN sys.master_files AS mf ON fs.database_id = mf.database_id
 AND fs.[file_id] = mf.[file_id]
 WHERE ( io_stall_write_ms / ( 1.0 + num_of_writes ) ) > 100 ;