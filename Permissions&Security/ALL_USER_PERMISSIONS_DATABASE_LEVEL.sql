USE [<db_name];
GO 

SELECT sp.state_desc, sp.permission_name, SCHEMA_NAME(o.schema_id) AS 'Schema', o.name
FROM sys.database_permissions sp
  LEFT JOIN sys.all_objects o
    ON sp.major_id = o.object_id
  JOIN sys.database_principals u
    ON sp.grantee_principal_id = u.principal_id
WHERE u.name = '<login_name>'
  --AND o.name IS NOT NULL
ORDER BY o.name
