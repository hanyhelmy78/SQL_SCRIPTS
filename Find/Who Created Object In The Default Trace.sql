SELECT 
     loginname,
     loginsid,
     spid,
     hostname,
     applicationname,
     servername,
     databasename,
     objectName,
     e.category_id,
     cat.name as [CategoryName],
     textdata,
     starttime,
     eventclass,
     eventsubclass,--0=begin,1=commit
     e.name as EventName
FROM ::fn_trace_gettable('S:\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Log\log_10167.trc',0)
     INNER JOIN sys.trace_events e
          ON eventclass = trace_event_id
     INNER JOIN sys.trace_categories AS cat
          ON e.category_id = cat.category_id
WHERE databasename = 'PEPSI' AND
      objectname LIKE '%User_Truck%' --IS NOT NULL AND --filter by objectname
ORDER BY StartTime DESC     
	  --e.category_id = 5 AND --category 5 is objects
      --e.trace_event_id = 46 
      --trace_event_id: 46=Create Obj,47=Drop Obj,164=Alter Obj