/* Performance Tuning Scripts 
1- All databases CPU resources usage */
WITH DB_CPU_STATS_ON_INSTANCE
AS
(SELECT DatabaseID, DB_Name(DatabaseID) AS [DatabaseName], SUM(total_worker_time) AS [CPU_Time_Ms]
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY (SELECT CONVERT(int, value) AS [DatabaseID] 
FROM sys.dm_exec_plan_attributes(qs.plan_handle)
WHERE attribute = N'dbid') AS F_DB
GROUP BY DatabaseID)
SELECT ROW_NUMBER() OVER(ORDER BY [CPU_Time_Ms] DESC) AS [row_num],
DatabaseName, [CPU_Time_Ms], 
CAST([CPU_Time_Ms] * 1.0 / SUM([CPU_Time_Ms]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUPercent]
FROM DB_CPU_STATS_ON_INSTANCE
WHERE DatabaseID > 4 
AND DatabaseID <> 32767 
ORDER BY row_num OPTION (RECOMPILE);
/* 2- TOP 10 CPU queries */
SELECT TOP 10
    ObjectName          = OBJECT_SCHEMA_NAME(qt.objectid,dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid)
    ,TextData           = qt.text
    ,DiskReads          = qs.total_physical_reads   -- The worst reads, disk reads
    ,MemoryReads        = qs.total_logical_reads    --Logical Reads are memory reads
    ,Executions         = qs.execution_count
    ,TotalCPUTime       = qs.total_worker_time
    ,AverageCPUTime     = qs.total_worker_time/qs.execution_count
    ,DiskWaitAndCPUTime = qs.total_elapsed_time
    ,MemoryWrites       = qs.max_logical_writes
    ,DateCached         = qs.creation_time
    ,DatabaseName       = DB_Name(qt.dbid)
    ,LastExecutionTime  = qs.last_execution_time
 FROM sys.dm_exec_query_stats AS qs
 CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
 ORDER BY qs.total_worker_time DESC;

 select top 10
query_stats.query_hash,
SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) as avgCPU_USAGE,
min(query_stats.statement_text) as QUERY
from (
select qs.*,
SUBSTRING(st.text,(qs.statement_start_offset/2)+1,
((case statement_end_offset
when -1 then DATALENGTH(st.text)
else qs.statement_end_offset end
- qs.statement_start_offset)/2) +1) as statement_text
from sys.dm_exec_query_stats as qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) as st 
) as query_stats
group by query_stats.query_hash
order by 2 desc;

   select TOP 10
       SUBSTRING(st.text,(qs.statement_start_offset/2)+1,
       ((case statement_end_offset
          when -1 then DATALENGTH(st.text)
          else qs.statement_end_offset end
          - qs.statement_start_offset)/2) +1) as statement_text,
          qs.total_logical_reads,
          qs.total_physical_reads,
          qs.execution_count
      from sys.dm_exec_query_stats as qs
   cross apply sys.dm_exec_sql_text(qs.sql_handle) as st 
order by qs.total_logical_reads desc, qs.execution_count desc;

