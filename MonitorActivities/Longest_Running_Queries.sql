SELECT 
DB_NAME(er.[database_id]) [DatabaseName]
,er.[session_id] AS [SessionID]
,er.[command] AS [CommandType]
,est.[text] [StatementText]
,er.[status] AS [Status]
,CONVERT(DECIMAL(5, 2), er.[percent_complete]) AS [Complete_Percent]
,CONVERT(DECIMAL(38, 2), er.[total_elapsed_time] / 60000.00) AS [ElapsedTime_m]
,CONVERT(DECIMAL(38, 2), er.[estimated_completion_time] / 60000.00) AS [EstimatedCompletionTime_m]
,er.[last_wait_type] [LastWait]
,er.[wait_resource] [CurrentWait]
FROM sys.dm_exec_requests AS er 
INNER JOIN sys.dm_exec_sessions AS es ON er.[session_id] = es.[session_id]
CROSS APPLY sys.dm_exec_sql_text(er.[sql_handle]) est
ORDER BY ElapsedTime_m DESC

--EXEC SP_WHO2 -- sp_WhoIsActive