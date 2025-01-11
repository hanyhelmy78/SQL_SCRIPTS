/* sys.dm_io_pending_io_requests : It is important to recognize that these are current active waits that are I/O related. */
SELECT f.database_id, f.[file_id], DB_NAME(f.database_id) AS database_name, f.name AS logical_file_name, f.type_desc,
CAST (CASE
-- Handle UNC paths (e.g. '\\fileserver\DBs\readonly_dw.ndf')
WHEN LEFT (LTRIM (f.physical_name), 2) = '\\'
THEN LEFT (LTRIM (f.physical_name),CHARINDEX('\',LTRIM(f.physical_name),CHARINDEX('\',LTRIM(f.physical_name), 3) + 1) - 1)
-- Handle local paths (e.g. 'C:\Program Files\...\master.mdf')
WHEN CHARINDEX('\', LTRIM(f.physical_name), 3) > 0
THEN UPPER(LEFT(LTRIM(f.physical_name), CHARINDEX ('\', LTRIM(f.physical_name), 3) - 1))
ELSE f.physical_name
END AS NVARCHAR(255)) AS logical_disk,
fs.io_stall/1000/60 AS io_stall_min,
fs.io_stall_read_ms/1000/60 AS io_stall_read_min,
fs.io_stall_write_ms/1000/60 AS io_stall_write_min,
 (fs.io_stall_read_ms / (1.0 + fs.num_of_reads)) AS avg_read_latency_ms,
 (fs.io_stall_write_ms / (1.0 + fs.num_of_writes)) AS avg_write_latency_ms,
 ((fs.io_stall_read_ms/1000/60)*100)/(CASE WHEN fs.io_stall/1000/60 = 0 THEN 1 ELSE fs.io_stall/1000/60 END) AS io_stall_read_pct,
 ((fs.io_stall_write_ms/1000/60)*100)/(CASE WHEN fs.io_stall/1000/60 = 0 THEN 1 ELSE fs.io_stall/1000/60 END) AS io_stall_write_pct,
ABS((fs.sample_ms/1000)/60/60) AS 'sample_HH',
 ((fs.io_stall/1000/60)*100)/(ABS((fs.sample_ms/1000)/60))AS 'io_stall_pct_of_overall_sample',
PIO.io_pending_ms_ticks,
PIO.scheduler_address
FROM sys.dm_io_pending_io_requests AS PIO
INNER JOIN sys.dm_io_virtual_file_stats (NULL,NULL) AS fs
ON fs.file_handle = PIO.io_handle
INNER JOIN sys.master_files AS f
ON fs.database_id = f.database_id AND fs.[file_id] = f.[file_id]