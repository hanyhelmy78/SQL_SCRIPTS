USE [master];
GO 
-- SELECT * FROM ExportLoginQueries <---------------- ******************

SET ANSI_NULLS ON;
GO 
SET QUOTED_IDENTIFIER ON;
GO 
IF OBJECT_ID('dbo.ExportLoginQueries', 'V') IS NULL
BEGIN
    EXEC ('CREATE VIEW dbo.ExportLoginQueries AS SELECT 1 AS [one]');
END;
GO
 
ALTER VIEW [dbo].[ExportLoginQueries]
AS
    WITH
    RoleMembers AS
    (
        SELECT          srm.*,
                        r.name AS RoleName,
                        m.name AS MemberName
        FROM
                        sys.server_role_members srm
            INNER JOIN  sys.server_principals   r
                        ON srm.role_principal_id = r.principal_id
            INNER JOIN  sys.server_principals   m
                        ON srm.member_principal_id = m.principal_id
    )
    SELECT  3                                                                                                 AS Ord,
            N'IF EXISTS (SELECT * FROM sys.server_principals WHERE name = ' + QUOTENAME(MemberName, '''')
            + N') BEGIN ALTER SERVER ROLE ' + RoleName + N' ADD MEMBER ' + +QUOTENAME(MemberName) + N'; END;' AS SQLQuery
    FROM    RoleMembers
    WHERE
            RoleMembers.member_principal_id IN
            (
                SELECT  principal_id
                FROM    sys.server_principals
                WHERE
                        type IN ('U', 'S')
                        AND name NOT LIKE 'NT %'
                        AND name NOT LIKE 'sa'
                        AND name NOT LIKE '##%'
            )
    UNION ALL
    SELECT  1                                                                                                AS Ord,
            N'IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ' + QUOTENAME(name, '''')
            + N') BEGIN CREATE LOGIN ' + QUOTENAME(name) + N' FROM WINDOWS WITH DEFAULT_LANGUAGE = '
            + default_language_name + N', DEFAULT_DATABASE = ' + QUOTENAME(default_database_name) + N' END;' AS SQLQuery
    FROM    sys.server_principals
    WHERE
            type = 'U'
            AND name NOT LIKE 'NT %'
    UNION ALL
    SELECT          2           AS Ord,
                    N'IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ' + QUOTENAME(sl.name, '''')
                    + N') BEGIN CREATE LOGIN ' + QUOTENAME(sl.name) + N' WITH PASSWORD = '
                    + CAST(CONVERT(VARCHAR(256), CAST(LOGINPROPERTY(sl.name, 'PasswordHash') AS VARBINARY(256)), 1) AS NVARCHAR(MAX))
                    + ' HASHED' + N', SID=' + CONVERT(VARCHAR(256), sl.sid, 1) + N', DEFAULT_LANGUAGE = '
                    + sl.default_language_name + N', DEFAULT_DATABASE = ' + QUOTENAME(sl.default_database_name)
                    + N', CHECK_EXPIRATION = ' + CASE sl.is_expiration_checked
                                                     WHEN 1 THEN
                                                         N'ON'
                                                 ELSE
                                                     N'OFF'
                                                 END
                    + N', CHECK_POLICY = ' + CASE sl.is_policy_checked
                                                 WHEN 1 THEN
                                                     N'ON'
                                             ELSE
                                                 N'OFF'
                                             END
                    + N'; END;' AS SQLQuery
    FROM
                    sys.sql_logins        sl
    WHERE
                    sl.name NOT LIKE '##%'
                    AND sl.name <> 'sa';
GO