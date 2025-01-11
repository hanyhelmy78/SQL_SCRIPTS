select i.name,i.object_id, o.create_date, o.object_id, o.name
from sys.indexes i 
join sys.objects o on i.object_id=o.object_id 
where i.name='Index_Name'