SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'Ad Hoc Distributed Queries';
-- Both value columns must show 0
EXECUTE sp_configure 'show advanced options', 1; 
RECONFIGURE; 
EXECUTE sp_configure 'Ad Hoc Distributed Queries', 0; 
RECONFIGURE; 
GO 
EXECUTE sp_configure 'show advanced options', 0; 
RECONFIGURE;
--==========================================================================================
USE [<database_name>] 
GO
SELECT name AS Assembly_Name, permission_set_desc FROM sys.assemblies WHERE is_user_defined = 1; 
GO
SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'clr strict security';

SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'clr enabled';

EXECUTE sp_configure 'clr enabled', 0; 
RECONFIGURE;
--===========================================================================
SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'cross db ownership chaining';

EXECUTE sp_configure 'cross db ownership chaining', 0; 
RECONFIGURE; 
--==========================================================================
SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'Database Mail XPs';

SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'remote access';

SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'Ole Automation Procedures';