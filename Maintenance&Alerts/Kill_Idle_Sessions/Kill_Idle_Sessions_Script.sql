/*
'* File:          KillIdleSession.sql
'* Created Date:  2013/03/18
'* Modified Date: 2013/03/18
'* Author         : Ray Yen
'*
'* Version        :   1.0
'*
'* Main Function: Kill SQL Server connection which was a idle session (just awaiting command and last_batch exceed a period of time)
'*
'* Important : Please DO NOT run this script without troushooting SQL server performance related steps.
'* For exmaple, please check total session count, top expensive query, wait status information, DMV for checking high CPU, excessive disk I/O, memory comsumers.
'*
'* Copyright (C) 2013 Microsoft Corporation
*/
 
SET NOCOUNT ON
 
DECLARE @IDLE_TIME DATETIME
DECLARE @LAST_BATCH DATETIME
 
DECLARE @nKillProcess INT
DECLARE @nFetchStatus INT
DECLARE @sTemp VARCHAR(30)
 
--Please set the idle time (Hours:Minutes:Seconds)
SET @IDLE_TIME = '00:05:00'
 
--CREATE TEMP TABLE FOR STORE SESSION DATA
IF OBJECT_ID('tempdb.dbo.#SESSION_TEMP_RECORD', 'U') IS NOT NULL
  DROP TABLE #SESSION_TEMP_RECORD; 

CREATE TABLE #SESSION_TEMP_RECORD
(
spid smallint,
last_batch datetime,
kpid smallint,
[status] nchar(60),
waittype binary,
waittime bigint,
lastwaittype nchar(64),
[dbid] smallint,
cmd  nchar(32),
hostname nchar(256),
loginame nchar(256),
IDLE_TIME_TARGET DATETIME
)
 
--SELECT CURRENT SESSION RECORDS WHICH MEETS REQUIREMENTS
INSERT INTO #SESSION_TEMP_RECORD(spid,last_batch,kpid,[status],waittype,waittime,lastwaittype,[dbid],cmd,hostname,loginame)
SELECT
spid,last_batch,kpid,status,waittype,waittime,lastwaittype,dbid,cmd,hostname,loginame
from sys.sysprocesses
WHERE status IN ('sleeping')
and cmd IN ('AWAITING COMMAND')
and kpid = 0 -- Not processing now, > 1 means this session own at least a SQL Server thread
AND spid > 50
and DB_NAME(dbid) NOT IN ('master','tempdb','model','msdb','distribution') -- You could add database name which you want to exclude
--and hostname IN ('host1','host2')                            -- You could add host name which you want to exclude
and open_tran = 1                                          -- open_tran > 0 means there are some transaction still active
 
--Update IDLE_TIME_TARGET column and get the idle time target
UPDATE #SESSION_TEMP_RECORD
SET IDLE_TIME_TARGET = GETDATE()-@IDLE_TIME
 
--SELECT * FROM #SESSION_TEMP_RECORD WHERE last_batch < IDLE_TIME_TARGET
 
DECLARE curProcesses CURSOR
    LOCAL
    FAST_FORWARD
    READ_ONLY
FOR
     SELECT spid
     FROM #SESSION_TEMP_RECORD
     WHERE last_batch < IDLE_TIME_TARGET
 
OPEN curProcesses
 
FETCH NEXT FROM curProcesses INTO -- Get the first process
@nKillProcess
 
SET @nFetchStatus = @@FETCH_STATUS
 
--Kill the processes
WHILE @nFetchStatus = 0
     BEGIN
           SET @sTemp ='KILL ' + CAST(@nKillProcess as varchar(5))
           PRINT @sTemp
           EXEC(@sTemp)
           FETCH NEXT FROM curProcesses INTO --Gets the next process
                 @nKillProcess
           SET @nFetchStatus = @@FETCH_STATUS
     END
 
CLOSE curProcesses
DEALLOCATE curProcesses