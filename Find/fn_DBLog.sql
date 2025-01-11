select 'Total', count(*) as Count
from fn_dblog(null,null)
union all 
select operation, count(*) as Count
from fn_dblog(null,null)
group by operation
order by count desc

select SUSER_SNAME([Transaction SID]) UserName, * 
from fn_dblog(null,null)