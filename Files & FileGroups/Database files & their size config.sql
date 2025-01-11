--use tempdb ;
go
--	Find used/free space in Database Files
select	SERVERPROPERTY('MachineName') AS srv_name,
		DB_NAME() AS [db_name], f.type_desc, fg.name as file_group, f.name, f.physical_name, 
		[size_GB] = convert(numeric(20,2),(f.size*8.0)/1024/1024), f.max_size, f.growth, 
		[SpaceUsed_gb] = convert(numeric(20,2),CAST(FILEPROPERTY(f.name, 'SpaceUsed') as BIGINT)/128.0/1024)
		,[FreeSpace_GB] = convert(numeric(20,2),(size/128.0 -CAST(FILEPROPERTY(f.name,'SpaceUsed') AS INT)/128.0)/1024)
		,cast((FILEPROPERTY(f.name,'SpaceUsed')*100.0)/size as decimal(20,2)) as Used_Percentage
		,CASE WHEN f.type_desc = 'LOG' THEN (select d.log_reuse_wait_desc from sys.databases as d where d.name = DB_NAME()) ELSE NULL END as log_reuse_wait_desc
from sys.database_files f left join sys.filegroups fg on fg.data_space_id = f.data_space_id
order by FreeSpace_GB desc;
go