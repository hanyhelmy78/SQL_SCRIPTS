SELECT SUSER_SNAME(owner_sid) AS DBOWNER, d.name AS DATABASENAME 
FROM sys.server_principals r INNER JOIN sys.server_role_members m 
ON r.principal_id = m.role_principal_id INNER JOIN sys.server_principals p 
ON p.principal_id = m.member_principal_id inner join sys.databases d 
ON suser_sname(d.owner_sid) = p.name 
WHERE is_trustworthy_on = 1 AND d.name NOT IN ('MSDB') and r.type = 'R' and r.name = N'sysadmin'

--By default, this setting is set to OFF, MS recommends that we leave this setting set to OFF to mitigate certain threats that may be present when a database is attached to the server.