/***************** IO Stats ****************/ 
select 
serverproperty('MachineName') 'machine_name'
,isnull(serverproperty('InstanceName'),'mssqlserver') 'instance_name'
,@@SERVERNAME 'sql_server_name'
,DB_NAME(mf.database_id) 'database_name'
,mf.name 'logical_name'
,mf.physical_name 'physical_name'
,left(mf.physical_name,1) 'disk_drive'
,mf.type_desc 'file_type'
,mf.state_desc 'state'
,case mf.is_read_only
when 0 then 'no'
when 1 then 'yes'
end 'read_only'
,convert(numeric(18,2),convert(numeric,mf.size)*8/1024) 'size_mb'
,divfs.size_on_disk_bytes/1024/1024 'size_on_disk_mb'
,case mf.is_percent_growth
when 0 then cast(convert(int,convert(numeric,mf.growth)*8/1024) as varchar) + ' MB'
when 1 then cast(mf.growth as varchar) + '%'
end 'growth'
,case mf.is_percent_growth
when 0 then convert(numeric(18,2),convert(numeric,mf.growth)*8/1024)
when 1 then convert(numeric(18,2),(convert(numeric,mf.size)*mf.growth/100)*8/1024)
end 'next_growth_mb'
,case mf.max_size
when 0 then 'NO-growth'
when -1 then (case mf.growth when 0 then 'NO-growth' else 'unlimited' end)
else cast(convert(int,convert(numeric,mf.max_size)*8/1024) as varchar)+' MB'
end 'max_size'
,divfs.num_of_reads
,divfs.num_of_bytes_read/1024/1024 'read_mb'
,divfs.io_stall_read_ms
,divfs.num_of_writes
,divfs.num_of_bytes_written/1024/1024 'write_mb'
,divfs.io_stall_write_ms
from sys.master_files as mf
left outer join sys.dm_io_virtual_file_stats(null,null) as divfs
on mf.database_id=divfs.database_id and mf.file_id=divfs.file_id;

/***************** monitor running queries ********************/ 
select text, 
SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(st.text)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2) + 1) AS statement_text,
* from sys.dm_exec_requests qs
cross apply sys.dm_exec_sql_text(sql_handle) st
cross apply sys.dm_exec_query_plan(plan_handle);

/***************** Active Sessions and Status ********************/ 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 
SPID = er.session_id 
,BlkBy = er.blocking_session_id 
,ElapsedMS = er.total_elapsed_time 
,CPU = er.cpu_time 
,IOReads = er.logical_reads + er.reads 
,IOWrites = er.writes 
,Executions = ec.execution_count 
,CommandType = er.command 
,ObjectName = OBJECT_SCHEMA_NAME(qt.objectid,dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid) 
,SQLStatement = 
SUBSTRING 
( 
qt.text, 
er.statement_start_offset/2, 
(CASE WHEN er.statement_end_offset = -1 
THEN LEN(CONVERT(nvarchar(MAX), qt.text)) * 2 
ELSE er.statement_end_offset 
END - er.statement_start_offset)/2 
) 
,Status = ses.status 
,[Login] = ses.login_name 
,Host = ses.host_name 
,DBName = DB_Name(er.database_id) 
,LastWaitType = er.last_wait_type 
,StartTime = er.start_time 
,Protocol = con.net_transport 
,transaction_isolation = 
CASE ses.transaction_isolation_level 
WHEN 0 THEN 'Unspecified' 
WHEN 1 THEN 'Read Uncommitted' 
WHEN 2 THEN 'Read Committed' 
WHEN 3 THEN 'Repeatable' 
WHEN 4 THEN 'Serializable' 
WHEN 5 THEN 'Snapshot' 
END 
,ConnectionWrites = con.num_writes 
,ConnectionReads = con.num_reads 
,ClientAddress = con.client_net_address 
,Authentication = con.auth_scheme 
FROM sys.dm_exec_requests er 
LEFT JOIN sys.dm_exec_sessions ses ON ses.session_id = er.session_id 
LEFT JOIN sys.dm_exec_connections con ON con.session_id = ses.session_id 
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) as qt 
OUTER APPLY 
( 
SELECT execution_count = MAX(cp.usecounts) 
FROM sys.dm_exec_cached_plans cp 
WHERE cp.plan_handle = er.plan_handle 
) ec 
ORDER BY 
er.blocking_session_id DESC, 
er.logical_reads + er.reads DESC, 
er.session_id;

