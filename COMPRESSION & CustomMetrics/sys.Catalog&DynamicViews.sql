-- to detemine which members assigned to which roles
select * from sys.database_role_members
select * from sys.database_mirroring
-- info about db tran locks
select * from sys.dm_tran_locks
exec sp_dbmmonitorresults 'AdventureWorks2008R2'
-- last successful login time and last unsuccessful login
select * from sys.dm_exec_sessions
-- info 4 disabled logins
select * from sys.sql_logins
select * from sys.server_event_session_events --sessions
select * from sys.database_permissions where grantee_principal_id = 7
select * from sys.server_permissions where grantee_principal_id = 287
select * from sys.certificates
-- when the db user was last modified
select * from sys.database_principals order by modify_date desc
-- to update statistics for all tables
exec sp_updatestats
exec sp_cycle_agent_errorlog
exec sp_cycle_errorlog
-- to know when was the index last used		
select * from sys.dm_db_index_usage_stats
select * from sys.dm_db_missing_index_details
select * from sys.certificates
select * from sys.key_encryptions
--	info 4 disabled server principals
select * from sys.server_principals
select * from sys.server_role_members
-- to view if a process is being blocked
select * from sys.dm_exec_requests
-- to examine the index size
exec sp_spaceused [Person.Person]
-- to display all databases options
select * from sys.databases 
-- to address the top 10 queries
select * from sys.dm_exec_query_stats order by max_physical_reads DESC
-- to discover system session waits
SELECT * FROM sys.dm_os_waiting_tasks ORDER BY wait_duration_ms DESC --WHERE wait_type LIKE '%latch%'
-- 2 RETRIEVE THE SQL SERVER SERVICE NAME
select * from sys.dm_server_services
-- sys.dm_os_wait_stats
SELECT * FROM sys.dm_os_wait_stats ORDER BY wait_time_ms DESC
SELECT * FROM sys.dm_os_spinlock_stats ORDER BY spins DESC