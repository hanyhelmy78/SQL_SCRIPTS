-- list of jobs with name, steps, last run date/time, next_run_date/time
SELECT 
name JobName
,CONVERT(VARCHAR(16), date_created, 120) date_created
,sysjobsteps.step_id
,sysjobsteps.step_name
,LEFT(CAST(sysjobsteps.last_run_date AS VARCHAR),4)+ '-'
+SUBSTRING(CAST(sysjobsteps.last_run_date AS VARCHAR),5,2)+'-'
+SUBSTRING(CAST(sysjobsteps.last_run_date AS VARCHAR),7,2) last_run_date
,
CASE 
 WHEN LEN(CAST(sysjobsteps.last_run_time AS VARCHAR)) = 6  
  THEN SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),1,2) 
    +':' + SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),3,2)
    +':' + SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),5,2)
 WHEN LEN(CAST(sysjobsteps.last_run_time AS VARCHAR)) = 5
  THEN '0' + SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),1,1) 
    +':'+SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),2,2)
    +':'+SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),4,2)
 WHEN LEN(CAST(sysjobsteps.last_run_time AS VARCHAR)) = 4
  THEN '00:' 
    + SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),1,2)
    +':' + SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),3,2)
 WHEN LEN(CAST(sysjobsteps.last_run_time AS VARCHAR)) = 3
  THEN '00:' 
    +'0' + SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),1,1)
    +':' + SUBSTRING(CAST(sysjobsteps.last_run_time AS VARCHAR),2,2)
 WHEN LEN(CAST(sysjobsteps.last_run_time AS VARCHAR)) = 2  THEN '00:00:' + CAST(sysjobsteps.last_run_time AS VARCHAR)
 WHEN LEN(CAST(sysjobsteps.last_run_time AS VARCHAR)) = 1  THEN '00:00:' + '0'+ CAST(sysjobsteps.last_run_time AS VARCHAR)
END last_run_time
,LEFT(CAST(sysjobschedules.next_run_date AS VARCHAR),4)+ '-'
+SUBSTRING(CAST(sysjobschedules.next_run_date AS VARCHAR),5,2)+'-'
+SUBSTRING(CAST(sysjobschedules.next_run_date AS VARCHAR),7,2) next_run_date
,
CASE 
 WHEN LEN(CAST(next_run_time AS VARCHAR)) = 6  
  THEN SUBSTRING(CAST(next_run_time AS VARCHAR),1,2) 
    +':' + SUBSTRING(CAST(next_run_time AS VARCHAR),3,2)
    +':' + SUBSTRING(CAST(next_run_time AS VARCHAR),5,2)
 WHEN LEN(CAST(next_run_time AS VARCHAR)) = 5
  THEN '0' + SUBSTRING(CAST(next_run_time AS VARCHAR),1,1) 
    +':'+SUBSTRING(CAST(next_run_time AS VARCHAR),2,2)
    +':'+SUBSTRING(CAST(next_run_time AS VARCHAR),4,2)
 WHEN LEN(CAST(next_run_time AS VARCHAR)) = 4
  THEN '00:' 
    + SUBSTRING(CAST(next_run_time AS VARCHAR),1,2)
    +':' + SUBSTRING(CAST(next_run_time AS VARCHAR),3,2)
 WHEN LEN(CAST(next_run_time AS VARCHAR)) = 3
  THEN '00:' 
    +'0' + SUBSTRING(CAST(next_run_time AS VARCHAR),1,1)
    +':' + SUBSTRING(CAST(next_run_time AS VARCHAR),2,2)
 WHEN LEN(CAST(next_run_time AS VARCHAR)) = 2  THEN '00:00:' + CAST(next_run_time AS VARCHAR)
 WHEN LEN(CAST(next_run_time AS VARCHAR)) = 1  THEN '00:00:' + '0'+ CAST(next_run_time AS VARCHAR)
END next_run_time
FROM msdb.dbo.sysjobs
LEFT JOIN msdb.dbo.sysjobschedules
ON sysjobs.job_id = sysjobschedules.job_id
INNER JOIN msdb.dbo.sysjobsteps
ON sysjobs.job_id = sysjobsteps.job_id
ORDER BY sysjobs.job_id, sysjobsteps.step_id