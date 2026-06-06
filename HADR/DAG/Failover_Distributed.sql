--Execute this script on the primary AG on the primary replica or use the listener name, where it is the distributed AG that is also primary.

declare @table table (
Primary_AG_Name varchar(255), ListenerPort varchar(10), Replicas int, 
Are_Replicas_CONNECTED varchar(10), Are_Replicas_HEALTHY varchar(10), No_pending_secondary_suspend varchar(10), Databases int, All_databases_ready_to_failover varchar(10), Is_failover_ready varchar(10), 
Distributed_AG_Name varchar(255), Secondary_AG_name varchar(255), Is_Secondary_AG_Ready varchar(10))

declare @ag_name varchar(255), @Primary_AG_Name varchar(255), @ListenerPort varchar(10), @Distributed_AG_Name varchar(255), @Secondary_AG_name varchar(255), 
@PrimaryListener varchar(355), @SecondaryListener varchar(355), @sql varchar(max)

set nocount on
declare ag_cursor cursor fast_forward
for
select ag.name, agl.port
from sys.dm_hadr_availability_replica_states ars inner join sys.availability_groups ag
on ars.group_id = ag.group_id
inner join sys.availability_group_listeners agl
on agl.group_id = ag.group_id
where is_distributed = 0
and is_local = 1 --; The two conditions are utilized to obtain the local and primary Availability Groups (AG).
and role = 1 ------' So, you must access the primary replica directly or via the Listener.

open ag_cursor
fetch next from ag_cursor into @ag_name, @listenerPort
while @@FETCH_STATUS = 0
begin
insert into @table
select  @ag_name Primary_AG_Name, @listenerPort, Replicas,
case	are_Replicas_Connected        when 0 then 'Yes' else 'No' end Are_Replicas_CONNECTED,
case	synchronization_health        when 0 then 'Yes' else 'No' end Are_Replicas_HEALTHY,
case	is_pending_secondary_suspend  when 0 then 'Yes' else 'No' end No_pending_secondary_suspend, Databases,
case  is_failover_ready             when 0 then 'Yes' else 'No' end All_databases_ready_to_failover,
case when are_Replicas_Connected + synchronization_health + is_pending_secondary_suspend + is_failover_ready = 0
then 'Passed' else 'Not ready' end Is_failover_ready,
dag_info.Distributed_AG_Name,dag_info.Secondary_AG_name,dag_info.SecondaryReady
from (
select count(distinct ars.replica_id) replicas,
sum(case connected_state_desc when 'CONNECTED' then 0 else 1 end) are_Replicas_Connected, 
sum(case synchronization_health_desc when 'HEALTHY' then 0 else 1 end) synchronization_health,
sum(case cast(is_pending_secondary_suspend as int) when 0 then 0 else 1 end) is_pending_secondary_suspend
from sys.dm_hadr_availability_replica_states ars inner join sys.availability_groups ag
on ars.group_id = ag.group_id
inner join sys.dm_hadr_database_replica_cluster_states dbrcs
on dbrcs.replica_id = ars.replica_id
where ag.name = @ag_name)a
cross apply (select count(*) Databases,
case when count(*) = sum(cast(is_failover_ready as int)) then 0 else 1 end is_failover_ready
from sys.dm_hadr_database_replica_cluster_states dbrcs
inner join sys.dm_hadr_availability_replica_states ars
on dbrcs.replica_id = ars.replica_id
inner join sys.availability_groups ag
on ars.group_id = ag.group_id
where ars.is_local = 1
and ag.name = @ag_name) rep
cross apply (
SELECT ar.replica_server_name Secondary_AG_name, ag.name Distributed_AG_Name,
case 
when ars.synchronization_health_desc = 'HEALTHY'
and ars.connected_state_desc = 'CONNECTED' then 'Yes' else 'No' 
end SecondaryReady
FROM sys.availability_groups ag
INNER JOIN sys.availability_replicas ar 
ON ag.group_id = ar.group_id
INNER JOIN sys.dm_hadr_availability_replica_states ars 
ON ar.replica_id = ars.replica_id
where ag.is_distributed = 1
and ag.name in (
SELECT ag.name AS AGName
FROM sys.availability_groups ag
INNER JOIN sys.availability_replicas ar 
ON ag.group_id = ar.group_id
INNER JOIN sys.dm_hadr_availability_replica_states ars 
ON ar.replica_id = ars.replica_id
where ag.is_distributed = 1
and ar.replica_server_name  = @ag_name)
and ar.replica_server_name != @ag_name) dag_info

fetch next from ag_cursor into @ag_name,@listenerport
end
close ag_cursor
deallocate ag_cursor

select * from @table

declare ag_dag_cursor cursor fast_forward
for
select Primary_AG_Name, ListenerPort, Distributed_AG_Name, Secondary_AG_name  
from @table
where Is_failover_ready = 'Passed'
and Is_Secondary_AG_Ready = 'Yes'

open ag_dag_cursor
fetch next from ag_dag_cursor into @Primary_AG_Name, @ListenerPort, @Distributed_AG_Name, @Secondary_AG_name  
while @@FETCH_STATUS = 0
begin

select @PrimaryListener = ListenerName+','+@listenerPort
from (
SELECT  replace(substring(endpoint_url,1,charindex('.',endpoint_url)-1),'TCP://','') ListenerName,
case when ags.primary_replica = dr.replica_server_name then 1 else 2 end AG_Role
FROM sys.availability_groups dag
inner join sys.availability_replicas dr ON dag.group_id = dr.group_id
left outer join sys.dm_hadr_availability_group_states ags
on ags.primary_replica = dr.replica_server_name
WHERE dag.is_distributed = 1
and dag.name = @Distributed_AG_Name)a
where AG_Role = 1

