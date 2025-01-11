DECLARE @trcpath nvarchar(256)

SELECT @trcpath=CAST(value as nvarchar(256)) 
FROM fn_trace_getinfo(default) 
WHERE property = 2

SELECT * 
FROM fn_trace_gettable (@trcpath,default) 
WHERE  EventClass= 20 
ORDER BY starttime DESC -- Change "default" to 1 if you want to read information only from current trace file
