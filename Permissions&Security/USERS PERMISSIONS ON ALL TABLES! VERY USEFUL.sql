-- query to retrieve tables which a user has access to
select O.name as 'Table', 
	   U.name as 'User', 
	   case P.action when 193 then 'SELECT'
					 when 195 then 'INSERT'
					 when 196 then 'DELETE'
					 when 197 then 'UPDATE'
					 when 224 then 'EXECUTE'
					 else 'Others'
					 end as 'Permission'
from sysprotects P
join sysobjects O on P.id = O.id 
join sysusers U on P.uid = U.uid --and xtype = 'U'
where O.type = 'U' -- D 'DEFAULT CONSTRAINT', F 'FORIEGN KEY', FN 'SCALAR FUNCTION', IF & TF 'TVF', K 'PK', P 'SP', S 'SYSTEM?', SQ 'QUEUE', TR 'TRIGGER', U 'TABLE', V 'VIEW'
  --and p.action in (195,196,197,224) -- FOR DELETE
  AND U.name in ('coreBio','svc_AppDyn_prod')
group by O.name,U.name, P.action
order by O.name

--SELECT name,type FROM SYS.sysobjects GROUP BY type,name