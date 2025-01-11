select 'ANSI PADDING OFF' as setting
     , o.name as object_name
     , o.type_desc as object_type
     , c.name as column_name
     , usrt.name column_data_type
from sys.columns c inner join sys.objects o
ON o.object_id = c.object_id
LEFT OUTER JOIN sys.types AS usrt ON usrt.user_type_id = c.user_type_id
where o.is_ms_shipped <> 1
      and 
     usrt.name IN ('char','varchar','binary','varbinary')
     and
     is_ansi_padded <> 1
order by o.name, c.name

select 'ANSI NULLS OFF' as setting
     , o.name as object_name
     , o.type_desc as object_type 
     , NULL as column_name
     , NULL as column_data_type
from sys.objects o
where is_ms_shipped <> 1
and OBJECTPROPERTY (object_id, 'isAnsiNullsOn') = 0
order by o.name

select COUNT(*)
from sys.dm_exec_sessions
where is_user_process = 1
and (ansi_padding <> 1 OR ansi_nulls <> 1 OR concat_null_yields_null <> 1)