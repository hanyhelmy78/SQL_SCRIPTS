sp_readerrorlog 0,1,'Copyright (c)'

SELECT sqlserver_start_time FROM sys.dm_os_sys_info

SELECT login_time FROM sys.dm_exec_sessions WHERE session_id = 1

SELECT create_date FROM sys.databases WHERE name = 'tempdb'

SELECT DATEADD(MILLISECOND, -sample_ms, GETDATE()) sqlserver_start_time FROM sys.dm_io_virtual_file_stats (   1,1)