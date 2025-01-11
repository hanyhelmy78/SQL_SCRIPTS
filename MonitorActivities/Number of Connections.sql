--Report by connection on your DB Server 
SELECT  DB_NAME(dbid) AS DBName ,
        loginame AS LoginName ,
        hostname ,
		program_name AS Application_Name,
        SPID ,
        status
FROM    sys.sysprocesses
 WHERE DB_NAME(dbid)= 'Bio-core'

 ---Count of Connection on your Db Server

SELECT * FROM sys.dm_exec_connections
SELECT *
FROM sys.dm_os_performance_counters
WHERE counter_name = 'User Connections';

 SELECT 
DB_NAME(dbid) AS DBName ,
 COUNT(dbid) AS NumberOfConnections 
 FROM    sys.sysprocesses
 --WHERE DB_NAME(dbid)= 'Bio-core'
 GROUP BY dbid

---Report by Connection for specific Login
 SELECT  DB_NAME(dbid) AS DBName ,
        loginame AS LoginName ,
        hostname ,
		program_name AS Application_Name,
        SPID ,
        status
FROM    sys.sysprocesses
WHERE   dbid > 0
        AND loginame = 'coreBio';

----Count of Connection for specific Login
SELECT  DB_NAME(dbid) AS DBName ,
        COUNT(dbid) AS NumberOfConnections ,
        loginame AS LoginName ,
        hostname
FROM    sys.sysprocesses
WHERE   dbid > 0
        AND loginame = 'coreBio'
GROUP BY dbid ,
        loginame ,
        hostname;