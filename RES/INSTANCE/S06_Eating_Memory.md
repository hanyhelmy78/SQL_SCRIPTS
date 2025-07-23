Open `sqlcmd` using a `DAC` connection with a dedicated port `1434`

```CMD
sqlcmd -S . -A

```

Run the following query to understand the situation.

```sql
select spid, db_name(p.dbid),loginame, substring(program_name,1,20) program_name, substring(s.text,1,20) sample_sql_text, blocked, waittime, lastwaittype, hostname, c.client_net_address
from sys.sysprocesses p cross apply sys.dm_exec_sql_text(p.sql_handle)s
inner join sys.dm_exec_connections c
on p.spid = c.session_id
go

```
It will show you this error message indicating a low memory configuration.

```sql
Msg 8645, Level 17, State 1, Server SQLSERVERVM01, Line 1
A timeout occurred while waiting for memory resources to execute the query in resource pool 'internal' (1). Rerun the query.
```

Check the current configuration.
```sql
sp_configure 'memo'
go
duplicate_options
-----------------------------------
index create memory (KB)
min memory per query (KB)
min server memory (MB)
max server memory (MB)
tempdb metadata memory-optimized

sp_configure 'max server memory (MB)'
go
name                                minimum     maximum     config_value run_value
----------------------------------- ----------- ----------- ------------ -----------
max server memory (MB)                      128  2147483647          128         128

-- 128 MB is a very low value, change it.

SP_CONFIGURE 'max server memory (MB)',  6500
GO
RECONFIGURE
GO

```

Execute the sessions overview query again to identify the responsible party or any related issues.

```sql
select spid, db_name(p.dbid),loginame, substring(program_name,1,20) program_name, substring(s.text,1,20) sample_sql_text, blocked, waittime, lastwaittype, hostname, c.client_net_address
from sys.sysprocesses p cross apply sys.dm_exec_sql_text(p.sql_handle)s
inner join sys.dm_exec_connections c
on p.spid = c.session_id
go

```

Then you can terminate the session(s) causing this issue.

```sql

declare @kill varchar(100)
declare i cursor fast_forward
for
select 'KILL '+cast(spid as varchar(10))
from sys.sysprocesses p cross apply sys.dm_exec_sql_text(p.sql_handle)s
where s.text like '%SELECT * FROM master%'
-- program_name like '%.Net SqlClient Data%' -- put here the unlike sql text or change the column e.g. program_name or loginame
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