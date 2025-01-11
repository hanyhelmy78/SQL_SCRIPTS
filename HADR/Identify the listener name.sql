SELECT AV.name AS AVGName
, AVGLis.dns_name AS ListenerName
, AVGLis.ip_configuration_string_from_cluster AS ListenerIP
FROM sys.availability_group_listeners AVGLis
INNER JOIN sys.availability_groups AV on AV.group_id = AV.group_id