DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'KILL ' + CONVERT(VARCHAR(11), session_id) + N';'
FROM sys.dm_exec_sessions
WHERE login_name = N''
/*AND last_request_start_time < DATEADD(HOUR, -5, SYSDATETIME())*/;

EXEC sys.sp_executesql @sql;