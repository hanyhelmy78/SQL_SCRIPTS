declare @start_time datetime2 = sysdatetime();
declare @my_login varchar(100) = ORIGINAL_LOGIN();
declare @kill_string nvarchar(200);
declare @memory_threshold_mb int = 500;
declare @include_open_tran bit = 1;

declare @sql nvarchar(max);
declare @params nvarchar(2000);
set @params = N'@memory_threshold_mb int, @include_open_tran bit, @my_login varchar(100)';

set quoted_identifier off;
set @sql = "
select [memory_gb] = der.granted_query_memory*8.0/1024/1024, 
		[--kill query--] = 'kill '+convert(varchar,der.session_id)+char(10)
		,[--find-query--] = 'dbcc inputbuffer('+convert(varchar,der.session_id)+')'
		,[session_tran_count] = des.open_transaction_count 
		,[request_tran_count] = der.open_transaction_count
		,[elapsed_time] = convert(varchar,getdate()-der.start_time,108)
		,der.session_id, der.status, der.command
		,[db_name] = db_name(der.database_id)
		,der.blocking_session_id, der.wait_type, [wait_time] = dateadd(ms,wait_time,'1900-01-01 00:00:00.000')
		,der.wait_resource, der.percent_complete, der.cpu_time, der.total_elapsed_time
		,der.logical_reads, der.writes, der.row_count, query_hash /* , dop, parallel_worker_count */
from sys.dm_exec_requests der join sys.dm_exec_sessions des
	on des.session_id = der.session_id
where der.granted_query_memory >= (@memory_threshold_mb*1024/8)
and (	@include_open_tran = 1 
	or (der.open_transaction_count = 0 and des.open_transaction_count = 0) 
	)
--and des.login_name <> @my_login
order by granted_query_memory desc;	
"
set quoted_identifier on;

exec sp_executesql @sql, @params, @memory_threshold_mb, @include_open_tran, @my_login;