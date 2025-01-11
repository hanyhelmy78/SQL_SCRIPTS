use HISGENX -- db_name 
go
EXEC sys.sp_cdc_enable_db
EXEC sys.sp_cdc_disable_db
EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo',
	@source_name   = N'HIS_InvoiceMain',
	@role_name     = N'public',
	@supports_net_changes = 1
GO

-- to query the Metadata and configuration for CDC
select * from cdc.change_tables, cdc.index_columns, cdc.captured_columns
exec sys.sp_cdc_help_change_data_capture

-- function to query all changes: fn_cdc_get_all_changes_SchemaName_TableName
select * from cdc.fn_cdc_get_all_changes_dbo_Emp(@from_lsn,@to_lsn,'all')

-- system table to query the DML changes on a table(schema_name(cdc).instance_name_CT)
select *, case when __$operation = 1 then 'Deleted'
			   when __$operation = 2 then 'Inserted'
			   when __$operation = 3 then 'Updated before image'
			   when __$operation = 4 then 'Updated after image' end as 'ChangeType'
from cdc.dbo_Emp_CT

-- to query which database is_cdc_enabled
select * from sys.databases -- or sys.tables
where is_cdc_enabled = 1