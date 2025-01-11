SELECT o.name AS 'Object', u.name AS 'User_or_Role', dp.state_desc, dp.permission_name 
FROM sys.database_permissions AS dp
  JOIN sys.objects AS o
    ON dp.major_id = o.object_id
  JOIN sys.database_principals AS u
    ON dp.grantee_principal_id = u.principal_id
WHERE dp.class = 1
  AND o.name = 'DDLEvents';