Declare @mins int – Declare variable for mins
Set @mins =30 -- inactive for 30 mins
select
s.spid,t.text, s.last_batch,
 s.login_time, s.open_tran,
 s.nt_username, s.hostname,s.status
from
sys.sysprocesses s cross apply
 sys.dm_exec_sql_text(sql_handle) t
where
s.status not in ( 'runnable', 'suspended' , 'running')
 AND datediff (mi,last_batch, getdate()) > @mins*4
 and  not(nt_username like 'service%') -- do not kill service account
 and  not(nt_username like 'adm%') -- do not kill adm accounts
 and  s.spid >=50 -- do not kill SQL system generated spids