/***************** Blocking and Lock Script ********************/ 
SELECT
db.name DBName,
tl.request_session_id,
wt.blocking_session_id,
OBJECT_NAME(p.OBJECT_ID) BlockedObjectName,
tl.resource_type,
h1.TEXT AS RequestingText,
h2.TEXT AS BlockingTest,
tl.request_mode
FROM sys.dm_tran_locks AS tl
INNER JOIN sys.databases db ON db.database_id = tl.resource_database_id
INNER JOIN sys.dm_os_waiting_tasks AS wt ON tl.lock_owner_address = wt.resource_address
INNER JOIN sys.partitions AS p ON p.hobt_id = tl.resource_associated_entity_id
INNER JOIN sys.dm_exec_connections ec1 ON ec1.session_id = tl.request_session_id
INNER JOIN sys.dm_exec_connections ec2 ON ec2.session_id = wt.blocking_session_id
CROSS APPLY sys.dm_exec_sql_text(ec1.most_recent_sql_handle) AS h1
CROSS APPLY sys.dm_exec_sql_text(ec2.most_recent_sql_handle) AS h2
GO

/***************** Backup Check ********************/ 
SELECT DB.name AS Database_Name
,MAX(DB.recovery_model_desc) AS Recovery_Model
,MAX(BS.backup_start_date) AS Last_Backup
,MAX(CASE WHEN BS.type = 'D'
THEN BS.backup_start_date END)
AS Last_Full_backup
,SUM(CASE WHEN BS.type = 'D'
THEN 1 END)
AS Count_Full_backup
,MAX(CASE WHEN BS.type = 'L'
THEN BS.backup_start_date END)
AS Last_Log_backup
,SUM(CASE WHEN BS.type = 'L'
THEN 1 END)
AS Count_Log_backup
,MAX(CASE WHEN BS.type = 'I'
THEN BS.backup_start_date END)
AS Last_Differential_backup
,SUM(CASE WHEN BS.type = 'I'
THEN 1 END)
AS Count_Differential_backup
,MAX(CASE WHEN BS.type = 'F'
THEN BS.backup_start_date END)
AS LastFile
,SUM(CASE WHEN BS.type = 'F'
THEN 1 END)
AS CountFile
,MAX(CASE WHEN BS.type = 'G'
THEN BS.backup_start_date END)
AS LastFileDiff
,SUM(CASE WHEN BS.type = 'G'
THEN 1 END)
AS CountFileDiff
,MAX(CASE WHEN BS.type = 'P'
THEN BS.backup_start_date END)
AS LastPart
,SUM(CASE WHEN BS.type = 'P'
THEN 1 END)
AS CountPart
,MAX(CASE WHEN BS.type = 'Q'
THEN BS.backup_start_date END)
AS LastPartDiff
,SUM(CASE WHEN BS.type = 'Q'
THEN 1 END)
AS CountPartDiff
FROM sys.databases AS DB
LEFT JOIN
msdb.dbo.backupset AS BS
ON BS.database_name = DB.name
WHERE ISNULL(BS.is_damaged, 0) = 0-- exclude damaged backups 
GROUP BY DB.name
ORDER BY Last_Backup desc;  

/***************** Index Maintenance Scripts ********************/ 
declare @db int
select @db=DB_ID('ABP_BMB')
select 'ALTER INDEX [' + i.name +'] on '+OBJECT_NAME(s.object_id)+' REBUILD WITH (ONLINE = ON)',
objname = OBJECT_NAME(s.object_id),
s.object_id,
index_name= i.name,
index_type_desc, 
avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats(@db,null,null,null,null) as s
join sys.indexes i on i.object_id = s.object_id and i.index_id = s.index_id 
where avg_fragmentation_in_percent>30
order by avg_fragmentation_in_percent desc, page_count desc;

/***************** Index usage statistics ********************/
select objname = OBJECT_NAME(s.object_id),
s.object_id,
index_name= i.name,
index_id = i.index_id,
user_seeks, user_scans, user_lookups
from sys.dm_db_index_usage_stats as s
join sys.indexes i on i.object_id = s.object_id and i.index_id = s.index_id
where database_id = DB_ID('DEVECI')
and OBJECTPROPERTY(s.object_id,'IsUserTable')=1
order by (user_seeks + user_scans + user_lookups) desc;

