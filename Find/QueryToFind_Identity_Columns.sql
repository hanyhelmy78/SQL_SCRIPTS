select TABLE_NAME, COLUMN_NAME
from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'dbo'
and COLUMNPROPERTY(object_id(TABLE_NAME), COLUMN_NAME, 'IsIdentity') = 1
order by TABLE_NAME

-- to ressed the identity value
--dbcc checkident(table_name,reseed,1);