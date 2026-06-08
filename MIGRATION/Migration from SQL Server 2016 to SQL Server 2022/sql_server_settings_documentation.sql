
-- 1. Server Information
SELECT 
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('ServerName') AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('EngineEdition') AS EngineEdition;

-- 2. Configuration Settings
EXEC sp_configure;

-- 3. Trace Flags (Global)
DBCC TRACESTATUS(-1);

-- 4. Linked Servers
SELECT * FROM sys.servers WHERE is_linked = 1;

-- 5. SQL Agent Jobs
SELECT name, enabled, description, date_created, date_modified
FROM msdb.dbo.sysjobs;

-- 6. Logins and Server Roles
SELECT name, type_desc, is_disabled, default_database_name
FROM sys.server_principals
WHERE type IN ('S', 'U', 'G');

-- 7. Server Role Memberships
SELECT 
    r.name AS RoleName,
    m.name AS MemberName
FROM sys.server_role_members rm
JOIN sys.server_principals r ON rm.role_principal_id = r.principal_id
JOIN sys.server_principals m ON rm.member_principal_id = m.principal_id;

-- 8. Database Settings
SELECT 
    name AS DatabaseName,
    state_desc,
    recovery_model_desc,
    compatibility_level,
    is_auto_close_on,
    is_auto_shrink_on,
    is_auto_create_stats_on,
    is_auto_update_stats_on,
    is_read_committed_snapshot_on
FROM sys.databases;

-- 9. Database File Info
SELECT 
    DB_NAME(database_id) AS DatabaseName,
    name AS LogicalName,
    physical_name,
    type_desc,
    size * 8 / 1024 AS SizeMB
FROM sys.master_files;

-- 10. SQL Server Agent Operators
SELECT name, email_address, enabled
FROM msdb.dbo.sysoperators;

-- 11. SQL Server Agent Alerts
SELECT name, message_id, severity, enabled
FROM msdb.dbo.sysalerts;

-- 12. Endpoints
SELECT name, type_desc, state_desc, protocol_desc
FROM sys.endpoints;

-- 13. Credentials
SELECT name, credential_identity
FROM sys.credentials;

-- 14. Server Audit Specifications
SELECT name, is_state_enabled
FROM sys.server_audit_specifications;

-- 15. Resource Governor Configuration
SELECT * FROM sys.resource_governor_configuration;
