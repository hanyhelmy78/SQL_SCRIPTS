/*
select db.database_id, name database_name, f.* from sys.databases db cross apply master.dbo.Is_DB_on_Primary_Replica_or_DAG_details(db.name) f

declare @db_name varchar(500) = 'AdventureWorks2019'
or
declare @db_name varchar(500) = db_name(db_id())
declare @is_primary bit, @desc varchar(500)
select @is_primary = Is_ReadWrite, @desc = Description
from master.dbo.Is_DB_on_Primary_Replica_or_DAG_details(@db_name);
IF @is_primary = 1
begin
insert into ... values (...,...,...);
insert into ... values (...,...,...);
insert into ... values (...,...,...);
end
else
begin
print(@desc)
end
*/
USE [master]
GO
CREATE or ALTER Function [dbo].[Is_DB_on_Primary_Replica_or_DAG_details](@db_name varchar(500))
Returns @table table (Is_ReadWrite bit, [Description] varchar(255), 
availability_group_name varchar(255), is_primary_replica int, 
distributed_name varchar(255), is_primary_distributed int)
as
Begin

insert into @table 
select  
case 
when is_primary_replica = 1 and is_primary_distributed = 1 then 
1
when is_primary_replica = 1 and is_primary_distributed = 2 then 
0
when is_primary_replica = 1 and is_primary_distributed is null then 
1
when is_primary_replica = 0 and is_primary_distributed is null then 
0
when is_primary_replica is null then
1
end is_read_write,
case 
when is_primary_replica = 1 and is_primary_distributed = 1 then 
'The database is currently hosted on the primary replica, and the Distributed Availability Group (AG) is also set to primary.'
when is_primary_replica = 1 and is_primary_distributed = 2 then 
'The database is currently on the primary replica, but the Distributed Availability Group (AG) is set to secondary.'
when is_primary_replica = 1 and is_primary_distributed is null then 
'The database is currently on the primary replica.'
when is_primary_replica = 0 and is_primary_distributed is null then 
'The database is currently on the secondary replica.'
when is_primary_replica is null then
'The database is standalone.'
end [Description],
isnull(availability_group_name,'NA') availability_group_name, 
isnull(is_primary_replica,0) is_primary_replica, 
isnull(distributed_name,'NA') distributed_name, 
isnull(is_primary_distributed,0) is_primary_distributed
  from sys.databases db 
  left outer join (select database_id, distributed_name, is_primary_distributed, 
				   group_database_id,ag.name availability_group_name, 
				   ag.group_id, is_primary_replica, al2.replica_id dag_replica_id, al2.group_id dag2_group_id
				   from sys.dm_hadr_database_replica_states dbr inner join sys.availability_groups ag
				     on dbr.group_id = ag.group_id
				    and dbr.is_local = 1
				   left outer join (select ag_name, dag_name distributed_name, primary_dag_db_group_id, is_primary_distributed, replica_id, group_id
								      from (
										    select d.group_id primary_dag_db_group_id, ars.role is_primary_distributed,
										    (select name from sys.availability_groups where group_id = d.group_id) ag_name,
										    (select name from sys.availability_groups where group_id = dag.dag_id) dag_name,
										    ar.replica_id, ar.replica_server_name, ar.group_id
										    from sys.availability_replicas ar
										    outer apply (select group_id dag_id from sys.availability_groups where is_distributed = 1) dag
										    outer apply sys.fn_hadr_distributed_ag_replica(dag_id, ar.replica_id) d
										    inner join sys.dm_hadr_availability_replica_states ars
										    on ars.replica_id = ar.replica_id
									   	    where ars.is_local = 1)al)al2
				on al2.primary_dag_db_group_id = dbr.group_id)dbrs
   on db.database_id = dbrs.database_id
  and db.group_database_id = dbrs.group_database_id
where db.name = @db_name

return 
end

