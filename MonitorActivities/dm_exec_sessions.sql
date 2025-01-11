--select * from sys.dm_exec_sessions
select login_name, login_time, host_name, program_name, status 
from sys.dm_exec_sessions
where host_name is not null 
order by login_name