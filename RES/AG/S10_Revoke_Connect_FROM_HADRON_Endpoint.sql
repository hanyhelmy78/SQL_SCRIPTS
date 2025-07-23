-- Take the permission_script column and execute it into the missing replica.

:CONNECT MSSQLSERVERVM02 
use master
go
select ep.endpoint_id, ep.name, ep.state_desc, sp.class_desc, sp.grantee_principal_id, spr.name, l.sysadmin, 
sp.permission_name, sp.state_desc, ep.protocol_desc,
sp.state_desc+' '+[permission_name]+' ON '+class_desc+'::['+ep.name+'] TO [' collate Latin1_General_CI_AS+spr.name+']' permission_script
from sys.endpoints ep inner join sys.server_permissions sp
on ep.endpoint_id = sp.major_id
inner join sys.server_principals spr
on spr.principal_id = sp.grantee_principal_id
inner join sys.syslogins l
on spr.name = l.name
where ep.endpoint_id > 5
go