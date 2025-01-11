SELECT db_name (a.database_id) AS [DatabaseName],
b.name AS [FileName],
a.File_ID AS [FileID],
CASE WHEN a.file_id = 2 THEN 'Log' ELSE 'Data' END AS [FileType],
a.Num_of_Reads AS [NumReads],
a.num_of_bytes_read AS [NumBytesRead],
a.io_stall_read_ms AS [IOStallReadsMS],
a.num_of_writes AS [NumWrites],
a.num_of_bytes_written AS [NumBytesWritten],
a.io_stall_write_ms AS [IOStallWritesMS],
a.io_stall [TotalIOStallMS],
DATEADD (ms, -a.sample_ms, GETDATE ()) [LastReset],
( (a.size_on_disk_bytes / 1024) / 1024.0) AS [SizeOnDiskMB],
UPPER (LEFT (b.physical_name, 2)) AS [DiskLocation]
FROM sys.dm_io_virtual_file_stats (NULL, NULL) a
JOIN sys.master_files b
ON a.file_id = b.file_id AND a.database_id = b.database_id
ORDER BY a.io_stall DESC;