﻿-- THIS WILL GET THE OLDEST ACTIVE TRANSACTION WHICH PREVENTS THE TRUNCATION OF THE LOG FILE
DBCC OPENTRAN('<DB_NAME>')
DBCC OPENTRAN('tempdb')
-- kill 172

SELECT spid,lastwaittype,cpu,physical_io,login_time,last_batch,status,hostname,program_name,cmd,nt_domain,nt_username,loginame
FROM sys.sysprocesses 
WHERE open_tran = 1 
--and loginame like '%SEIB%' 
ORDER BY login_time