/***************** Database Objects Statistics ********************/
SELECT 
object_name(si.[object_id]) AS [TableName]
, CASE 
WHEN si.[stats_id] = 0 then 'Heap'
WHEN si.[stats_id] = 1 then 'CL'
WHEN INDEXPROPERTY ( si.[object_id], si.[name], 'IsAutoStatistics') = 1 THEN 'Stats-Auto'
WHEN INDEXPROPERTY ( si.[object_id], si.[name], 'IsHypothetical') = 1 THEN 'Stats-HIND'
WHEN INDEXPROPERTY ( si.[object_id], si.[name], 'IsStatistics') = 1 THEN 'Stats-User'
WHEN si.[stats_id] BETWEEN 2 AND 1004 THEN 'NC ' + RIGHT('00' + convert(varchar, si.[stats_id]), 3)
ELSE 'Text/Image'
END AS [IndexType]
, si.[name] AS [IndexName]
, si.[stats_id] AS [IndexID]
, CASE
WHEN si.[stats_id] BETWEEN 1 AND 250 AND STATS_DATE (si.[object_id], si.[stats_id]) < DATEADD(m, -1, getdate()) 
THEN '!! More than a month OLD !!'
WHEN si.[stats_id] BETWEEN 1 AND 250 AND STATS_DATE (si.[object_id], si.[stats_id]) < DATEADD(wk, -1, getdate()) 
THEN '! Within the past month !'
WHEN si.[stats_id] BETWEEN 1 AND 250 THEN 'Stats recent'
ELSE ''
END AS [Warning]
, STATS_DATE (si.[object_id], si.[stats_id]) AS [Last Stats Update]
, no_recompute
FROM sys.stats AS si
WHERE OBJECTPROPERTY(si.[object_id], 'IsUserTable') = 1 and STATS_DATE (si.[object_id], si.[stats_id]) is not null
AND (INDEXPROPERTY ( si.[object_id], si.[name], 'IsAutoStatistics') = 1 
OR INDEXPROPERTY ( si.[object_id], si.[name], 'IsHypothetical') = 1 
OR INDEXPROPERTY ( si.[object_id], si.[name], 'IsStatistics') = 1)
ORDER BY [Last Stats Update] 
go

/***************** SQL Server Wait Events ********************/
select wt.session_id, wt.exec_context_id, wt.wait_duration_ms, wt.wait_type, wt.blocking_session_id, wt.resource_address, wt.resource_description, s.program_name, st.text, sp.query_plan, s.cpu_time cpu_time_ms, s.memory_usage*8 memory_usage_kb
from sys.dm_os_waiting_tasks wt
	join sys.dm_exec_sessions s on s.session_id=wt.session_id
	join sys.dm_exec_requests r on r.session_id=s.session_id
	outer apply sys.dm_exec_sql_text(r.sql_handle) st
	outer apply sys.dm_exec_query_plan(r.plan_handle) sp
where s.is_user_process=1
order by wt.session_id, wt.exec_context_id;

/***************** Database Size ********************/
DECLARE @startDate datetime;
SET @startDate = GetDate();

SELECT PVT.DatabaseName
, PVT.[0], PVT.[-1], PVT.[-2], PVT.[-3], PVT.[-4], PVT.[-5], PVT.[-6]
, PVT.[-7], PVT.[-8], PVT.[-9], PVT.[-10], PVT.[-11], PVT.[-12]
FROM
(SELECT BS.database_name AS DatabaseName
,DATEDIFF(mm, @startDate, BS.backup_start_date) AS MonthsAgo
,CONVERT(numeric(10, 1), AVG(BF.file_size / 1048576.0)) AS AvgSizeMB
FROM msdb.dbo.backupset as BS
INNER JOIN
msdb.dbo.backupfile AS BF
ON BS.backup_set_id = BF.backup_set_id
WHERE NOT BS.database_name IN
('master', 'msdb', 'model', 'tempdb')
AND BF.[file_type] = 'D'
AND BS.backup_start_date BETWEEN DATEADD(yy, -1, @startDate) AND @startDate
GROUP BY BS.database_name
,DATEDIFF(mm, @startDate, BS.backup_start_date)
) AS BCKSTAT
PIVOT (SUM(BCKSTAT.AvgSizeMB)
FOR BCKSTAT.MonthsAgo IN ([0], [-1], [-2], [-3], [-4], [-5], [-6], [-7], [-8], [-9], [-10], [-11], [-12])
) AS PVT
ORDER BY PVT.DatabaseName;

