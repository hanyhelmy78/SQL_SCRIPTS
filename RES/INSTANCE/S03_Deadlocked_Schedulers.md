Open `sqlcmd` using a `DAC` connection with a dedicated port `1434`

-- CMD
sqlcmd -S . -A

Terminate the unwanted session, but first retrieve the sample SQL text, program name, hostname, and client IP address.

```sql
select spid, db_name(p.dbid),loginame, substring(program_name,1,20) program_name, substring(s.text,1,20) sample_sql_text, blocked, waittime, lastwaittype, hostname, c.client_net_address
from sys.sysprocesses p cross apply sys.dm_exec_sql_text(p.sql_handle)s
inner join sys.dm_exec_connections c
on p.spid = c.session_id
go

declare @kill varchar(100)
declare i cursor fast_forward
for
select 'KILL '+cast(spid as varchar(10))
from sys.sysprocesses p cross apply sys.dm_exec_sql_text(p.sql_handle)s
where s.text like '%WAITFOR%' -- put here the unlike sql text or change the column e.g. program_name or loginame
and spid != @@spid
open i
fetch next from i into @kill
while @@fetch_status = 0
begin
exec(@kill)
fetch next from i into @kill
end
close i
deallocate i
go

```

After running the kill command, use SQL Server Management Studio to identify the application, its source, and the login name. Investigate with the application team or disable the login, or consider other approaches to stop the thread.

```sql

select spid, db_name(p.dbid),loginame, program_name, s.text, blocked, waittime, lastwaittype, hostname, c.client_net_address
from sys.sysprocesses p cross apply sys.dm_exec_sql_text(p.sql_handle)s
inner join sys.dm_exec_connections c
on p.spid = c.session_id
go

```
