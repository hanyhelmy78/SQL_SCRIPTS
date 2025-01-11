select DB_NAME() [database], name as [user_name], type_desc,default_schema_name,create_date,modify_date 
from sys.database_principals 
where type in ('G','S','U') 
and authentication_type <> 2 -- Use this filter only if you are running on SQL Server 2012 and major versions and you have "contained databases"
and [sid] not in (select [sid] 
				  from sys.server_principals 
				  where type in ('G','S','U') ) 
and name not in ('dbo','guest','INFORMATION_SCHEMA','sys','MS_DataCollectorInternalUser')

-- http://www.mssqltips.com/sqlservertip/3439/script-to-drop-all-orphaned-sql-server-database-users/?utm_source=dailynewsletter&utm_medium=email&utm_content=text&utm_campaign=20141211
-- IF IN CASE U FOUND ANY ORPHAN USER THAT NEEDS 2 B DELETED; GO THE ABOVE LINK, AND TEST THE SCRIPT