/***************** Partitioning Check ********************/
select distinct
pp.[object_id],
TbName = OBJECT_NAME(pp.[object_id]), 
index_name = i.[name],
index_type_desc = i.type_desc,
partition_scheme = ps.[name],
data_space_id = ps.data_space_id,
function_name = pf.[name],
function_id = ps.function_id
from sys.partitions pp
inner join sys.indexes i 
on pp.[object_id] = i.[object_id] 
and pp.index_id = i.index_id
inner join sys.data_spaces ds 
on i.data_space_id = ds.data_space_id
inner join sys.partition_schemes ps 
on ds.data_space_id = ps.data_space_id
inner JOIN sys.partition_functions pf 
on ps.function_id = pf.function_id
order by TbName, index_name ;

/***************** Inventory Collection Script ********************/
/* it will make your job very simplify when you connect to any SQL Server database for the first time */

SELECT 
	  serverproperty('MachineName') 'machine_name'
	  ,isnull(serverproperty('InstanceName'),'mssqlserver') 'instance_name'
	  ,@@SERVERNAME 'sql_server_name'
	  ,d.name 'database_name'
	  ,suser_sname(d.owner_sid) 'owner'
	  ,d.compatibility_level
	  ,d.collation_name
	  ,d.is_auto_close_on
	  ,d.is_auto_shrink_on
	  ,d.state_desc
	  ,d.snapshot_isolation_state
	  ,d.is_read_committed_snapshot_on
	  ,d.recovery_model_desc
	  ,d.is_auto_create_stats_on
	  ,d.is_auto_update_stats_on
	  ,d.is_auto_update_stats_async_on
	  ,d.is_in_standby
	  ,d.page_verify_option_desc
	  ,d.log_reuse_wait_desc
	  ,ls.cntr_value as [log size (kb)]
	  ,lu.cntr_value as [log used (kb)]
	  ,lp.cntr_value as [percent log used]
	  ,ds.cntr_value as [data file(s) size (kb)]
	  ,SERVERPROPERTY('productversion') Product_Version 
	  ,SERVERPROPERTY ('edition') 'Edition'
FROM sys.databases d
	 inner join sys.dm_os_performance_counters as lu on lu.instance_name=d.name and lu.counter_name like N'Log File(s) Used Size (KB)%'
	 inner join sys.dm_os_performance_counters as ls on ls.instance_name=d.name and ls.counter_name like N'Log File(s) Size (KB)%' and ls.cntr_value > 0
	 inner join sys.dm_os_performance_counters as lp on lp.instance_name=d.name and lp.counter_name like N'Percent Log Used%'
	 inner join sys.dm_os_performance_counters as ds on ds.instance_name=d.name and ds.counter_name like N'Data File(s) Size (KB)%'
ORDER BY d.name
GO
/*********************************************************************************************/
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO
/*******************************************************/
SET NOCOUNT ON
DECLARE @hr int
DECLARE @fso int
DECLARE @drive char(1)
DECLARE @odrive int
DECLARE @TotalSize varchar(20) DECLARE @MB Numeric ; SET @MB = 1048576

CREATE TABLE #drives (drive char(1) PRIMARY KEY, FreeSpace int NULL,
TotalSize int NULL) INSERT #drives(drive,FreeSpace) EXEC
master.dbo.xp_fixeddrives EXEC @hr=sp_OACreate
'Scripting.FileSystemObject',@fso OUT IF @hr <> 0 EXEC sp_OAGetErrorInfo
@fso

DECLARE dcur CURSOR LOCAL FAST_FORWARD
FOR SELECT drive from #drives ORDER by drive
OPEN dcur FETCH NEXT FROM dcur INTO @drive

