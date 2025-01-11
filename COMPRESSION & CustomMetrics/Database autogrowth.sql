/*Get the name of the current default trace file*/
DECLARE @filename NVARCHAR(1000)
SELECT @filename = CAST(value AS NVARCHAR(1000))
FROM sys.fn_trace_getinfo(DEFAULT)
WHERE traceid = 1 AND property = 2

/*separate file name into pieces*/
DECLARE @bc INT,
@ec INT,
@bfn VARCHAR(1000),
@efn VARCHAR(10)

SET @filename = REVERSE(@filename)
SET @bc = CHARINDEX('.',@filename)
SET @ec = CHARINDEX('_',@filename)+1
SET @efn = REVERSE(SUBSTRING(@filename,1,@bc))
SET @bfn = REVERSE(SUBSTRING(@filename,@ec,LEN(@filename)))

/*set filename without rollover number*/
SET @filename = @bfn + @efn

/*process all trace files and insert data into DB_AutoGrow_Log*/
SELECT ftg.StartTime,
te.name 'EventName',
DB_NAME(ftg.databaseid) 'DatabaseName',
ftg.[Filename] 'FileName',
(ftg.IntegerData*8)/1024.0 'GrowthMB',
(ftg.duration)/1000000.0 'Duration_Secs'
FROM fn_trace_gettable(@filename, DEFAULT) AS ftg INNER JOIN sys.trace_events AS te ON ftg.EventClass = te.trace_event_id
WHERE (ftg.EventClass = 92 OR ftg.EventClass = 93) -- Date File Auto-grow, Log File Auto-grow
AND DatabaseID = DB_ID()
AND ftg.StartTime > DATEADD(dd, -1, GETDATE())

--Alert name: Database autogrowth
--This alert is raised when the number of autogrowth events that occur on the data file or log file of a database goes above the defined thresholds. 
--Default threshold values: High: 10 
--						    Medium: 5 
--						    Low: 2 