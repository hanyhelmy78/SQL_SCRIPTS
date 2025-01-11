SELECT j.name, j.description, a.start_execution_date
FROM msdb.dbo.sysjobs j
INNER JOIN msdb.dbo.sysjobactivity a ON j.job_id = a.job_id
WHERE a.start_execution_date > DATEADD(dd, -14, GETDATE())
AND j.enabled = 1
AND a.start_execution_date IN
(SELECT start_execution_date
FROM msdb.dbo.sysjobactivity
WHERE start_execution_date > DATEADD(dd, -14, GETDATE())
GROUP BY start_execution_date HAVING COUNT(*) > 1)
ORDER BY 3