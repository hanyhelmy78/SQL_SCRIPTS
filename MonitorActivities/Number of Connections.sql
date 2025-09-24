/* The summary report */

SELECT 
DB_NAME(dbid) AS DBName ,
COUNT(dbid) AS NumberOfConnections 
FROM    sys.sysprocesses
-- WHERE DB_NAME(dbid)= 'master'
GROUP BY dbid

-- All connections for specific DB 
SELECT  DB_NAME(dbid) AS DBName ,
        loginame AS LoginName ,
        hostname ,
		program_name AS Application_Name,
        SPID ,
        status
FROM    sys.sysprocesses
WHERE DB_NAME(dbid)= 'master'

-- Count of connections on your DB Server

SELECT * FROM sys.dm_exec_connections
SELECT *
FROM sys.dm_os_performance_counters
WHERE counter_name = 'User Connections';

-- Report for connections for a specific Login

 SELECT  DB_NAME(dbid) AS DBName ,
        loginame AS LoginName ,
        hostname ,
		program_name AS Application_Name,
        SPID ,
        status
FROM    sys.sysprocesses
WHERE   dbid > 0
        AND loginame = '<LOGIN_NAME>';

-- Count of connections for specific Login

SELECT  DB_NAME(dbid) AS DBName ,
        COUNT(dbid) AS NumberOfConnections ,
        loginame AS LoginName ,
        hostname
FROM    sys.sysprocesses
WHERE   dbid > 0
        AND loginame = '<LOGIN_NAME>'
GROUP BY dbid ,
        loginame ,
        hostname;
