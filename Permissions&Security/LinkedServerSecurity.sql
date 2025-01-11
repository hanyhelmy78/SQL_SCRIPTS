/*
the one result you should really pay attention to is if there is no local name but there is a remote name – that means the ‘Be made using this security context’  option was selected and every user can run queries against the linked server with the permissions of the remote login
*/
SELECT 
    s.name AS LinkedServerName,
    s.data_source AS DataSource,
    SUSER_NAME(l.local_principal_id) as local_mapped_user_name,
    l.uses_self_credential AS uses_current_login_credential,
    l.remote_name AS remote_login_name
FROM 
    sys.servers s
LEFT JOIN 
    sys.linked_logins l ON l.server_id = s.server_id
WHERE is_linked = 1