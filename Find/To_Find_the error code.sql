SELECT dateadd (ms, (a.[Record Time] - sys.ms_ticks), GETDATE()) as [Notification_Time], a.* FROM 
(SELECT 
x.value('(//Record/@id)[1]', 'bigint') AS [Record_ID], 
x.value('(//Record/Error/ErrorCode)[1]', 'varchar(30)') AS [ErrorCode], 
x.value('(//Record/Error/APIName)[1]', 'varchar(255)') AS [APIName], 
x.value('(//Record/Error/CallingAPIName)[1]', 'varchar(255)') AS [CallingAPIName], 
x.value('(//Record/Error/SPID)[1]', 'int') AS [SPID], 
x.value('(//Record/@time)[1]', 'bigint') AS [Record Time] 
FROM (SELECT CAST (record as xml) FROM sys.dm_os_ring_buffers 
WHERE ring_buffer_type = 'RING_BUFFER_SECURITY_ERROR') AS R(x)) a 
CROSS JOIN sys.dm_os_sys_info sys 
ORDER BY a.[Record_ID] DESC