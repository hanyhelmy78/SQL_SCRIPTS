 /*Memory Clerk Usage for instance
 Look for high value for CACHESTORE_SQLCP (Ad-hoc query plans)*/
 SELECT TOP(10) mc.[type] AS [Memory Clerk Type], 
        CAST((SUM(mc.pages_kb)/1024.0) AS DECIMAL (15,2)) AS [Memory Usage (MB)] 
 FROM sys.dm_os_memory_clerks AS mc WITH (NOLOCK)
 GROUP BY mc.[type]  
 ORDER BY SUM(mc.pages_kb) DESC OPTION (RECOMPILE);
   
 /* MEMORYCLERK_SQLBUFFERPOOL was new for SQL Server 2012. It should be your highest consumer of memory
  CACHESTORE_SQLCP  SQL Plans         
  These are cached SQL statements or batches that aren't in stored procedures, functions and triggers
  Watch out for high values for CACHESTORE_SQLCP
  CACHESTORE_OBJCP  Object Plans      
  These are compiled plans for stored procedures, functions and triggers*/