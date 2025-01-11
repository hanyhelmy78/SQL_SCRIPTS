select * from sys.dm_exec_requests WHERE session_id > 50 order by wait_time desc --or 

select * from sys.dm_os_waiting_tasks WHERE session_id > 50 order by wait_duration_ms desc

SELECT * FROM sys.sysprocesses where loginame != 'sa' order by waittime desc
--WHERE lastwaittype like 'PAGE%LATCH_%' AND waitresource like '2:%'

-- LOCK 4 LATCH Wait_Type, you observe that these requests or tasks are waiting for tempdb resources. You will notice that the wait type and wait resource point to LATCH waits on pages in tempdb. 
-- These pages might be of the format 2:1:1, 2:1:3, etc.