select name, protocol_desc, type_desc, state_desc,
case state_desc when 'STOPPED' then 'ALTER ENDPOINT ['+name+'] STATE=STARTED' else NULL end
check_endpoint
from sys.endpoints
where endpoint_id > 10000
go
