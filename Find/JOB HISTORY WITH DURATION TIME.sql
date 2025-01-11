SELECT DISTINCT jobs.name AS 'JobName',
msdb.dbo.agent_datetime(run_date, run_time) AS 'Run Date Time',
history.run_duration AS 'Duration in Second'
FROM msdb.dbo.sysjobs jobs
INNER JOIN msdb.dbo.sysjobhistory history
ON jobs.job_id = history.job_id
WHERE jobs.enabled = 1
ORDER BY history.run_duration DESC --jobs.name