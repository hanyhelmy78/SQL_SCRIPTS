﻿-- 
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_id=N'4c681c4c-6658-4fd6-867f-f438af594ed1', 
		@enabled=1
GO
EXEC msdb.dbo.sp_update_job @job_id=N'e5ff8dfc-951b-4d9c-9adf-7d91b2577067', 
		@enabled=1
GO
--===============================================================================
-- 
EXEC msdb.dbo.sp_update_job @job_id=N'f178f5f9-14e4-4dfc-a408-fb4ba96df93a', 
		@enabled=1
GO
