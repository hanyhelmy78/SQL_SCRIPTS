/************************** Setup the Environment  ***************************
USE [AdventureWorks2012]
GO
IF OBJECT_ID(N'StoredProcedureExceedsDuration') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].[StoredProcedureExceedsDuration]
END
GO
CREATE PROCEDURE [dbo].[StoredProcedureExceedsDuration]
( @WaitForValue varchar(12) = '00:00:00:050')
AS
BEGIN
	SELECT TOP 0 *
	FROM Sales.SalesOrderHeader
	OPTION(RECOMPILE);
	
	WAITFOR DELAY @WaitForValue;
	
	SELECT TOP 0 *
	FROM Sales.SalesOrderHeader
	OPTION(RECOMPILE);
END
GO
******************************************************************************/
/*  Cleanup old files
EXECUTE sp_configure 'show advanced options', 1; RECONFIGURE;
EXECUTE sp_configure 'xp_cmdshell', 1; RECONFIGURE; 
EXEC xp_cmdshell 'DEL C:\Pluralsight\SpStatementTimeouts*';
EXECUTE sp_configure 'xp_cmdshell', 0; RECONFIGURE;
EXECUTE sp_configure 'show advanced options', 0; RECONFIGURE;
*/

IF EXISTS(SELECT * 
		  FROM sys.server_event_sessions 
		  WHERE name='SpStatementTimeouts')
    DROP EVENT SESSION [SpStatementTimeouts] ON SERVER;
GO
-- Create the Event Session
CREATE EVENT SESSION [SpStatementTimeouts]
ON SERVER
ADD EVENT sqlserver.sp_statement_starting
(
	ACTION(sqlserver.session_id, sqlserver.tsql_stack, sqlserver.sql_text, sqlserver.plan_handle)
	-- If we remove the state predicate we'll get invalid unmatched events
	WHERE(state = 0) --Don't fire Recompiled Events
),
ADD EVENT sqlserver.sp_statement_completed
(
	ACTION(sqlserver.session_id, sqlserver.tsql_stack)
)
ADD TARGET package0.pair_matching
(
	SET begin_event = N'sqlserver.sp_statement_starting',
		begin_matching_actions = N'sqlserver.session_id, sqlserver.tsql_stack',
		end_event = N'sqlserver.sp_statement_completed',
		end_matching_actions = N'sqlserver.session_id, sqlserver.tsql_stack',
		respond_to_memory_pressure = 0
),
-- We'll use event_file target to look at all of the events
ADD TARGET event_file(
SET filename=N'C:\Pluralsight\SpStatementTimeouts.xel',
    max_file_size=50,
    max_rollover_files=10,
    increment=5)
WITH(MAX_DISPATCH_LATENCY=1 SECONDS, 
	TRACK_CAUSALITY=ON, 
	STARTUP_STATE = ON);
GO

-- Start the Event Session
ALTER EVENT SESSION [SpStatementTimeouts]
ON SERVER
STATE = START;
GO

-- Run a test workload
/* 
EXECUTE [AdventureWorks2012].[dbo].[StoredProcedureExceedsDuration];
GO 10
EXECUTE [AdventureWorks2012].[dbo].[StoredProcedureExceedsDuration] '00:00:05.000';
GO
EXECUTE [AdventureWorks2012].[dbo].[StoredProcedureExceedsDuration];
GO 10
*/
-- Change connection properties to time out at 2 seconds then rerun the workload
-- Make sure to refresh the target data to show the unpaired event