WHILE @@FETCH_STATUS=0
BEGIN
EXEC @hr = sp_OAMethod @fso,'GetDrive', @odrive OUT, @drive
IF @hr <> 0 EXEC sp_OAGetErrorInfo @fso EXEC @hr =
sp_OAGetProperty
@odrive,'TotalSize', @TotalSize OUT IF @hr <> 0 EXEC sp_OAGetErrorInfo
@odrive UPDATE #drives SET TotalSize=@TotalSize/@MB WHERE
drive=@drive FETCH NEXT FROM dcur INTO @drive
End
Close dcur
DEALLOCATE dcur

EXEC @hr=sp_OADestroy @fso IF @hr <> 0 EXEC sp_OAGetErrorInfo @fso
/*SELECT @@Servername
SELECT
drive, TotalSize as 'Total(MB)', FreeSpace as 'Free(MB)' FROM #drives
ORDER BY drive*/

CREATE TABLE #CPUInfo
( Logical_CPU_Count bigint,
Hyperthread_Ratio bigint,
Physical_CPU_Count bigint,
Physical_Memory_MB bigint
)

INSERT INTO #CPUInfo(
Logical_CPU_Count,
Hyperthread_Ratio,
Physical_CPU_Count,
Physical_Memory_MB
)
SELECT 
cpu_count AS [Logical_CPU_Count] 
,hyperthread_ratio AS [Hyperthread_Ratio]
,cpu_count/hyperthread_ratio AS [Physical_CPU_Count]
, physical_memory_kb/1024 AS [Physical_Memory_MB]
FROM sys.dm_os_sys_info

CREATE TABLE #DatabaseInfo
( Machine_Name varchar(50),
Instance_Name varchar(50),
Sql_Server_Name varchar(50),
Total_Database_log_size_MB bigint,
Total_Database_log_used_MB bigint,
Total_Database_Data_File_Size_MB bigint
)
INSERT INTO #DatabaseInfo
(
Machine_Name,
Instance_Name,
Sql_Server_Name,
Total_Database_log_size_MB,
Total_Database_log_used_MB,
Total_Database_Data_File_Size_MB
)

select convert(varchar(50),serverproperty('MachineName')) 'Machine_Name'
,convert(varchar(50),isnull(serverproperty('InstanceName'),'mssqlserver')) 'Instance_Name'
,convert(varchar(50),@@SERVERNAME) 'Sql_Server_Name'
,sum(ls.cntr_value/1024) as [Total_Database_log_size_MB]
,sum(lu.cntr_value/1024)as [Total_Database_log_used_MB]
,sum(ds.cntr_value/1024) as [Total_Database_Data_File_Size_MB]
from sys.databases d
left outer join sys.dm_os_performance_counters as lu on lu.instance_name=d.name and lu.counter_name like N'Log File(s) Used Size (KB)%'
left outer join sys.dm_os_performance_counters as ls on ls.instance_name=d.name and ls.counter_name like N'Log File(s) Size (KB)%' and ls.cntr_value > 0
left outer join sys.dm_os_performance_counters as lp on lp.instance_name=d.name and lp.counter_name like N'Percent Log Used%'
left outer join sys.dm_os_performance_counters as ds on ds.instance_name=d.name and ds.counter_name like N'Data File(s) Size (KB)%'
where d.database_id>4; /* system database */

WITH SizeDisc AS
(SELECT SUM(TotalSize) as 'TotalDiscSizeonServer(MB)', 
SUM(FreeSpace) as 'TotalFreeDiscSizeOnServer(MB)' 
FROM #drives
)
SELECT *
FROM #DatabaseInfo,#CPUInfo,SizeDisc

DROP TABLE #Drives 
DROP TABLE #DatabaseInfo
DROP TABLE #CPUInfo 
GO
/*******************************************************/
/* Disabling Ole Automation Procedures */
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 0;
GO
RECONFIGURE;
/*******************************************************/
GO