/****** Scripting replication configuration. Script Date: 29/08/2012 6:18:38 PM ******/
/****** Please Note: For security reasons, all password parameters were scripted with either NULL or an empty string. ******/

/****** Installing the server as a Distributor. Script Date: 29/08/2012 6:18:38 PM ******/
use master
exec sp_adddistributor @distributor = N'HANY_ISD', @password = N''
GO
exec sp_adddistributiondb @database = N'distribution', @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Data', @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Data', @log_file_size = 2, @min_distretention = 0, @max_distretention = 72, @history_retention = 48, @security_mode = 1
GO

use [distribution] 
if (not exists (select * from sysobjects where name = 'UIProperties' and type = 'U ')) 
	create table UIProperties(id int) 
if (exists (select * from ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', null, null))) 
	EXEC sp_updateextendedproperty N'SnapshotFolder', N'\\Hany_ISD\Replication', 'user', dbo, 'table', 'UIProperties' 
else 
	EXEC sp_addextendedproperty N'SnapshotFolder', N'\\Hany_ISD\Replication', 'user', dbo, 'table', 'UIProperties'
GO

exec sp_adddistpublisher @publisher = N'HANY_ISD', @distribution_db = N'distribution', @security_mode = 1, @working_directory = N'\\Hany_ISD\Replication', @trusted = N'false', @thirdparty_flag = 0, @publisher_type = N'MSSQLSERVER'
GO

use [AdventureWorks2008R2]
exec sp_replicationdboption @dbname = N'AdventureWorks2008R2', @optname = N'publish', @value = N'true'
GO
-- Adding the snapshot publication
use [AdventureWorks2008R2]
exec sp_addpublication @publication = N'NewPublication', @description = N'Snapshot publication of database ''AdventureWorks2008R2'' from Publisher ''HANY_ISD''.', @sync_method = N'native', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'snapshot', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1
GO


exec sp_addpublication_snapshot @publication = N'NewPublication', @frequency_type = 4, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 8, @frequency_subday_interval = 1, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = N'Hany_ISD\hany-isd', @job_password = null, @publisher_security_mode = 1


use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Address', @source_owner = N'Person', @source_object = N'Address', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Address', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'AddressType', @source_owner = N'Person', @source_object = N'AddressType', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'AddressType', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'author', @source_owner = N'dbo', @source_object = N'author', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'author', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'AWBuildVersion', @source_owner = N'dbo', @source_object = N'AWBuildVersion', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'AWBuildVersion', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'BillOfMaterials', @source_owner = N'Production', @source_object = N'BillOfMaterials', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'BillOfMaterials', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'blogentry', @source_owner = N'dbo', @source_object = N'blogentry', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'blogentry', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'BusinessEntity', @source_owner = N'Person', @source_object = N'BusinessEntity', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'BusinessEntity', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'BusinessEntityAddress', @source_owner = N'Person', @source_object = N'BusinessEntityAddress', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'BusinessEntityAddress', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'BusinessEntityContact', @source_owner = N'Person', @source_object = N'BusinessEntityContact', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'BusinessEntityContact', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'companies', @source_owner = N'dbo', @source_object = N'companies', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'companies', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ContactType', @source_owner = N'Person', @source_object = N'ContactType', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ContactType', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'CountryRegion', @source_owner = N'Person', @source_object = N'CountryRegion', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'CountryRegion', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'CountryRegionCurrency', @source_owner = N'Sales', @source_object = N'CountryRegionCurrency', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'CountryRegionCurrency', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'CreditCard', @source_owner = N'Sales', @source_object = N'CreditCard', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'CreditCard', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Culture', @source_owner = N'Production', @source_object = N'Culture', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Culture', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Currency', @source_owner = N'Sales', @source_object = N'Currency', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Currency', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'CurrencyRate', @source_owner = N'Sales', @source_object = N'CurrencyRate', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'CurrencyRate', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'cust', @source_owner = N'dbo', @source_object = N'cust', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'cust', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Customer', @source_owner = N'Sales', @source_object = N'Customer', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Customer', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Customers', @source_owner = N'Sales', @source_object = N'Customers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Customers', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'DatabaseLog', @source_owner = N'dbo', @source_object = N'DatabaseLog', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'DatabaseLog', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Department', @source_owner = N'HumanResources', @source_object = N'Department', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Department', @destination_owner = N'HumanResources', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Details', @source_owner = N'Sales', @source_object = N'Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Details', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Document', @source_owner = N'Production', @source_object = N'Document', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Document', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'EmailAddress', @source_owner = N'Person', @source_object = N'EmailAddress', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'EmailAddress', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Employee', @source_owner = N'HumanResources', @source_object = N'Employee', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Employee', @destination_owner = N'HumanResources', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'EmployeeDepartmentHistory', @source_owner = N'HumanResources', @source_object = N'EmployeeDepartmentHistory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'EmployeeDepartmentHistory', @destination_owner = N'HumanResources', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'EmployeePayHistory', @source_owner = N'HumanResources', @source_object = N'EmployeePayHistory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'EmployeePayHistory', @destination_owner = N'HumanResources', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ErrorLog', @source_owner = N'dbo', @source_object = N'ErrorLog', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ErrorLog', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Illustration', @source_owner = N'Production', @source_object = N'Illustration', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Illustration', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'inventory', @source_owner = N'dbo', @source_object = N'inventory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'inventory', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'JobCandidate', @source_owner = N'HumanResources', @source_object = N'JobCandidate', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'JobCandidate', @destination_owner = N'HumanResources', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Location', @source_owner = N'Production', @source_object = N'Location', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Location', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'OrderDetails', @source_owner = N'Sales', @source_object = N'OrderDetails', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'OrderDetails', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Orders', @source_owner = N'Sales', @source_object = N'Orders', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Orders', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Password', @source_owner = N'Person', @source_object = N'Password', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Password', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Person', @source_owner = N'Person', @source_object = N'Person', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Person', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'PersonCreditCard', @source_owner = N'Sales', @source_object = N'PersonCreditCard', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'PersonCreditCard', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'PersonPhone', @source_owner = N'Person', @source_object = N'PersonPhone', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'PersonPhone', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'PhoneNumberType', @source_owner = N'Person', @source_object = N'PhoneNumberType', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'PhoneNumberType', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Product', @source_owner = N'Production', @source_object = N'Product', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Product', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductCatalog', @source_owner = N'Sales', @source_object = N'ProductCatalog', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductCatalog', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductCategory', @source_owner = N'Production', @source_object = N'ProductCategory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductCategory', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductCostHistory', @source_owner = N'Production', @source_object = N'ProductCostHistory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductCostHistory', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductDescription', @source_owner = N'Production', @source_object = N'ProductDescription', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductDescription', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductDocument', @source_owner = N'Production', @source_object = N'ProductDocument', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductDocument', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductInventory', @source_owner = N'Production', @source_object = N'ProductInventory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductInventory', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductListPriceHistory', @source_owner = N'Production', @source_object = N'ProductListPriceHistory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductListPriceHistory', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductModel', @source_owner = N'Production', @source_object = N'ProductModel', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductModel', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductModelIllustration', @source_owner = N'Production', @source_object = N'ProductModelIllustration', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductModelIllustration', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductModelProductDescriptionCulture', @source_owner = N'Production', @source_object = N'ProductModelProductDescriptionCulture', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductModelProductDescriptionCulture', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductPhoto', @source_owner = N'Production', @source_object = N'ProductPhoto', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductPhoto', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductProductPhoto', @source_owner = N'Production', @source_object = N'ProductProductPhoto', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductProductPhoto', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductReview', @source_owner = N'Production', @source_object = N'ProductReview', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductReview', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductSubcategory', @source_owner = N'Production', @source_object = N'ProductSubcategory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductSubcategory', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ProductVendor', @source_owner = N'Purchasing', @source_object = N'ProductVendor', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ProductVendor', @destination_owner = N'Purchasing', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'PurchaseOrderDetail', @source_owner = N'Purchasing', @source_object = N'PurchaseOrderDetail', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'PurchaseOrderDetail', @destination_owner = N'Purchasing', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'PurchaseOrderHeader', @source_owner = N'Purchasing', @source_object = N'PurchaseOrderHeader', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'PurchaseOrderHeader', @destination_owner = N'Purchasing', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'qotd', @source_owner = N'dbo', @source_object = N'qotd', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'qotd', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesOrderDetail', @source_owner = N'Sales', @source_object = N'SalesOrderDetail', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesOrderDetail', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesOrderHeader', @source_owner = N'Sales', @source_object = N'SalesOrderHeader', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesOrderHeader', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesOrderHeaderSalesReason', @source_owner = N'Sales', @source_object = N'SalesOrderHeaderSalesReason', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesOrderHeaderSalesReason', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesPerson', @source_owner = N'Sales', @source_object = N'SalesPerson', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesPerson', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesPersonQuotaHistory', @source_owner = N'Sales', @source_object = N'SalesPersonQuotaHistory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesPersonQuotaHistory', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesReason', @source_owner = N'Sales', @source_object = N'SalesReason', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesReason', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesTaxRate', @source_owner = N'Sales', @source_object = N'SalesTaxRate', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesTaxRate', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesTerritory', @source_owner = N'Sales', @source_object = N'SalesTerritory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesTerritory', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SalesTerritoryHistory', @source_owner = N'Sales', @source_object = N'SalesTerritoryHistory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SalesTerritoryHistory', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ScrapReason', @source_owner = N'Production', @source_object = N'ScrapReason', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ScrapReason', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Shift', @source_owner = N'HumanResources', @source_object = N'Shift', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Shift', @destination_owner = N'HumanResources', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ShipMethod', @source_owner = N'Purchasing', @source_object = N'ShipMethod', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ShipMethod', @destination_owner = N'Purchasing', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ShoppingCartItem', @source_owner = N'Sales', @source_object = N'ShoppingCartItem', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'ShoppingCartItem', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SpecialOffer', @source_owner = N'Sales', @source_object = N'SpecialOffer', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SpecialOffer', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'SpecialOfferProduct', @source_owner = N'Sales', @source_object = N'SpecialOfferProduct', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'SpecialOfferProduct', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'StateProvince', @source_owner = N'Person', @source_object = N'StateProvince', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'StateProvince', @destination_owner = N'Person', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Store', @source_owner = N'Sales', @source_object = N'Store', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Store', @destination_owner = N'Sales', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'sysdiagrams', @source_owner = N'dbo', @source_object = N'sysdiagrams', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'sysdiagrams', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N't', @source_owner = N'dbo', @source_object = N't', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N't', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N't1', @source_owner = N'dbo', @source_object = N't1', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N't1', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N't2', @source_owner = N'dbo', @source_object = N't2', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N't2', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N't3', @source_owner = N'dbo', @source_object = N't3', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N't3', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Table2', @source_owner = N'dbo', @source_object = N'Table2', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Table2', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'TransactionHistory', @source_owner = N'Production', @source_object = N'TransactionHistory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'TransactionHistory', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'TransactionHistoryArchive', @source_owner = N'Production', @source_object = N'TransactionHistoryArchive', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'TransactionHistoryArchive', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'UnitMeasure', @source_owner = N'Production', @source_object = N'UnitMeasure', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'UnitMeasure', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'value', @source_owner = N'dbo', @source_object = N'value', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'value', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Vendor', @source_owner = N'Purchasing', @source_object = N'Vendor', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'Vendor', @destination_owner = N'Purchasing', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'WorkOrder', @source_owner = N'Production', @source_object = N'WorkOrder', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'WorkOrder', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'WorkOrderRouting', @source_owner = N'Production', @source_object = N'WorkOrderRouting', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'WorkOrderRouting', @destination_owner = N'Production', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'x', @source_owner = N'dbo', @source_object = N'x', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509D, @identityrangemanagementoption = N'manual', @destination_table = N'x', @destination_owner = N'dbo', @vertical_partition = N'false'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'getcust', @source_owner = N'dbo', @source_object = N'getcust', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'getcust', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'GetEmp', @source_owner = N'dbo', @source_object = N'GetEmp', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'GetEmp', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'GetEmployeeDetails', @source_owner = N'dbo', @source_object = N'GetEmployeeDetails', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'GetEmployeeDetails', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'geterroerinfo', @source_owner = N'dbo', @source_object = N'geterroerinfo', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'geterroerinfo', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'GetList', @source_owner = N'dbo', @source_object = N'GetList', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'GetList', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'GetNonNullSales', @source_owner = N'dbo', @source_object = N'GetNonNullSales', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'GetNonNullSales', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'GetNullSales', @source_owner = N'dbo', @source_object = N'GetNullSales', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'GetNullSales', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'GetVendorInfo', @source_owner = N'dbo', @source_object = N'GetVendorInfo', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'GetVendorInfo', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Procedure1', @source_owner = N'dbo', @source_object = N'Procedure1', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'Procedure1', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'RPT_OrderDetails', @source_owner = N'dbo', @source_object = N'RPT_OrderDetails', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'RPT_OrderDetails', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'savtran', @source_owner = N'dbo', @source_object = N'savtran', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'savtran', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'sp_alterdiagram', @source_owner = N'dbo', @source_object = N'sp_alterdiagram', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'sp_alterdiagram', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'sp_creatediagram', @source_owner = N'dbo', @source_object = N'sp_creatediagram', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'sp_creatediagram', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'sp_dropdiagram', @source_owner = N'dbo', @source_object = N'sp_dropdiagram', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'sp_dropdiagram', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'sp_helpdiagramdefinition', @source_owner = N'dbo', @source_object = N'sp_helpdiagramdefinition', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'sp_helpdiagramdefinition', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'sp_helpdiagrams', @source_owner = N'dbo', @source_object = N'sp_helpdiagrams', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'sp_helpdiagrams', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'sp_renamediagram', @source_owner = N'dbo', @source_object = N'sp_renamediagram', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'sp_renamediagram', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'sp_upgraddiagrams', @source_owner = N'dbo', @source_object = N'sp_upgraddiagrams', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'sp_upgraddiagrams', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'test1', @source_owner = N'dbo', @source_object = N'test1', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'test1', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'testproc', @source_owner = N'dbo', @source_object = N'testproc', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'testproc', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'Truncatetable', @source_owner = N'dbo', @source_object = N'Truncatetable', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'Truncatetable', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'updVacH', @source_owner = N'dbo', @source_object = N'updVacH', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'updVacH', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'usp_Customers', @source_owner = N'dbo', @source_object = N'usp_Customers', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'usp_Customers', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspGetBillOfMaterials', @source_owner = N'dbo', @source_object = N'uspGetBillOfMaterials', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspGetBillOfMaterials', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspGetEmployeeManagers', @source_owner = N'dbo', @source_object = N'uspGetEmployeeManagers', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspGetEmployeeManagers', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspGetManagerEmployees', @source_owner = N'dbo', @source_object = N'uspGetManagerEmployees', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspGetManagerEmployees', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspGetWhereUsedProductID', @source_owner = N'dbo', @source_object = N'uspGetWhereUsedProductID', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspGetWhereUsedProductID', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspLogError', @source_owner = N'dbo', @source_object = N'uspLogError', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspLogError', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspPrintError', @source_owner = N'dbo', @source_object = N'uspPrintError', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspPrintError', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspSearchCandidateResumes', @source_owner = N'dbo', @source_object = N'uspSearchCandidateResumes', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspSearchCandidateResumes', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspUpdateEmployeeHireInfo', @source_owner = N'HumanResources', @source_object = N'uspUpdateEmployeeHireInfo', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspUpdateEmployeeHireInfo', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspUpdateEmployeeLogin', @source_owner = N'HumanResources', @source_object = N'uspUpdateEmployeeLogin', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspUpdateEmployeeLogin', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uspUpdateEmployeePersonalInfo', @source_owner = N'HumanResources', @source_object = N'uspUpdateEmployeePersonalInfo', @type = N'proc schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uspUpdateEmployeePersonalInfo', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'OrdersByTerritory', @source_owner = N'Sales', @source_object = N'OrdersByTerritory', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'OrdersByTerritory', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vAdditionalContactInfo', @source_owner = N'Person', @source_object = N'vAdditionalContactInfo', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vAdditionalContactInfo', @destination_owner = N'Person'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vdate', @source_owner = N'dbo', @source_object = N'vdate', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vdate', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vEmployee', @source_owner = N'HumanResources', @source_object = N'vEmployee', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vEmployee', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vEmployeeDepartment', @source_owner = N'HumanResources', @source_object = N'vEmployeeDepartment', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vEmployeeDepartment', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vEmployeeDepartmentHistory', @source_owner = N'HumanResources', @source_object = N'vEmployeeDepartmentHistory', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vEmployeeDepartmentHistory', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vIndividualCustomer', @source_owner = N'Sales', @source_object = N'vIndividualCustomer', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vIndividualCustomer', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vJobCandidate', @source_owner = N'HumanResources', @source_object = N'vJobCandidate', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vJobCandidate', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vJobCandidateEducation', @source_owner = N'HumanResources', @source_object = N'vJobCandidateEducation', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vJobCandidateEducation', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vJobCandidateEmployment', @source_owner = N'HumanResources', @source_object = N'vJobCandidateEmployment', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vJobCandidateEmployment', @destination_owner = N'HumanResources'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vPersonDemographics', @source_owner = N'Sales', @source_object = N'vPersonDemographics', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vPersonDemographics', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vProductModelCatalogDescription', @source_owner = N'Production', @source_object = N'vProductModelCatalogDescription', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vProductModelCatalogDescription', @destination_owner = N'Production'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vProductModelInstructions', @source_owner = N'Production', @source_object = N'vProductModelInstructions', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vProductModelInstructions', @destination_owner = N'Production'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vSalesPerson', @source_owner = N'Sales', @source_object = N'vSalesPerson', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vSalesPerson', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vSalesPersonSalesByFiscalYears', @source_owner = N'Sales', @source_object = N'vSalesPersonSalesByFiscalYears', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vSalesPersonSalesByFiscalYears', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vStoreWithAddresses', @source_owner = N'Sales', @source_object = N'vStoreWithAddresses', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vStoreWithAddresses', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vStoreWithContacts', @source_owner = N'Sales', @source_object = N'vStoreWithContacts', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vStoreWithContacts', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vStoreWithDemographics', @source_owner = N'Sales', @source_object = N'vStoreWithDemographics', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vStoreWithDemographics', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vVendorWithAddresses', @source_owner = N'Purchasing', @source_object = N'vVendorWithAddresses', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vVendorWithAddresses', @destination_owner = N'Purchasing'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vVendorWithContacts', @source_owner = N'Purchasing', @source_object = N'vVendorWithContacts', @type = N'view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vVendorWithContacts', @destination_owner = N'Purchasing'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'uv_CustomerFullName', @source_owner = N'Sales', @source_object = N'uv_CustomerFullName', @type = N'indexed view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'uv_CustomerFullName', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vProductAndDescription', @source_owner = N'Production', @source_object = N'vProductAndDescription', @type = N'indexed view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vProductAndDescription', @destination_owner = N'Production'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'vStateProvinceCountryRegion', @source_owner = N'Person', @source_object = N'vStateProvinceCountryRegion', @type = N'indexed view schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vStateProvinceCountryRegion', @destination_owner = N'Person'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'fn_diagramobjects', @source_owner = N'dbo', @source_object = N'fn_diagramobjects', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fn_diagramobjects', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'fn_getbookISBN', @source_owner = N'dbo', @source_object = N'fn_getbookISBN', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fn_getbookISBN', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'fn_OrdersByTerritory', @source_owner = N'Sales', @source_object = N'fn_OrdersByTerritory', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fn_OrdersByTerritory', @destination_owner = N'Sales'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'fn2', @source_owner = N'dbo', @source_object = N'fn2', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fn2', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'my_fn', @source_owner = N'dbo', @source_object = N'my_fn', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'my_fn', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetAccountingEndDate', @source_owner = N'dbo', @source_object = N'ufnGetAccountingEndDate', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetAccountingEndDate', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetAccountingStartDate', @source_owner = N'dbo', @source_object = N'ufnGetAccountingStartDate', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetAccountingStartDate', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetContactInformation', @source_owner = N'dbo', @source_object = N'ufnGetContactInformation', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetContactInformation', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetDocumentStatusText', @source_owner = N'dbo', @source_object = N'ufnGetDocumentStatusText', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetDocumentStatusText', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetProductDealerPrice', @source_owner = N'dbo', @source_object = N'ufnGetProductDealerPrice', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetProductDealerPrice', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetProductListPrice', @source_owner = N'dbo', @source_object = N'ufnGetProductListPrice', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetProductListPrice', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetProductStandardCost', @source_owner = N'dbo', @source_object = N'ufnGetProductStandardCost', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetProductStandardCost', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetPurchaseOrderStatusText', @source_owner = N'dbo', @source_object = N'ufnGetPurchaseOrderStatusText', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetPurchaseOrderStatusText', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetSalesOrderStatusText', @source_owner = N'dbo', @source_object = N'ufnGetSalesOrderStatusText', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetSalesOrderStatusText', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnGetStock', @source_owner = N'dbo', @source_object = N'ufnGetStock', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnGetStock', @destination_owner = N'dbo'
GO




use [AdventureWorks2008R2]
exec sp_addarticle @publication = N'NewPublication', @article = N'ufnLeadingZeros', @source_owner = N'dbo', @source_object = N'ufnLeadingZeros', @type = N'func schema only', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'ufnLeadingZeros', @destination_owner = N'dbo'
GO




