-- create result holder 
DECLARE @result TABLE 
    ([Database_Name] VARCHAR(150) , 
     [Log_Size] FLOAT , 
	 [Log_Space] FLOAT , 
	 [Status] VARCHAR(100))  

INSERT INTO @result 
       EXEC ('DBCC sqlperf(LOGSPACE) WITH NO_INFOMSGS') 
-- only return for the DB in context, rounding it  
SELECT ROUND([Log_Space], 2) 'Used_Log_Space_%'
FROM   @result 
WHERE  [Database_Name] = DB_NAME() 

/* Alert name: Free log space decreased 
This alert is raised when the percentage of used space in the log transaction files (LDF) exceeds the specified thresholds. 
Default threshold values for user databases: 
High: 90 
Medium: 80 */