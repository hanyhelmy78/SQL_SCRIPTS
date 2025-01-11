DECLARE @endtime DATETIME; 
SET @endtime = GETDATE(); 
DECLARE @starttime DATETIME; 
SET @starttime = DATEADD(hh, -1, @endtime); 

IF OBJECT_ID('tempdb..#LogEntries') IS NOT NULL 
   DROP TABLE #LogEntries; 

CREATE TABLE #LogEntries 
    (LogDate DATETIME , 
	 ProcessInfo VARCHAR(1000) , 
	 LogMessage TEXT); 

INSERT INTO #LogEntries 
       EXEC sys.xp_readerrorlog 0, 1, N'Login', N'failed', @starttime, @endtime; 

SELECT  COUNT(*) 
FROM    #LogEntries; 

DROP TABLE #LogEntries; 

--Alert name: Failed SQL Server logins
--This alert is raised when SQL Monitor detects one or more failed SQL Server logins in the last hour. 
--Default threshold values: High: 1 
--						    Medium: Disabled 
--						    Low: Disabled 