select @SecondaryListener = ListenerName+','+@listenerPort
from (
SELECT  replace(substring(endpoint_url,1,charindex('.',endpoint_url)-1),'TCP://','') ListenerName,
case when ags.primary_replica = dr.replica_server_name then 1 else 2 end AG_Role
FROM sys.availability_groups dag
inner join sys.availability_replicas dr ON dag.group_id = dr.group_id
left outer join sys.dm_hadr_availability_group_states ags
on ags.primary_replica = dr.replica_server_name
WHERE dag.is_distributed = 1
and dag.name = @Distributed_AG_Name)a
where AG_Role = 2

--After confirming the application stop, change the Availability Mode of the Secondary AG on the Primary AG to SYNCHRONOUS.
print('--After confirming the application stop, change the Availability Mode of the Secondary AG on the Primary AG to SYNCHRONOUS.')
set @sql = ':CONNECT '+@PrimaryListener
print(@sql)
print('GO')
print('use master')
print('GO')
set @sql = 'ALTER AVAILABILITY GROUP ['+@Distributed_AG_Name+'] MODIFY AVAILABILITY GROUP ON '+''''+@Secondary_AG_name+''''+' WITH (AVAILABILITY_MODE = SYNCHRONOUS_COMMIT);'
print(@sql)
print('GO')

--Verify and confirm that all databases in the Primary AG are now SYNCHRONOUS to safely begin the failover.
print('--Verify and confirm that all databases in the Primary AG are now SYNCHRONOUS to safely begin the failover.')
set @sql = ':CONNECT '+@PrimaryListener
print(@sql)
print('GO')
print('use master')
print('GO')
print('--Please run the following query repeatedly until the "Dag_Sec_Ag_ready_to_failover" column shows the value "Yes."
SELECT  
count(*) Databases, 
case when sum(drs.synchronization_state) = (count(*) * 2) then ''Yes'' else ''No'' end All_DB_Synchronized, 
case when sum(drs.synchronization_health) = (count(*) * 2) then ''Yes'' else ''No'' end All_DB_Healthy, 
case when sum(cast(drs.is_suspended as int)) = 0 then ''Yes'' else ''No'' end No_suspended_DBs,
case 
when 
count(*) = sum(cast(drs.is_commit_participant as int))
and 
(count(*) * 4) = sum(drs.synchronization_state)  +
                 sum(drs.synchronization_health) +
                 sum(cast(drs.is_suspended as int))
then ''Yes'' else ''Not yet'' end Dag_Sec_Ag_ready_to_failover
FROM sys.availability_groups ag
inner join sys.dm_hadr_database_replica_states drs 
on ag.group_id = drs.group_id
where ag.is_distributed = 1
and ag.name = '+''''+@Distributed_AG_Name+''''+';

GO

Select Top 1 case when no_dbs = (DBs/2) then ''Yes'' else ''No'' end
DBs_Matched_Commit_Harden_LSNs
from (
select count(*) over() no_dbs, *
from (
SELECT row_number() over(partition by database_id order by database_id, name) pid, 
database_id, ag.name, last_commit_lsn, last_hardened_lsn,
count(*) over() DBs
FROM sys.availability_groups ag
inner join sys.dm_hadr_database_replica_states drs 
on ag.group_id = drs.group_id
where (ag.is_distributed = 1 or drs.is_local = 1)
and ag.name in ('+''''+@Primary_AG_Name+''''+','+''''+@Distributed_AG_Name+''''+'))a
pivot (max(name) for pid in ([1],[2]))p)b;'
)
print('GO')

--Change the current Distributed Availability Group (AG) from Primary Role to Secondary Role.
print('--Change the current Distributed Availability Group (AG) from Primary Role to Secondary Role.')
set @sql = ':CONNECT '+@PrimaryListener
print(@sql)
print('GO')
print('use master')
print('GO')
set @sql = 'ALTER AVAILABILITY GROUP ['+@Distributed_AG_Name+'] SET (ROLE = SECONDARY);'
print(@sql)
print('GO')

--Failover the Distributed Availability Group from the Secondary Availability Group.
print('--Failover the Distributed Availability Group from the Secondary Availability Group.')
set @sql = ':CONNECT '+@SecondaryListener
print(@sql)
print('GO')
print('use master')
print('GO')
set @sql = 'ALTER AVAILABILITY GROUP ['+@Distributed_AG_Name+'] FORCE_FAILOVER_ALLOW_DATA_LOSS;'
print(@sql)
print('GO')

--Switch back to ASYNCHRONOUS mode from the previous Primary Availability Group (AG).
print('--Switch back to ASYNCHRONOUS mode from the previous Primary Availability Group (AG).')
set @sql = ':CONNECT '+@PrimaryListener
print(@sql)
print('GO')
print('use master')
print('GO')
set @sql = 'ALTER AVAILABILITY GROUP ['+@Distributed_AG_Name+'] MODIFY AVAILABILITY GROUP ON '+''''+@Secondary_AG_name+''''+' WITH (AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT);'
print(@sql)
print('GO')
    
fetch next from ag_dag_cursor into @Primary_AG_Name, @ListenerPort, @Distributed_AG_Name, @Secondary_AG_name  
end
close ag_dag_cursor
deallocate ag_dag_cursor
