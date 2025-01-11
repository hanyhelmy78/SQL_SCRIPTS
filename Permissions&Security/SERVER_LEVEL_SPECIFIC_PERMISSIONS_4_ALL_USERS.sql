SELECT 
 who.name AS [Principal Name],
 who.type_desc AS [Principal Type],
 who.is_disabled AS [Principal Is Disabled],
 what.state_desc AS [Permission State],
 what.permission_name AS [Permission Name]
FROM 
 sys.server_permissions what 
 INNER JOIN sys.server_principals who
 ON who.principal_id = what.grantee_principal_id
WHERE
 what.permission_name = 'VIEW SERVER STATE'
AND who.name NOT LIKE '##MS%##'
--AND who.type_desc <> 'SERVER_ROLE'
ORDER BY
 who.name
;
GO