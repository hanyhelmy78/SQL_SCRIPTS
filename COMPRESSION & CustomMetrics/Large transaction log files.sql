DECLARE @Max_log INT; 
SET @Max_log =  10240; -- size of the transaction log in MB 
SELECT  COUNT(*) [Count]
FROM master.sys.master_files 
WHERE type_desc = 'LOG' 
AND (([size] * 8) / 1024) > @Max_log 
AND database_id = DB_ID(); 

--Alert name: Number of transaction log files increased 
--This alert is raised when the number of log files greater than 10 GB (subject to change) goes above the defined thresholds. 
--Default threshold values: High: Disabled 
--						    Medium: 0 
--						    Low: Disabled 