select job.Name, job.job_ID, job.Originating_Server, activity.run_requested_Date, datediff(minute, activity.run_requested_Date, getdate()) as Elapsed
from msdb.dbo.sysjobs_view job inner join 
		msdb.dbo.sysjobactivity activity
on (job.job_id = activity.job_id)
where run_Requested_date is not null 
  and stop_execution_date is null
  --and job.name like 'upd%'