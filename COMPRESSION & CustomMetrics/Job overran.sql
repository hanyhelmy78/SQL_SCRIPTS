-- Code to examine if a job has overrun to a specific time  
use msdb
go
DECLARE @todaysdate DATETIME, @job_name NVARCHAR(50),  
		@expected_start_hour INT, @expected_start_minute INT,  
		@expected_finish_hour INT, @expected_finish_minute INT 

SELECT @todaysdate = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())),  

-- FILL IN DETAILS SPECIFIC TO YOUR JOB  
@job_name = 'TestJob', -- change the job name  
@expected_start_hour = 17,  
@expected_start_minute = 0,  
@expected_finish_hour = 17,  
@expected_finish_minute = 2 -- to be changed accordingly  

-- Expected outcomes  
-- 0 = job in expected timescales or didn`t start 
-- 1 = job has overrun  

SELECT COUNT(*) AS JobOverRunning  
FROM msdb..sysjobs j  
WHERE j.name = @job_name  
AND EXISTS (SELECT TOP 1 *  
			FROM msdb..sysjobsteps sj INNER JOIN 
			     msdb..sysjobactivity ja ON ja.job_id = j.job_id  
			WHERE sj.job_id = j.job_id  
			AND ja.start_execution_date >= DATEADD(mi, @expected_start_minute, DATEADD(hh, @expected_start_hour, @todaysdate))  
			AND ja.stop_execution_date IS NULL -- only include stuff that is still running  
			AND GETDATE() >= DATEADD(mi, @expected_finish_minute, DATEADD(hh, @expected_finish_hour, @todaysdate))  
ORDER BY start_execution_date)  

--Alert name: jobs overran
--The job being monitored ran for longer than expected. 
--Default threshold values: High: Leave unchecked 
--						    Medium: 0 
--						    Low: Leave unchecked 