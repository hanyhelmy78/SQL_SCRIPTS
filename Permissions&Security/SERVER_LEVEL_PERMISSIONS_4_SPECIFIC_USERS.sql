SELECT sp.state_desc, sp.permission_name, sp.class_desc, sp.major_id, sp.minor_id, e.name
FROM sys.server_permissions AS sp
  JOIN sys.server_principals AS l
    ON sp.grantee_principal_id = l.principal_id
  LEFT JOIN sys.endpoints AS e
    ON sp.major_id = e.endpoint_id
WHERE l.name = 'coreBio';