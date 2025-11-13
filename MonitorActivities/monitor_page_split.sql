CREATE EVENT SESSION [TrackPageSplits] ON SERVER 
ADD EVENT sqlserver.page_split
ADD TARGET package0.event_file(SET filename=N'PageSplits')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


if object_id('tempdb..pagesplit') is not null
begin
drop table tempdb..pagesplit
end
go
create table tempdb..pagesplit (XMLvalue xml, timestamp varchar(19))
go

declare @Extended_Event_Directory varchar(500)
select @Extended_Event_Directory = Extended_Event_Directory+substring(Extended_Event_file_name,1,charindex('_',Extended_Event_file_name))+'*'
from (
select Extended_Event,
reverse(substring(reverse(Extended_Event_Directory),1,charindex('\',reverse(Extended_Event_Directory))-1)) Extended_Event_file_name,
reverse(substring(reverse(Extended_Event_Directory),charindex('\',reverse(Extended_Event_Directory)),len(Extended_Event_Directory))) Extended_Event_Directory
from (
select xe.name Extended_Event, 
cast(xet.target_data as xml).value('(EventFileTarget/File/@name)[1]', 'VARCHAR(MAX)') Extended_Event_Directory
from sys.dm_xe_session_targets xet JOIN sys.dm_xe_sessions xe 
on xe.address = xet.event_session_address
where xet.target_name = 'event_file')a)b
where Extended_Event = 'TrackPageSplits'

insert into tempdb..pagesplit
select cast(event_data as xml) XMLvalue, convert(varchar(19),dateadd(hour, 3, timestamp_utc),120) timestamp
from sys.fn_xe_file_target_read_file(@Extended_Event_Directory,null,null,null)
where object_name = 'page_split'

select count(*) number_pageSplit_per_sec, timestamp, +'['+schema_name(info.schema_id)+'].['+info.table_name+']' table_name, info.index_id, info.index_name
from (
select 
timestamp,
n.value('(data[@name="database_id"]/value)[1]', 'bigint') database_id,
n.value('(data[@name="rowset_id"]/value)[1]', 'bigint') rowset_id,
n.value('(data[@name="splitOperation"]/text)[1]', 'varchar(100)') splitOperation
from (
select XMLvalue, timestamp
from tempdb..pagesplit) xef 
cross apply xef.XMLvalue.nodes('event') as q(n)) x
inner join 
(
select p.object_id, p.index_id, t.schema_id, t.name table_name, i.name index_name, a.container_id
from sys.partitions p inner join 
sys.allocation_units a 
on (type in (1,3) and p.hobt_id = a.container_id)
or (type = 2 and p.partition_id = a.container_id)
inner join sys.tables t
on p.object_id = t.object_id
inner join sys.indexes i 
on p.object_id = i.object_id
and p.index_id = i.index_id) info
on x.rowset_id = info.container_id
where x.database_id = db_id()
group by timestamp, info.schema_id, info.table_name, info.index_id, info.index_name


select 
master.dbo.duration('s',datediff(s, min(timestamp), max(timestamp))) period_of_time,
cast(min(number_pageSplit_per_sec) as varchar(30))+'/sec' min_pageSplit_per_sec, 
cast(avg(number_pageSplit_per_sec) as varchar(30))+'/sec' avg_pageSplit_per_sec, 
cast(max(number_pageSplit_per_sec) as varchar(30))+'/sec' max_pageSplit_per_sec, 
table_name, index_id, index_name,
case 
when avg(number_pageSplit_per_sec) between  0 and 20    then 'Good' 
when avg(number_pageSplit_per_sec) between 21 and 40    then 'Moderate' 
when avg(number_pageSplit_per_sec) between 41 and 100   then 'Poor' 
when avg(number_pageSplit_per_sec) between 100 and 5000 then 'Critical' 
end status,
case 
when avg(number_pageSplit_per_sec) between  0 and 20    then 'No action needed default (100%)' 
when avg(number_pageSplit_per_sec) between 21 and 40    then 'fill factor between (95% - 85%)' 
when avg(number_pageSplit_per_sec) between 41 and 100   then 'fill factor between (85% - 70%)' 
when avg(number_pageSplit_per_sec) between 100 and 5000 then 'fill factor between (70% - 50%)' 
end recommendations
from (
select count(*) number_pageSplit_per_sec, timestamp, +'['+schema_name(info.schema_id)+'].['+info.table_name+']' table_name, info.index_id, info.index_name
from (
select 
timestamp,
n.value('(data[@name="database_id"]/value)[1]', 'bigint') database_id,
n.value('(data[@name="rowset_id"]/value)[1]', 'bigint') rowset_id,
n.value('(data[@name="splitOperation"]/text)[1]', 'varchar(100)') splitOperation
from (
select XMLvalue, timestamp
from tempdb..pagesplit) xef 
cross apply xef.XMLvalue.nodes('event') as q(n)) x
inner join 
(
select p.object_id, p.index_id, t.schema_id, t.name table_name, i.name index_name, a.container_id
from sys.partitions p inner join 
sys.allocation_units a 
on (type in (1,3) and p.hobt_id = a.container_id)
or (type = 2 and p.partition_id = a.container_id)
inner join sys.tables t
on p.object_id = t.object_id
inner join sys.indexes i 
on p.object_id = i.object_id
and p.index_id = i.index_id) info
on x.rowset_id = info.container_id
where x.database_id = db_id()
group by timestamp, info.schema_id, info.table_name, info.index_id, info.index_name) ana
group by table_name, index_id, index_name