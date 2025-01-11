USE master
GO
SELECT @@MAX_CONNECTIONS as [MAX_CONNECTIONS]

SELECT COUNT(1) AS [OPEN_CONNECTIONS] FROM sys.dm_exec_sessions

SELECT 
    COUNT(1) AS [#_OF_CONNECTIONS], 
    COUNT(CASE [status] WHEN 'sleeping' THEN null ELSE 1 END) AS [ACTIVE_CONNECTIONS],
    db_name([dbid]) AS [DATABASE_NAME],
    [HOSTNAME] HOST_NAME, 
    [loginame] LOGIN_NAME,
    [PROGRAM_NAME]
FROM sys.sysprocesses
WHERE [dbid] NOT IN (0)
GROUP BY [hostname], [loginame], [dbid], [program_name]
ORDER BY [#_OF_CONNECTIONS] DESC