-- Returns information of last backup of each database
IF NOT EXISTS(SELECT * FROM sys.schemas s WHERE s.[name] = 'sys2')
	EXEC sp_executesql N'CREATE SCHEMA sys2'
go

IF (OBJECT_ID('sys2.databases_backup_info', 'IF') IS NOT NULL)
	DROP FUNCTION sys2.databases_backup_info
GO

CREATE FUNCTION sys2.databases_backup_info(@days_back int = 7)
RETURNS TABLE 
AS
RETURN
with cte as(
select  
	dummy = 1,
	rn = row_number() over (partition by bs.database_name, bs.type  order by bs.backup_finish_date desc),
	bs.database_name,  
	bs.backup_start_date,  
	bs.backup_finish_date, 
	case 
		when bs.type = 'I' then 'Diff'
		when bs.type = 'D' then 'Full'  
		when bs.type = 'L' then 'Log'  
	end as backup_type 
from   
	msdb.dbo.backupmediafamily  bmf
inner join
	msdb.dbo.backupset bs ON bmf.media_set_id = bs.media_set_id  
where  
	(bs.backup_start_date >= convert(char(8), getdate() - @days_back, 112))  
), cte2 as
(select 
	database_name,
	full_backup = isnull([full], 0),
	diff_backup = isnull([diff], 0),
	log_backup = isnull([log], 0),	
	full_backup_start_date = backup_start_date + [full] - [full],
	full_backup_end_date = backup_finish_date + [full] - [full],
	diff_backup_start_date = backup_start_date + [diff] - [diff],
	diff_backup_end_date = backup_finish_date + [diff] - [diff],
	log_backup_start_date = backup_start_date + [log] - [log],
	log_backup_end_date = backup_finish_date + [log] - [log]
from 
	cte 
pivot
	(max(dummy) for backup_type in ([full], [diff], [log])) as p
where 
	rn = 1 
), cte3 as
(select
	database_name,
	full_backup = max(full_backup),	
	diff_backup = max(diff_backup),	
	log_backup = max(log_backup),	
	full_backup_start_date = max(full_backup_start_date),
	full_backup_end_date = max(full_backup_end_date),
	diff_backup_start_date = max(diff_backup_start_date),
	diff_backup_end_date = max(diff_backup_end_date),
	log_backup_start_date = max(log_backup_start_date),
	log_backup_end_date = max(log_backup_end_date)
from
	cte2 c
group by
	database_name)
select
	d.database_id,
	database_name = isnull(d.name, c.database_name),
	d.is_read_only,
	d.recovery_model,
	d.recovery_model_desc,
	d.state,
	d.state_desc,
	c.full_backup,
	c.diff_backup,
	c.log_backup,	
	c.full_backup_start_date,
	c.full_backup_end_date,
	c.diff_backup_start_date,
	c.diff_backup_end_date,
	c.log_backup_start_date,
	c.log_backup_end_date
from
	cte3 c
full outer join
	sys.databases d on c.database_name = d.name
go


select * from sys2.databases_backup_info (7)