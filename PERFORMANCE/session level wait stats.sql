SELECT
    desws.*
FROM sys.dm_exec_session_wait_stats AS desws
WHERE desws.session_id = @@SPID
ORDER BY desws.wait_time_ms DESC;