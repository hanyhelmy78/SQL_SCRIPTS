 select case when ses.session_id= @@SPID
       then 'It''s me! '   else '' end
        + coalesce(ses.login_name,'???') as WhosGotTheDAC,
    ses.session_id, ses.login_time,
    ses.status, ses.original_login_name
from sys.endpoints as en
join sys.dm_exec_sessions ses on
    en.endpoint_id=ses.endpoint_id

where en.name='Dedicated Admin Connection'