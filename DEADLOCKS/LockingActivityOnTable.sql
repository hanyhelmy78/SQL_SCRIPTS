/* THIS QUERY gives a complete picture of the activity with locks on the table so we can determine where conflicts are occurring and which procedures and 
queries (IN RUNNING STATUS) are causing blocking of other queries and procedures (IN SUSPENDED STATUS).
*/
-- Define the table you want to search
Declare @TableName nvarchar(257);
Set @TableName = N'HIS_Patient'; --  HIS_InvoiceDetailMain SCM_INB_Inventory
-- Take a snapshot of locking activity on table
Select TableName = @TableName,
SessionID = R.session_id,
BlockingSessionID = R.blocking_session_id,
LockMode = TL.request_mode,
LockStatus = TL.request_status,
Command = R.command,
QueryStatus = R.status,
CurrentWait = R.wait_type,
LastWait = R.last_wait_type,
WaitResource = R.wait_resource,
WaitTime = R.wait_time,
ProcedureName = IsNull(OBJECT_NAME(ST.objectid), '** adhoc **'),
SQLText = SUBSTRING(ST.text, (R.statement_start_offset/2)+1,
((Case R.statement_end_offset
When -1 Then DATALENGTH(ST.text)
Else R.statement_end_offset
End - R.statement_start_offset)/2) + 1),
QueryPlan = Q.query_plan
From sys.dm_tran_locks TL
Inner Join sys.dm_exec_requests R On R.session_id = TL.request_session_id
Outer Apply sys.dm_exec_sql_text(R.sql_handle) As ST
Outer Apply sys.dm_exec_query_plan(R.plan_handle) As Q
Where TL.resource_type In ('page', 'key', 'RID', 'object')
And OBJECT_ID(@TableName) = Case
When resource_type = 'object'
Then resource_associated_entity_id
When resource_type In ('page', 'key', 'RID')
Then (Select top (1) object_id
From sys.partitions
Where partition_id = resource_associated_entity_id
And index_id in (0, 1))
End
And TL.resource_database_id = DB_ID()
Order By R.session_id;

--KILL 90