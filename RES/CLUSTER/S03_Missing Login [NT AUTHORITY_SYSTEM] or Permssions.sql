USE [master]
GO
if not exists (select * from sys.syslogins where name = 'NT AUTHORITY\SYSTEM')
begin
CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GRANT ALTER ANY AVAILABILITY GROUP TO [NT AUTHORITY\SYSTEM]
GRANT VIEW SERVER STATE TO [NT AUTHORITY\SYSTEM]
print('Login has been created.')
print('And the right permissions have been granted.')
end
else
if (select count(*) 
from sys.server_permissions
where grantee_principal_id = (
select principal_id from sys.server_principals
where name = 'NT AUTHORITY\SYSTEM')
and [permission_name] in ('CONNECT SQL','ALTER ANY AVAILABILITY GROUP', 'VIEW SERVER STATE')) != 3
begin
GRANT ALTER ANY AVAILABILITY GROUP TO [NT AUTHORITY\SYSTEM]
GRANT VIEW SERVER STATE TO [NT AUTHORITY\SYSTEM]
print('The right permissions have been granted.')
end
else
begin
print('Login and all permissions are already exist')
end


