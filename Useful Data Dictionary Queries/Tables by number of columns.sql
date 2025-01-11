select schema_name(tab.schema_id) as schema_name, 
       tab.name as table_name, 
       count(*) as columns
  from sys.tables as tab
       inner join sys.columns as col
           on tab.object_id = col.object_id 
 group by schema_name(tab.schema_id), 
       tab.name
 order by count(*) desc;