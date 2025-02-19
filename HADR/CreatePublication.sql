/****** Scripting replication configuration. Script Date: 16/10/2016 09:02:44 ******/
/****** Please Note: For security reasons, all password parameters were scripted with either NULL or an empty string. ******/

/****** Installing the server as a Distributor. Script Date: 16/10/2016 09:02:44 ******/
use master
exec sp_adddistributor @distributor = N'RUH1ISELLABPT2', @password = N''
GO
exec sp_adddistributiondb @database = N'distribution', @data_folder = N'D:\DATA', @log_folder = N'D:\LOG', @log_file_size = 2, @min_distretention = 0, @max_distretention = 72, @history_retention = 48, @security_mode = 1
GO

use [distribution] 
if (not exists (select * from sysobjects where name = 'UIProperties' and type = 'U ')) 
	create table UIProperties(id int) 
if (exists (select * from ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', null, null))) 
	EXEC sp_updateextendedproperty N'SnapshotFolder', N'D:\DATA\MSSQL10_50.MSSQLSERVER\MSSQL\ReplData', 'user', dbo, 'table', 'UIProperties' 
else 
	EXEC sp_addextendedproperty N'SnapshotFolder', N'D:\DATA\MSSQL10_50.MSSQLSERVER\MSSQL\ReplData', 'user', dbo, 'table', 'UIProperties'
GO

exec sp_adddistpublisher @publisher = N'ruh1isellabpt2', @distribution_db = N'distribution', @security_mode = 1, @working_directory = N'D:\DATA\MSSQL10_50.MSSQLSERVER\MSSQL\ReplData', @trusted = N'false', @thirdparty_flag = 0, @publisher_type = N'MSSQLSERVER'
GO

use [ABP_SFA_BMB]
exec sp_replicationdboption @dbname = N'ABP_SFA_BMB', @optname = N'publish', @value = N'true'
GO
use [ABP_SFA_BMB]
exec [ABP_SFA_BMB].sys.sp_addlogreader_agent @job_login = N'ALJOMAIHBEV\sqladmin', @job_password = null, @publisher_security_mode = 1, @job_name = null
GO
-- Adding the transactional publication
use [ABP_SFA_BMB]
exec sp_addpublication @publication = N'ABP_SFA_BMB', @description = N'Transactional publication of database ''ABP_SFA_BMB'' from Publisher ''RUH1ISELLABPT2''.', @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
GO


exec sp_addpublication_snapshot @publication = N'ABP_SFA_BMB', @frequency_type = 4, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = N'ALJOMAIHBEV\sqladmin', @job_password = null, @publisher_security_mode = 1


use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_BMC_Clientcode_VS_Sales', @source_owner = N'dbo', @source_object = N'ABP_BMC_Clientcode_VS_Sales', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_BMC_Clientcode_VS_Sales', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_BMC_Clientcode_VS_Sales', @del_cmd = N'CALL sp_MSdel_dboABP_BMC_Clientcode_VS_Sales', @upd_cmd = N'SCALL sp_MSupd_dboABP_BMC_Clientcode_VS_Sales'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_BMC_Currentmonth_Sales', @source_owner = N'dbo', @source_object = N'ABP_BMC_Currentmonth_Sales', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_BMC_Currentmonth_Sales', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_BMC_Currentmonth_Sales', @del_cmd = N'CALL sp_MSdel_dboABP_BMC_Currentmonth_Sales', @upd_cmd = N'SCALL sp_MSupd_dboABP_BMC_Currentmonth_Sales'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_BMC_Secondmonthsales', @source_owner = N'dbo', @source_object = N'ABP_BMC_Secondmonthsales', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_BMC_Secondmonthsales', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_BMC_Secondmonthsales', @del_cmd = N'CALL sp_MSdel_dboABP_BMC_Secondmonthsales', @upd_cmd = N'SCALL sp_MSupd_dboABP_BMC_Secondmonthsales'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_BMC_Thirdmonthsales', @source_owner = N'dbo', @source_object = N'ABP_BMC_Thirdmonthsales', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_BMC_Thirdmonthsales', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_BMC_Thirdmonthsales', @del_cmd = N'CALL sp_MSdel_dboABP_BMC_Thirdmonthsales', @upd_cmd = N'SCALL sp_MSupd_dboABP_BMC_Thirdmonthsales'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_InvoiceMappingIssuingRoute', @source_owner = N'dbo', @source_object = N'ABP_InvoiceMappingIssuingRoute', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_InvoiceMappingIssuingRoute', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_InvoiceMappingIssuingRoute', @del_cmd = N'CALL sp_MSdel_dboABP_InvoiceMappingIssuingRoute', @upd_cmd = N'SCALL sp_MSupd_dboABP_InvoiceMappingIssuingRoute'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_PRR_Invoices', @source_owner = N'dbo', @source_object = N'ABP_PRR_Invoices', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_PRR_Invoices', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_PRR_Invoices', @del_cmd = N'CALL sp_MSdel_dboABP_PRR_Invoices', @upd_cmd = N'SCALL sp_MSupd_dboABP_PRR_Invoices'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_Route_Additional_Info', @source_owner = N'dbo', @source_object = N'ABP_Route_Additional_Info', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_Route_Additional_Info', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_Route_Additional_Info', @del_cmd = N'CALL sp_MSdel_dboABP_Route_Additional_Info', @upd_cmd = N'SCALL sp_MSupd_dboABP_Route_Additional_Info'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_Route_Client_Divisions', @source_owner = N'dbo', @source_object = N'ABP_Route_Client_Divisions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_Route_Client_Divisions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_Route_Client_Divisions', @del_cmd = N'CALL sp_MSdel_dboABP_Route_Client_Divisions', @upd_cmd = N'SCALL sp_MSupd_dboABP_Route_Client_Divisions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_Route_Client_Schedules', @source_owner = N'dbo', @source_object = N'ABP_Route_Client_Schedules', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_Route_Client_Schedules', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_Route_Client_Schedules', @del_cmd = N'CALL sp_MSdel_dboABP_Route_Client_Schedules', @upd_cmd = N'SCALL sp_MSupd_dboABP_Route_Client_Schedules'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_Route_Hierarchy', @source_owner = N'dbo', @source_object = N'ABP_Route_Hierarchy', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_Route_Hierarchy', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_Route_Hierarchy', @del_cmd = N'CALL sp_MSdel_dboABP_Route_Hierarchy', @upd_cmd = N'SCALL sp_MSupd_dboABP_Route_Hierarchy'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_Route_Hierarchy_v1', @source_owner = N'dbo', @source_object = N'ABP_Route_Hierarchy_v1', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_Route_Hierarchy_v1', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_Route_Hierarchy_v1', @del_cmd = N'CALL sp_MSdel_dboABP_Route_Hierarchy_v1', @upd_cmd = N'SCALL sp_MSupd_dboABP_Route_Hierarchy_v1'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_SALES_REPORT', @source_owner = N'dbo', @source_object = N'ABP_SALES_REPORT', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_SALES_REPORT', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_SALES_REPORT', @del_cmd = N'CALL sp_MSdel_dboABP_SALES_REPORT', @upd_cmd = N'SCALL sp_MSupd_dboABP_SALES_REPORT'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_UNDELIVER_SHIPMENT_HEADER', @source_owner = N'dbo', @source_object = N'ABP_UNDELIVER_SHIPMENT_HEADER', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_UNDELIVER_SHIPMENT_HEADER', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_UNDELIVER_SHIPMENT_HEADER', @del_cmd = N'CALL sp_MSdel_dboABP_UNDELIVER_SHIPMENT_HEADER', @upd_cmd = N'SCALL sp_MSupd_dboABP_UNDELIVER_SHIPMENT_HEADER'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ABP_UNDELIVER_SHIPMENT_LINES', @source_owner = N'dbo', @source_object = N'ABP_UNDELIVER_SHIPMENT_LINES', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ABP_UNDELIVER_SHIPMENT_LINES', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboABP_UNDELIVER_SHIPMENT_LINES', @del_cmd = N'CALL sp_MSdel_dboABP_UNDELIVER_SHIPMENT_LINES', @upd_cmd = N'SCALL sp_MSupd_dboABP_UNDELIVER_SHIPMENT_LINES'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Access_Code_Log', @source_owner = N'dbo', @source_object = N'Access_Code_Log', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Access_Code_Log', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAccess_Code_Log', @del_cmd = N'CALL sp_MSdel_dboAccess_Code_Log', @upd_cmd = N'SCALL sp_MSupd_dboAccess_Code_Log'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Access_Rights', @source_owner = N'dbo', @source_object = N'Access_Rights', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Access_Rights', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAccess_Rights', @del_cmd = N'CALL sp_MSdel_dboAccess_Rights', @upd_cmd = N'SCALL sp_MSupd_dboAccess_Rights'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Act_Answers', @source_owner = N'dbo', @source_object = N'Act_Answers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Act_Answers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAct_Answers', @del_cmd = N'CALL sp_MSdel_dboAct_Answers', @upd_cmd = N'SCALL sp_MSupd_dboAct_Answers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Act_Options', @source_owner = N'dbo', @source_object = N'Act_Options', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Act_Options', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAct_Options', @del_cmd = N'CALL sp_MSdel_dboAct_Options', @upd_cmd = N'SCALL sp_MSupd_dboAct_Options'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Act_Questions', @source_owner = N'dbo', @source_object = N'Act_Questions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Act_Questions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAct_Questions', @del_cmd = N'CALL sp_MSdel_dboAct_Questions', @upd_cmd = N'SCALL sp_MSupd_dboAct_Questions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Act_Subjects', @source_owner = N'dbo', @source_object = N'Act_Subjects', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Act_Subjects', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAct_Subjects', @del_cmd = N'CALL sp_MSdel_dboAct_Subjects', @upd_cmd = N'SCALL sp_MSupd_dboAct_Subjects'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Activities', @source_owner = N'dbo', @source_object = N'Activities', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Activities', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboActivities', @del_cmd = N'CALL sp_MSdel_dboActivities', @upd_cmd = N'SCALL sp_MSupd_dboActivities'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Activity_Assignments', @source_owner = N'dbo', @source_object = N'Activity_Assignments', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Activity_Assignments', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboActivity_Assignments', @del_cmd = N'CALL sp_MSdel_dboActivity_Assignments', @upd_cmd = N'SCALL sp_MSupd_dboActivity_Assignments'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_CDA_Access_Point_Type', @source_owner = N'dbo', @source_object = N'AM_CDA_Access_Point_Type', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_CDA_Access_Point_Type', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_CDA_Access_Point_Type', @del_cmd = N'CALL sp_MSdel_dboAM_CDA_Access_Point_Type', @upd_cmd = N'SCALL sp_MSupd_dboAM_CDA_Access_Point_Type'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_CDA_Client_Type', @source_owner = N'dbo', @source_object = N'AM_CDA_Client_Type', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_CDA_Client_Type', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_CDA_Client_Type', @del_cmd = N'CALL sp_MSdel_dboAM_CDA_Client_Type', @upd_cmd = N'SCALL sp_MSupd_dboAM_CDA_Client_Type'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_CDA_Definition', @source_owner = N'dbo', @source_object = N'AM_CDA_Definition', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_CDA_Definition', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_CDA_Definition', @del_cmd = N'CALL sp_MSdel_dboAM_CDA_Definition', @upd_cmd = N'SCALL sp_MSupd_dboAM_CDA_Definition'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_CDA_Item_Category', @source_owner = N'dbo', @source_object = N'AM_CDA_Item_Category', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_CDA_Item_Category', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_CDA_Item_Category', @del_cmd = N'CALL sp_MSdel_dboAM_CDA_Item_Category', @upd_cmd = N'SCALL sp_MSupd_dboAM_CDA_Item_Category'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_CDA_Question_Answer', @source_owner = N'dbo', @source_object = N'AM_CDA_Question_Answer', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_CDA_Question_Answer', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_CDA_Question_Answer', @del_cmd = N'CALL sp_MSdel_dboAM_CDA_Question_Answer', @upd_cmd = N'SCALL sp_MSupd_dboAM_CDA_Question_Answer'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_CDA_Question_Assignment', @source_owner = N'dbo', @source_object = N'AM_CDA_Question_Assignment', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_CDA_Question_Assignment', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_CDA_Question_Assignment', @del_cmd = N'CALL sp_MSdel_dboAM_CDA_Question_Assignment', @upd_cmd = N'SCALL sp_MSupd_dboAM_CDA_Question_Assignment'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_INT_Active_Clients', @source_owner = N'dbo', @source_object = N'AM_INT_Active_Clients', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_INT_Active_Clients', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_INT_Active_Clients', @del_cmd = N'CALL sp_MSdel_dboAM_INT_Active_Clients', @upd_cmd = N'SCALL sp_MSupd_dboAM_INT_Active_Clients'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_INT_Pre_TRX_Headers', @source_owner = N'dbo', @source_object = N'AM_INT_Pre_TRX_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_INT_Pre_TRX_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_INT_Pre_TRX_Headers', @del_cmd = N'CALL sp_MSdel_dboAM_INT_Pre_TRX_Headers', @upd_cmd = N'SCALL sp_MSupd_dboAM_INT_Pre_TRX_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_Question_Master', @source_owner = N'dbo', @source_object = N'AM_Question_Master', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_Question_Master', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_Question_Master', @del_cmd = N'CALL sp_MSdel_dboAM_Question_Master', @upd_cmd = N'SCALL sp_MSupd_dboAM_Question_Master'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'AM_Question_Master_Option', @source_owner = N'dbo', @source_object = N'AM_Question_Master_Option', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'AM_Question_Master_Option', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAM_Question_Master_Option', @del_cmd = N'CALL sp_MSdel_dboAM_Question_Master_Option', @upd_cmd = N'SCALL sp_MSupd_dboAM_Question_Master_Option'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ApprovalStatus', @source_owner = N'dbo', @source_object = N'ApprovalStatus', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ApprovalStatus', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboApprovalStatus', @del_cmd = N'CALL sp_MSdel_dboApprovalStatus', @upd_cmd = N'SCALL sp_MSupd_dboApprovalStatus'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Area_Of_Business', @source_owner = N'dbo', @source_object = N'Area_Of_Business', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Area_Of_Business', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboArea_Of_Business', @del_cmd = N'CALL sp_MSdel_dboArea_Of_Business', @upd_cmd = N'SCALL sp_MSupd_dboArea_Of_Business'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Area_Of_Business_Groups', @source_owner = N'dbo', @source_object = N'Area_Of_Business_Groups', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Area_Of_Business_Groups', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboArea_Of_Business_Groups', @del_cmd = N'CALL sp_MSdel_dboArea_Of_Business_Groups', @upd_cmd = N'SCALL sp_MSupd_dboArea_Of_Business_Groups'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Areas', @source_owner = N'dbo', @source_object = N'Areas', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Areas', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAreas', @del_cmd = N'CALL sp_MSdel_dboAreas', @upd_cmd = N'SCALL sp_MSupd_dboAreas'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Asset_Allocations', @source_owner = N'dbo', @source_object = N'Asset_Allocations', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Asset_Allocations', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAsset_Allocations', @del_cmd = N'CALL sp_MSdel_dboAsset_Allocations', @upd_cmd = N'SCALL sp_MSupd_dboAsset_Allocations'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Asset_Attributes1', @source_owner = N'dbo', @source_object = N'Asset_Attributes1', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Asset_Attributes1', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAsset_Attributes1', @del_cmd = N'CALL sp_MSdel_dboAsset_Attributes1', @upd_cmd = N'SCALL sp_MSupd_dboAsset_Attributes1'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Asset_Attributes2', @source_owner = N'dbo', @source_object = N'Asset_Attributes2', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Asset_Attributes2', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAsset_Attributes2', @del_cmd = N'CALL sp_MSdel_dboAsset_Attributes2', @upd_cmd = N'SCALL sp_MSupd_dboAsset_Attributes2'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Asset_Definitions', @source_owner = N'dbo', @source_object = N'Asset_Definitions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Asset_Definitions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAsset_Definitions', @del_cmd = N'CALL sp_MSdel_dboAsset_Definitions', @upd_cmd = N'SCALL sp_MSupd_dboAsset_Definitions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Asset_Statuses', @source_owner = N'dbo', @source_object = N'Asset_Statuses', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Asset_Statuses', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAsset_Statuses', @del_cmd = N'CALL sp_MSdel_dboAsset_Statuses', @upd_cmd = N'SCALL sp_MSupd_dboAsset_Statuses'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Asset_Suppliers', @source_owner = N'dbo', @source_object = N'Asset_Suppliers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Asset_Suppliers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAsset_Suppliers', @del_cmd = N'CALL sp_MSdel_dboAsset_Suppliers', @upd_cmd = N'SCALL sp_MSupd_dboAsset_Suppliers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Asset_Tracking_Details', @source_owner = N'dbo', @source_object = N'Asset_Tracking_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Asset_Tracking_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAsset_Tracking_Details', @del_cmd = N'CALL sp_MSdel_dboAsset_Tracking_Details', @upd_cmd = N'SCALL sp_MSupd_dboAsset_Tracking_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Asset_Tracking_Headers', @source_owner = N'dbo', @source_object = N'Asset_Tracking_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Asset_Tracking_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboAsset_Tracking_Headers', @del_cmd = N'CALL sp_MSdel_dboAsset_Tracking_Headers', @upd_cmd = N'SCALL sp_MSupd_dboAsset_Tracking_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Bank_Branches', @source_owner = N'dbo', @source_object = N'Bank_Branches', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Bank_Branches', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboBank_Branches', @del_cmd = N'CALL sp_MSdel_dboBank_Branches', @upd_cmd = N'SCALL sp_MSupd_dboBank_Branches'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Banks', @source_owner = N'dbo', @source_object = N'Banks', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Banks', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboBanks', @del_cmd = N'CALL sp_MSdel_dboBanks', @upd_cmd = N'SCALL sp_MSupd_dboBanks'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'BE_Version_Registration', @source_owner = N'dbo', @source_object = N'BE_Version_Registration', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'BE_Version_Registration', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboBE_Version_Registration', @del_cmd = N'CALL sp_MSdel_dboBE_Version_Registration', @upd_cmd = N'SCALL sp_MSupd_dboBE_Version_Registration'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Blocked_For_Price_Alteration', @source_owner = N'dbo', @source_object = N'Blocked_For_Price_Alteration', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Blocked_For_Price_Alteration', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboBlocked_For_Price_Alteration', @del_cmd = N'CALL sp_MSdel_dboBlocked_For_Price_Alteration', @upd_cmd = N'SCALL sp_MSupd_dboBlocked_For_Price_Alteration'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Branch_Plants', @source_owner = N'dbo', @source_object = N'Branch_Plants', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Branch_Plants', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboBranch_Plants', @del_cmd = N'CALL sp_MSdel_dboBranch_Plants', @upd_cmd = N'SCALL sp_MSupd_dboBranch_Plants'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Branches', @source_owner = N'dbo', @source_object = N'Branches', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Branches', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboBranches', @del_cmd = N'CALL sp_MSdel_dboBranches', @upd_cmd = N'SCALL sp_MSupd_dboBranches'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Calendar', @source_owner = N'dbo', @source_object = N'Calendar', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Calendar', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCalendar', @del_cmd = N'CALL sp_MSdel_dboCalendar', @upd_cmd = N'SCALL sp_MSupd_dboCalendar'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Cash_Discounts', @source_owner = N'dbo', @source_object = N'Cash_Discounts', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Cash_Discounts', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCash_Discounts', @del_cmd = N'CALL sp_MSdel_dboCash_Discounts', @upd_cmd = N'SCALL sp_MSupd_dboCash_Discounts'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'CDA_Allocations', @source_owner = N'dbo', @source_object = N'CDA_Allocations', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CDA_Allocations', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCDA_Allocations', @del_cmd = N'CALL sp_MSdel_dboCDA_Allocations', @upd_cmd = N'SCALL sp_MSupd_dboCDA_Allocations'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'CDA_Assignments', @source_owner = N'dbo', @source_object = N'CDA_Assignments', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CDA_Assignments', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCDA_Assignments', @del_cmd = N'CALL sp_MSdel_dboCDA_Assignments', @upd_cmd = N'SCALL sp_MSupd_dboCDA_Assignments'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'CDA_Definitions', @source_owner = N'dbo', @source_object = N'CDA_Definitions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CDA_Definitions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCDA_Definitions', @del_cmd = N'CALL sp_MSdel_dboCDA_Definitions', @upd_cmd = N'SCALL sp_MSupd_dboCDA_Definitions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'CDA_Question_Options', @source_owner = N'dbo', @source_object = N'CDA_Question_Options', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CDA_Question_Options', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCDA_Question_Options', @del_cmd = N'CALL sp_MSdel_dboCDA_Question_Options', @upd_cmd = N'SCALL sp_MSupd_dboCDA_Question_Options'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'CDA_Questions', @source_owner = N'dbo', @source_object = N'CDA_Questions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CDA_Questions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCDA_Questions', @del_cmd = N'CALL sp_MSdel_dboCDA_Questions', @upd_cmd = N'SCALL sp_MSupd_dboCDA_Questions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'CDA_Terms', @source_owner = N'dbo', @source_object = N'CDA_Terms', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CDA_Terms', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCDA_Terms', @del_cmd = N'CALL sp_MSdel_dboCDA_Terms', @upd_cmd = N'SCALL sp_MSupd_dboCDA_Terms'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Census_Clients', @source_owner = N'dbo', @source_object = N'Census_Clients', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Census_Clients', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCensus_Clients', @del_cmd = N'CALL sp_MSdel_dboCensus_Clients', @upd_cmd = N'SCALL sp_MSupd_dboCensus_Clients'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Channel_Groups', @source_owner = N'dbo', @source_object = N'Channel_Groups', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Channel_Groups', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboChannel_Groups', @del_cmd = N'CALL sp_MSdel_dboChannel_Groups', @upd_cmd = N'SCALL sp_MSupd_dboChannel_Groups'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Channel_Item_Distribution', @source_owner = N'dbo', @source_object = N'Channel_Item_Distribution', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Channel_Item_Distribution', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboChannel_Item_Distribution', @del_cmd = N'CALL sp_MSdel_dboChannel_Item_Distribution', @upd_cmd = N'SCALL sp_MSupd_dboChannel_Item_Distribution'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Channel_Parent_Link', @source_owner = N'dbo', @source_object = N'Channel_Parent_Link', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Channel_Parent_Link', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboChannel_Parent_Link', @del_cmd = N'CALL sp_MSdel_dboChannel_Parent_Link', @upd_cmd = N'SCALL sp_MSupd_dboChannel_Parent_Link'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Channel_Parents', @source_owner = N'dbo', @source_object = N'Channel_Parents', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Channel_Parents', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboChannel_Parents', @del_cmd = N'CALL sp_MSdel_dboChannel_Parents', @upd_cmd = N'SCALL sp_MSupd_dboChannel_Parents'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Channels', @source_owner = N'dbo', @source_object = N'Channels', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Channels', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboChannels', @del_cmd = N'CALL sp_MSdel_dboChannels', @upd_cmd = N'SCALL sp_MSupd_dboChannels'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Channels_Additional_Info', @source_owner = N'dbo', @source_object = N'Channels_Additional_Info', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Channels_Additional_Info', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboChannels_Additional_Info', @del_cmd = N'CALL sp_MSdel_dboChannels_Additional_Info', @upd_cmd = N'SCALL sp_MSupd_dboChannels_Additional_Info'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'CICTellSell', @source_owner = N'dbo', @source_object = N'CICTellSell', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CICTellSell', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCICTellSell', @del_cmd = N'CALL sp_MSdel_dboCICTellSell', @upd_cmd = N'SCALL sp_MSupd_dboCICTellSell'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Cities', @source_owner = N'dbo', @source_object = N'Cities', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Cities', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCities', @del_cmd = N'CALL sp_MSdel_dboCities', @upd_cmd = N'SCALL sp_MSupd_dboCities'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Clear_Open_Trip_Log', @source_owner = N'dbo', @source_object = N'Clear_Open_Trip_Log', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Clear_Open_Trip_Log', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClear_Open_Trip_Log', @del_cmd = N'CALL sp_MSdel_dboClear_Open_Trip_Log', @upd_cmd = N'SCALL sp_MSupd_dboClear_Open_Trip_Log'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Additional_Info', @source_owner = N'dbo', @source_object = N'Client_Additional_Info', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Additional_Info', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Additional_Info', @del_cmd = N'CALL sp_MSdel_dboClient_Additional_Info', @upd_cmd = N'SCALL sp_MSupd_dboClient_Additional_Info'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Agings', @source_owner = N'dbo', @source_object = N'Client_Agings', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Agings', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Agings', @del_cmd = N'CALL sp_MSdel_dboClient_Agings', @upd_cmd = N'SCALL sp_MSupd_dboClient_Agings'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Branches', @source_owner = N'dbo', @source_object = N'Client_Branches', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Branches', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Branches', @del_cmd = N'CALL sp_MSdel_dboClient_Branches', @upd_cmd = N'SCALL sp_MSupd_dboClient_Branches'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Collection_Types', @source_owner = N'dbo', @source_object = N'Client_Collection_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Collection_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Collection_Types', @del_cmd = N'CALL sp_MSdel_dboClient_Collection_Types', @upd_cmd = N'SCALL sp_MSupd_dboClient_Collection_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Credit_Hold_Log', @source_owner = N'dbo', @source_object = N'Client_Credit_Hold_Log', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Credit_Hold_Log', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Credit_Hold_Log', @del_cmd = N'CALL sp_MSdel_dboClient_Credit_Hold_Log', @upd_cmd = N'SCALL sp_MSupd_dboClient_Credit_Hold_Log'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Creditings', @source_owner = N'dbo', @source_object = N'Client_Creditings', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Creditings', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Creditings', @del_cmd = N'CALL sp_MSdel_dboClient_Creditings', @upd_cmd = N'SCALL sp_MSupd_dboClient_Creditings'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'CLIENT_CreditLimit_Distribution', @source_owner = N'dbo', @source_object = N'CLIENT_CreditLimit_Distribution', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CLIENT_CreditLimit_Distribution', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCLIENT_CreditLimit_Distribution', @del_cmd = N'CALL sp_MSdel_dboCLIENT_CreditLimit_Distribution', @upd_cmd = N'SCALL sp_MSupd_dboCLIENT_CreditLimit_Distribution'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Direction_Details', @source_owner = N'dbo', @source_object = N'Client_Direction_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Direction_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Direction_Details', @del_cmd = N'CALL sp_MSdel_dboClient_Direction_Details', @upd_cmd = N'SCALL sp_MSupd_dboClient_Direction_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Direction_Headers', @source_owner = N'dbo', @source_object = N'Client_Direction_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Direction_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Direction_Headers', @del_cmd = N'CALL sp_MSdel_dboClient_Direction_Headers', @upd_cmd = N'SCALL sp_MSupd_dboClient_Direction_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_GPS_Positions', @source_owner = N'dbo', @source_object = N'Client_GPS_Positions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_GPS_Positions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_GPS_Positions', @del_cmd = N'CALL sp_MSdel_dboClient_GPS_Positions', @upd_cmd = N'SCALL sp_MSupd_dboClient_GPS_Positions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_GPS_Statuses', @source_owner = N'dbo', @source_object = N'Client_GPS_Statuses', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_GPS_Statuses', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_GPS_Statuses', @del_cmd = N'CALL sp_MSdel_dboClient_GPS_Statuses', @upd_cmd = N'SCALL sp_MSupd_dboClient_GPS_Statuses'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_GPS_Verification', @source_owner = N'dbo', @source_object = N'Client_GPS_Verification', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_GPS_Verification', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_GPS_Verification', @del_cmd = N'CALL sp_MSdel_dboClient_GPS_Verification', @upd_cmd = N'SCALL sp_MSupd_dboClient_GPS_Verification'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_History', @source_owner = N'dbo', @source_object = N'Client_History', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_History', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_History', @del_cmd = N'CALL sp_MSdel_dboClient_History', @upd_cmd = N'SCALL sp_MSupd_dboClient_History'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_History_Cards', @source_owner = N'dbo', @source_object = N'Client_History_Cards', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_History_Cards', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_History_Cards', @del_cmd = N'CALL sp_MSdel_dboClient_History_Cards', @upd_cmd = N'SCALL sp_MSupd_dboClient_History_Cards'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Last_Invoice', @source_owner = N'dbo', @source_object = N'Client_Last_Invoice', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Last_Invoice', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Last_Invoice', @del_cmd = N'CALL sp_MSdel_dboClient_Last_Invoice', @upd_cmd = N'SCALL sp_MSupd_dboClient_Last_Invoice'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Price_Lists', @source_owner = N'dbo', @source_object = N'Client_Price_Lists', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Price_Lists', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Price_Lists', @del_cmd = N'CALL sp_MSdel_dboClient_Price_Lists', @upd_cmd = N'SCALL sp_MSupd_dboClient_Price_Lists'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Status', @source_owner = N'dbo', @source_object = N'Client_Status', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Status', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Status', @del_cmd = N'CALL sp_MSdel_dboClient_Status', @upd_cmd = N'SCALL sp_MSupd_dboClient_Status'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Statuses', @source_owner = N'dbo', @source_object = N'Client_Statuses', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Statuses', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Statuses', @del_cmd = N'CALL sp_MSdel_dboClient_Statuses', @upd_cmd = N'SCALL sp_MSupd_dboClient_Statuses'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Client_Types', @source_owner = N'dbo', @source_object = N'Client_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Client_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClient_Types', @del_cmd = N'CALL sp_MSdel_dboClient_Types', @upd_cmd = N'SCALL sp_MSupd_dboClient_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ClientOracleCredit', @source_owner = N'dbo', @source_object = N'ClientOracleCredit', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ClientOracleCredit', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClientOracleCredit', @del_cmd = N'CALL sp_MSdel_dboClientOracleCredit', @upd_cmd = N'SCALL sp_MSupd_dboClientOracleCredit'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Clients', @source_owner = N'dbo', @source_object = N'Clients', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Clients', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboClients', @del_cmd = N'CALL sp_MSdel_dboClients', @upd_cmd = N'SCALL sp_MSupd_dboClients'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Comm_Channels', @source_owner = N'dbo', @source_object = N'Comm_Channels', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Comm_Channels', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboComm_Channels', @del_cmd = N'CALL sp_MSdel_dboComm_Channels', @upd_cmd = N'SCALL sp_MSupd_dboComm_Channels'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Comm_Log_Details', @source_owner = N'dbo', @source_object = N'Comm_Log_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Comm_Log_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboComm_Log_Details', @del_cmd = N'CALL sp_MSdel_dboComm_Log_Details', @upd_cmd = N'SCALL sp_MSupd_dboComm_Log_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Comm_Log_Headers', @source_owner = N'dbo', @source_object = N'Comm_Log_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Comm_Log_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboComm_Log_Headers', @del_cmd = N'CALL sp_MSdel_dboComm_Log_Headers', @upd_cmd = N'SCALL sp_MSupd_dboComm_Log_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Comm_Settings', @source_owner = N'dbo', @source_object = N'Comm_Settings', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Comm_Settings', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboComm_Settings', @del_cmd = N'CALL sp_MSdel_dboComm_Settings', @upd_cmd = N'SCALL sp_MSupd_dboComm_Settings'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Comm_Tables', @source_owner = N'dbo', @source_object = N'Comm_Tables', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Comm_Tables', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboComm_Tables', @del_cmd = N'CALL sp_MSdel_dboComm_Tables', @upd_cmd = N'SCALL sp_MSupd_dboComm_Tables'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Companies', @source_owner = N'dbo', @source_object = N'Companies', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Companies', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCompanies', @del_cmd = N'CALL sp_MSdel_dboCompanies', @upd_cmd = N'SCALL sp_MSupd_dboCompanies'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Competitor_Items', @source_owner = N'dbo', @source_object = N'Competitor_Items', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Competitor_Items', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCompetitor_Items', @del_cmd = N'CALL sp_MSdel_dboCompetitor_Items', @upd_cmd = N'SCALL sp_MSupd_dboCompetitor_Items'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Competitors', @source_owner = N'dbo', @source_object = N'Competitors', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Competitors', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCompetitors', @del_cmd = N'CALL sp_MSdel_dboCompetitors', @upd_cmd = N'SCALL sp_MSupd_dboCompetitors'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Cost_Centers', @source_owner = N'dbo', @source_object = N'Cost_Centers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Cost_Centers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCost_Centers', @del_cmd = N'CALL sp_MSdel_dboCost_Centers', @upd_cmd = N'SCALL sp_MSupd_dboCost_Centers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Currencies', @source_owner = N'dbo', @source_object = N'Currencies', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Currencies', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCurrencies', @del_cmd = N'CALL sp_MSdel_dboCurrencies', @upd_cmd = N'SCALL sp_MSupd_dboCurrencies'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Currency_History', @source_owner = N'dbo', @source_object = N'Currency_History', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Currency_History', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCurrency_History', @del_cmd = N'CALL sp_MSdel_dboCurrency_History', @upd_cmd = N'SCALL sp_MSupd_dboCurrency_History'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Customer_Chains', @source_owner = N'dbo', @source_object = N'Customer_Chains', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Customer_Chains', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboCustomer_Chains', @del_cmd = N'CALL sp_MSdel_dboCustomer_Chains', @upd_cmd = N'SCALL sp_MSupd_dboCustomer_Chains'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Daily_Targets', @source_owner = N'dbo', @source_object = N'Daily_Targets', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Daily_Targets', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDaily_Targets', @del_cmd = N'CALL sp_MSdel_dboDaily_Targets', @upd_cmd = N'SCALL sp_MSupd_dboDaily_Targets'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'DB_Tables', @source_owner = N'dbo', @source_object = N'DB_Tables', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'DB_Tables', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDB_Tables', @del_cmd = N'CALL sp_MSdel_dboDB_Tables', @upd_cmd = N'SCALL sp_MSupd_dboDB_Tables'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Delivery_Trip_Orders', @source_owner = N'dbo', @source_object = N'Delivery_Trip_Orders', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Delivery_Trip_Orders', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDelivery_Trip_Orders', @del_cmd = N'CALL sp_MSdel_dboDelivery_Trip_Orders', @upd_cmd = N'SCALL sp_MSupd_dboDelivery_Trip_Orders'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Delivery_Trips', @source_owner = N'dbo', @source_object = N'Delivery_Trips', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Delivery_Trips', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDelivery_Trips', @del_cmd = N'CALL sp_MSdel_dboDelivery_Trips', @upd_cmd = N'SCALL sp_MSupd_dboDelivery_Trips'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Departments', @source_owner = N'dbo', @source_object = N'Departments', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Departments', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDepartments', @del_cmd = N'CALL sp_MSdel_dboDepartments', @upd_cmd = N'SCALL sp_MSupd_dboDepartments'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Devices_Brands', @source_owner = N'dbo', @source_object = N'Devices_Brands', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Devices_Brands', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDevices_Brands', @del_cmd = N'CALL sp_MSdel_dboDevices_Brands', @upd_cmd = N'SCALL sp_MSupd_dboDevices_Brands'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Devices_Serials', @source_owner = N'dbo', @source_object = N'Devices_Serials', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Devices_Serials', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDevices_Serials', @del_cmd = N'CALL sp_MSdel_dboDevices_Serials', @upd_cmd = N'SCALL sp_MSupd_dboDevices_Serials'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Devices_Statuses', @source_owner = N'dbo', @source_object = N'Devices_Statuses', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Devices_Statuses', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDevices_Statuses', @del_cmd = N'CALL sp_MSdel_dboDevices_Statuses', @upd_cmd = N'SCALL sp_MSupd_dboDevices_Statuses'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Devices_Types', @source_owner = N'dbo', @source_object = N'Devices_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Devices_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDevices_Types', @del_cmd = N'CALL sp_MSdel_dboDevices_Types', @upd_cmd = N'SCALL sp_MSupd_dboDevices_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Distribution_Channels', @source_owner = N'dbo', @source_object = N'Distribution_Channels', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Distribution_Channels', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDistribution_Channels', @del_cmd = N'CALL sp_MSdel_dboDistribution_Channels', @upd_cmd = N'SCALL sp_MSupd_dboDistribution_Channels'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Distributors', @source_owner = N'dbo', @source_object = N'Distributors', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Distributors', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDistributors', @del_cmd = N'CALL sp_MSdel_dboDistributors', @upd_cmd = N'SCALL sp_MSupd_dboDistributors'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Divisions', @source_owner = N'dbo', @source_object = N'Divisions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Divisions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboDivisions', @del_cmd = N'CALL sp_MSdel_dboDivisions', @upd_cmd = N'SCALL sp_MSupd_dboDivisions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ERP_Payment_Allocations', @source_owner = N'dbo', @source_object = N'ERP_Payment_Allocations', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ERP_Payment_Allocations', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboERP_Payment_Allocations', @del_cmd = N'CALL sp_MSdel_dboERP_Payment_Allocations', @upd_cmd = N'SCALL sp_MSupd_dboERP_Payment_Allocations'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'ERP_TRIP_STATUS', @source_owner = N'dbo', @source_object = N'ERP_TRIP_STATUS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ERP_TRIP_STATUS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboERP_TRIP_STATUS', @del_cmd = N'CALL sp_MSdel_dboERP_TRIP_STATUS', @upd_cmd = N'SCALL sp_MSupd_dboERP_TRIP_STATUS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Fact_Sheets', @source_owner = N'dbo', @source_object = N'Fact_Sheets', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Fact_Sheets', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFact_Sheets', @del_cmd = N'CALL sp_MSdel_dboFact_Sheets', @upd_cmd = N'SCALL sp_MSupd_dboFact_Sheets'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Flag_Journeys', @source_owner = N'dbo', @source_object = N'Flag_Journeys', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Flag_Journeys', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFlag_Journeys', @del_cmd = N'CALL sp_MSdel_dboFlag_Journeys', @upd_cmd = N'SCALL sp_MSupd_dboFlag_Journeys'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Flag_Movement_Headers', @source_owner = N'dbo', @source_object = N'Flag_Movement_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Flag_Movement_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFlag_Movement_Headers', @del_cmd = N'CALL sp_MSdel_dboFlag_Movement_Headers', @upd_cmd = N'SCALL sp_MSupd_dboFlag_Movement_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Flag_Payment_Headers', @source_owner = N'dbo', @source_object = N'Flag_Payment_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Flag_Payment_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFlag_Payment_Headers', @del_cmd = N'CALL sp_MSdel_dboFlag_Payment_Headers', @upd_cmd = N'SCALL sp_MSupd_dboFlag_Payment_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Flag_Trip_Helpers', @source_owner = N'dbo', @source_object = N'Flag_Trip_Helpers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Flag_Trip_Helpers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFlag_Trip_Helpers', @del_cmd = N'CALL sp_MSdel_dboFlag_Trip_Helpers', @upd_cmd = N'SCALL sp_MSupd_dboFlag_Trip_Helpers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Flag_Trips', @source_owner = N'dbo', @source_object = N'Flag_Trips', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Flag_Trips', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFlag_Trips', @del_cmd = N'CALL sp_MSdel_dboFlag_Trips', @upd_cmd = N'SCALL sp_MSupd_dboFlag_Trips'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Flag_TRX_Headers', @source_owner = N'dbo', @source_object = N'Flag_TRX_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Flag_TRX_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFlag_TRX_Headers', @del_cmd = N'CALL sp_MSdel_dboFlag_TRX_Headers', @upd_cmd = N'SCALL sp_MSupd_dboFlag_TRX_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Flag_Visits', @source_owner = N'dbo', @source_object = N'Flag_Visits', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Flag_Visits', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFlag_Visits', @del_cmd = N'CALL sp_MSdel_dboFlag_Visits', @upd_cmd = N'SCALL sp_MSupd_dboFlag_Visits'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Franchises', @source_owner = N'dbo', @source_object = N'Franchises', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Franchises', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboFranchises', @del_cmd = N'CALL sp_MSdel_dboFranchises', @upd_cmd = N'SCALL sp_MSupd_dboFranchises'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'General_Types', @source_owner = N'dbo', @source_object = N'General_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'General_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboGeneral_Types', @del_cmd = N'CALL sp_MSdel_dboGeneral_Types', @upd_cmd = N'SCALL sp_MSupd_dboGeneral_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'GPS_Radius', @source_owner = N'dbo', @source_object = N'GPS_Radius', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'GPS_Radius', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboGPS_Radius', @del_cmd = N'CALL sp_MSdel_dboGPS_Radius', @upd_cmd = N'SCALL sp_MSupd_dboGPS_Radius'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'HHT_Reports', @source_owner = N'dbo', @source_object = N'HHT_Reports', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'HHT_Reports', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboHHT_Reports', @del_cmd = N'CALL sp_MSdel_dboHHT_Reports', @upd_cmd = N'SCALL sp_MSupd_dboHHT_Reports'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Import_Table_Details', @source_owner = N'dbo', @source_object = N'Import_Table_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Import_Table_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboImport_Table_Details', @del_cmd = N'CALL sp_MSdel_dboImport_Table_Details', @upd_cmd = N'SCALL sp_MSupd_dboImport_Table_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Import_Table_Headers', @source_owner = N'dbo', @source_object = N'Import_Table_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Import_Table_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboImport_Table_Headers', @del_cmd = N'CALL sp_MSdel_dboImport_Table_Headers', @upd_cmd = N'SCALL sp_MSupd_dboImport_Table_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Import_Table_Indexes', @source_owner = N'dbo', @source_object = N'Import_Table_Indexes', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Import_Table_Indexes', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboImport_Table_Indexes', @del_cmd = N'CALL sp_MSdel_dboImport_Table_Indexes', @upd_cmd = N'SCALL sp_MSupd_dboImport_Table_Indexes'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Import_Table_Unique_Indexes', @source_owner = N'dbo', @source_object = N'Import_Table_Unique_Indexes', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Import_Table_Unique_Indexes', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboImport_Table_Unique_Indexes', @del_cmd = N'CALL sp_MSdel_dboImport_Table_Unique_Indexes', @upd_cmd = N'SCALL sp_MSupd_dboImport_Table_Unique_Indexes'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Alternate_Per_Clients', @source_owner = N'dbo', @source_object = N'Item_Alternate_Per_Clients', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Alternate_Per_Clients', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Alternate_Per_Clients', @del_cmd = N'CALL sp_MSdel_dboItem_Alternate_Per_Clients', @upd_cmd = N'SCALL sp_MSupd_dboItem_Alternate_Per_Clients'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Barcodes', @source_owner = N'dbo', @source_object = N'Item_Barcodes', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Barcodes', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Barcodes', @del_cmd = N'CALL sp_MSdel_dboItem_Barcodes', @upd_cmd = N'SCALL sp_MSupd_dboItem_Barcodes'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Blocking', @source_owner = N'dbo', @source_object = N'Item_Blocking', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Blocking', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Blocking', @del_cmd = N'CALL sp_MSdel_dboItem_Blocking', @upd_cmd = N'SCALL sp_MSupd_dboItem_Blocking'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Distribution', @source_owner = N'dbo', @source_object = N'Item_Distribution', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Distribution', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Distribution', @del_cmd = N'CALL sp_MSdel_dboItem_Distribution', @upd_cmd = N'SCALL sp_MSupd_dboItem_Distribution'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Distribution_Details', @source_owner = N'dbo', @source_object = N'Item_Distribution_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Distribution_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Distribution_Details', @del_cmd = N'CALL sp_MSdel_dboItem_Distribution_Details', @upd_cmd = N'SCALL sp_MSupd_dboItem_Distribution_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Distribution_Headers', @source_owner = N'dbo', @source_object = N'Item_Distribution_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Distribution_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Distribution_Headers', @del_cmd = N'CALL sp_MSdel_dboItem_Distribution_Headers', @upd_cmd = N'SCALL sp_MSupd_dboItem_Distribution_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Divisions', @source_owner = N'dbo', @source_object = N'Item_Divisions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Divisions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Divisions', @del_cmd = N'CALL sp_MSdel_dboItem_Divisions', @upd_cmd = N'SCALL sp_MSupd_dboItem_Divisions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Groups', @source_owner = N'dbo', @source_object = N'Item_Groups', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Groups', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Groups', @del_cmd = N'CALL sp_MSdel_dboItem_Groups', @upd_cmd = N'SCALL sp_MSupd_dboItem_Groups'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Levelings', @source_owner = N'dbo', @source_object = N'Item_Levelings', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Levelings', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Levelings', @del_cmd = N'CALL sp_MSdel_dboItem_Levelings', @upd_cmd = N'SCALL sp_MSupd_dboItem_Levelings'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Master_Additional_Info', @source_owner = N'dbo', @source_object = N'Item_Master_Additional_Info', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Master_Additional_Info', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Master_Additional_Info', @del_cmd = N'CALL sp_MSdel_dboItem_Master_Additional_Info', @upd_cmd = N'SCALL sp_MSupd_dboItem_Master_Additional_Info'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Item_Masters', @source_owner = N'dbo', @source_object = N'Item_Masters', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Item_Masters', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItem_Masters', @del_cmd = N'CALL sp_MSdel_dboItem_Masters', @upd_cmd = N'SCALL sp_MSupd_dboItem_Masters'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Items_Groups_Levels', @source_owner = N'dbo', @source_object = N'Items_Groups_Levels', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Items_Groups_Levels', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItems_Groups_Levels', @del_cmd = N'CALL sp_MSdel_dboItems_Groups_Levels', @upd_cmd = N'SCALL sp_MSupd_dboItems_Groups_Levels'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Items_Lots', @source_owner = N'dbo', @source_object = N'Items_Lots', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Items_Lots', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItems_Lots', @del_cmd = N'CALL sp_MSdel_dboItems_Lots', @upd_cmd = N'SCALL sp_MSupd_dboItems_Lots'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Items_Serials', @source_owner = N'dbo', @source_object = N'Items_Serials', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Items_Serials', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboItems_Serials', @del_cmd = N'CALL sp_MSdel_dboItems_Serials', @upd_cmd = N'SCALL sp_MSupd_dboItems_Serials'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Journey_Devices', @source_owner = N'dbo', @source_object = N'Journey_Devices', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Journey_Devices', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboJourney_Devices', @del_cmd = N'CALL sp_MSdel_dboJourney_Devices', @upd_cmd = N'SCALL sp_MSupd_dboJourney_Devices'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Journey_Executives', @source_owner = N'dbo', @source_object = N'Journey_Executives', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Journey_Executives', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboJourney_Executives', @del_cmd = N'CALL sp_MSdel_dboJourney_Executives', @upd_cmd = N'SCALL sp_MSupd_dboJourney_Executives'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Journeys', @source_owner = N'dbo', @source_object = N'Journeys', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Journeys', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboJourneys', @del_cmd = N'CALL sp_MSdel_dboJourneys', @upd_cmd = N'SCALL sp_MSupd_dboJourneys'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Language_Labels_HHT', @source_owner = N'dbo', @source_object = N'Language_Labels_HHT', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Language_Labels_HHT', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLanguage_Labels_HHT', @del_cmd = N'CALL sp_MSdel_dboLanguage_Labels_HHT', @upd_cmd = N'SCALL sp_MSupd_dboLanguage_Labels_HHT'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Language_Labels_PC', @source_owner = N'dbo', @source_object = N'Language_Labels_PC', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Language_Labels_PC', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLanguage_Labels_PC', @del_cmd = N'CALL sp_MSdel_dboLanguage_Labels_PC', @upd_cmd = N'SCALL sp_MSupd_dboLanguage_Labels_PC'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Languages', @source_owner = N'dbo', @source_object = N'Languages', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Languages', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLanguages', @del_cmd = N'CALL sp_MSdel_dboLanguages', @upd_cmd = N'SCALL sp_MSupd_dboLanguages'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Layout_Ctrl_State', @source_owner = N'dbo', @source_object = N'Layout_Ctrl_State', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Layout_Ctrl_State', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLayout_Ctrl_State', @del_cmd = N'CALL sp_MSdel_dboLayout_Ctrl_State', @upd_cmd = N'SCALL sp_MSupd_dboLayout_Ctrl_State'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Layout_Users', @source_owner = N'dbo', @source_object = N'Layout_Users', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Layout_Users', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLayout_Users', @del_cmd = N'CALL sp_MSdel_dboLayout_Users', @upd_cmd = N'SCALL sp_MSupd_dboLayout_Users'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Layouts', @source_owner = N'dbo', @source_object = N'Layouts', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Layouts', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLayouts', @del_cmd = N'CALL sp_MSdel_dboLayouts', @upd_cmd = N'SCALL sp_MSupd_dboLayouts'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Load_Template_Details', @source_owner = N'dbo', @source_object = N'Load_Template_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Load_Template_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLoad_Template_Details', @del_cmd = N'CALL sp_MSdel_dboLoad_Template_Details', @upd_cmd = N'SCALL sp_MSupd_dboLoad_Template_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Load_Template_Headers', @source_owner = N'dbo', @source_object = N'Load_Template_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Load_Template_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLoad_Template_Headers', @del_cmd = N'CALL sp_MSdel_dboLoad_Template_Headers', @upd_cmd = N'SCALL sp_MSupd_dboLoad_Template_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Load_Template_Vehicles', @source_owner = N'dbo', @source_object = N'Load_Template_Vehicles', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Load_Template_Vehicles', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLoad_Template_Vehicles', @del_cmd = N'CALL sp_MSdel_dboLoad_Template_Vehicles', @upd_cmd = N'SCALL sp_MSupd_dboLoad_Template_Vehicles'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Log_Files', @source_owner = N'dbo', @source_object = N'Log_Files', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Log_Files', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLog_Files', @del_cmd = N'CALL sp_MSdel_dboLog_Files', @upd_cmd = N'SCALL sp_MSupd_dboLog_Files'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Lookup_Table_Details', @source_owner = N'dbo', @source_object = N'Lookup_Table_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Lookup_Table_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLookup_Table_Details', @del_cmd = N'CALL sp_MSdel_dboLookup_Table_Details', @upd_cmd = N'SCALL sp_MSupd_dboLookup_Table_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Lookup_Table_Headers', @source_owner = N'dbo', @source_object = N'Lookup_Table_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Lookup_Table_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLookup_Table_Headers', @del_cmd = N'CALL sp_MSdel_dboLookup_Table_Headers', @upd_cmd = N'SCALL sp_MSupd_dboLookup_Table_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Lost_Sales_TRX', @source_owner = N'dbo', @source_object = N'Lost_Sales_TRX', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Lost_Sales_TRX', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLost_Sales_TRX', @del_cmd = N'CALL sp_MSdel_dboLost_Sales_TRX', @upd_cmd = N'SCALL sp_MSupd_dboLost_Sales_TRX'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'LRBs', @source_owner = N'dbo', @source_object = N'LRBs', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'LRBs', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboLRBs', @del_cmd = N'CALL sp_MSdel_dboLRBs', @upd_cmd = N'SCALL sp_MSupd_dboLRBs'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Machine_Registration', @source_owner = N'dbo', @source_object = N'Machine_Registration', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Machine_Registration', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboMachine_Registration', @del_cmd = N'CALL sp_MSdel_dboMachine_Registration', @upd_cmd = N'SCALL sp_MSupd_dboMachine_Registration'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Messages', @source_owner = N'dbo', @source_object = N'Messages', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Messages', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboMessages', @del_cmd = N'CALL sp_MSdel_dboMessages', @upd_cmd = N'SCALL sp_MSupd_dboMessages'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Monthly_Targets', @source_owner = N'dbo', @source_object = N'Monthly_Targets', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Monthly_Targets', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboMonthly_Targets', @del_cmd = N'CALL sp_MSdel_dboMonthly_Targets', @upd_cmd = N'SCALL sp_MSupd_dboMonthly_Targets'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Mouhafazats', @source_owner = N'dbo', @source_object = N'Mouhafazats', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Mouhafazats', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboMouhafazats', @del_cmd = N'CALL sp_MSdel_dboMouhafazats', @upd_cmd = N'SCALL sp_MSupd_dboMouhafazats'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Movement_Details', @source_owner = N'dbo', @source_object = N'Movement_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Movement_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboMovement_Details', @del_cmd = N'CALL sp_MSdel_dboMovement_Details', @upd_cmd = N'SCALL sp_MSupd_dboMovement_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Movement_Headers', @source_owner = N'dbo', @source_object = N'Movement_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Movement_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboMovement_Headers', @del_cmd = N'CALL sp_MSdel_dboMovement_Headers', @upd_cmd = N'SCALL sp_MSupd_dboMovement_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Movement_Item_Distribution', @source_owner = N'dbo', @source_object = N'Movement_Item_Distribution', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Movement_Item_Distribution', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboMovement_Item_Distribution', @del_cmd = N'CALL sp_MSdel_dboMovement_Item_Distribution', @upd_cmd = N'SCALL sp_MSupd_dboMovement_Item_Distribution'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Note_Email_Addresses', @source_owner = N'dbo', @source_object = N'Note_Email_Addresses', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Note_Email_Addresses', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboNote_Email_Addresses', @del_cmd = N'CALL sp_MSdel_dboNote_Email_Addresses', @upd_cmd = N'SCALL sp_MSupd_dboNote_Email_Addresses'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Note_Types', @source_owner = N'dbo', @source_object = N'Note_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Note_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboNote_Types', @del_cmd = N'CALL sp_MSdel_dboNote_Types', @upd_cmd = N'SCALL sp_MSupd_dboNote_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Notes', @source_owner = N'dbo', @source_object = N'Notes', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Notes', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboNotes', @del_cmd = N'CALL sp_MSdel_dboNotes', @upd_cmd = N'SCALL sp_MSupd_dboNotes'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Notification_Email_Addresses', @source_owner = N'dbo', @source_object = N'Notification_Email_Addresses', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Notification_Email_Addresses', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboNotification_Email_Addresses', @del_cmd = N'CALL sp_MSdel_dboNotification_Email_Addresses', @upd_cmd = N'SCALL sp_MSupd_dboNotification_Email_Addresses'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Notification_Types', @source_owner = N'dbo', @source_object = N'Notification_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Notification_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboNotification_Types', @del_cmd = N'CALL sp_MSdel_dboNotification_Types', @upd_cmd = N'SCALL sp_MSupd_dboNotification_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'OBIEE_Customer_Target_Detail', @source_owner = N'dbo', @source_object = N'OBIEE_Customer_Target_Detail', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'OBIEE_Customer_Target_Detail', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOBIEE_Customer_Target_Detail', @del_cmd = N'CALL sp_MSdel_dboOBIEE_Customer_Target_Detail', @upd_cmd = N'SCALL sp_MSupd_dboOBIEE_Customer_Target_Detail'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'OBIEE_Customer_Target_Header', @source_owner = N'dbo', @source_object = N'OBIEE_Customer_Target_Header', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'OBIEE_Customer_Target_Header', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOBIEE_Customer_Target_Header', @del_cmd = N'CALL sp_MSdel_dboOBIEE_Customer_Target_Header', @upd_cmd = N'SCALL sp_MSupd_dboOBIEE_Customer_Target_Header'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Online_Order_Details', @source_owner = N'dbo', @source_object = N'Online_Order_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Online_Order_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOnline_Order_Details', @del_cmd = N'CALL sp_MSdel_dboOnline_Order_Details', @upd_cmd = N'SCALL sp_MSupd_dboOnline_Order_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Online_Order_Headers', @source_owner = N'dbo', @source_object = N'Online_Order_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Online_Order_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOnline_Order_Headers', @del_cmd = N'CALL sp_MSdel_dboOnline_Order_Headers', @upd_cmd = N'SCALL sp_MSupd_dboOnline_Order_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Open_TRX_Details', @source_owner = N'dbo', @source_object = N'Open_TRX_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Open_TRX_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOpen_TRX_Details', @del_cmd = N'CALL sp_MSdel_dboOpen_TRX_Details', @upd_cmd = N'SCALL sp_MSupd_dboOpen_TRX_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Open_TRX_Headers', @source_owner = N'dbo', @source_object = N'Open_TRX_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Open_TRX_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOpen_TRX_Headers', @del_cmd = N'CALL sp_MSdel_dboOpen_TRX_Headers', @upd_cmd = N'SCALL sp_MSupd_dboOpen_TRX_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'OrderSource', @source_owner = N'dbo', @source_object = N'OrderSource', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'OrderSource', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOrderSource', @del_cmd = N'CALL sp_MSdel_dboOrderSource', @upd_cmd = N'SCALL sp_MSupd_dboOrderSource'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Organizations', @source_owner = N'dbo', @source_object = N'Organizations', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Organizations', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOrganizations', @del_cmd = N'CALL sp_MSdel_dboOrganizations', @upd_cmd = N'SCALL sp_MSupd_dboOrganizations'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Outstanding_PDC', @source_owner = N'dbo', @source_object = N'Outstanding_PDC', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Outstanding_PDC', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOutstanding_PDC', @del_cmd = N'CALL sp_MSdel_dboOutstanding_PDC', @upd_cmd = N'SCALL sp_MSupd_dboOutstanding_PDC'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Outstanding_Trx', @source_owner = N'dbo', @source_object = N'Outstanding_Trx', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Outstanding_Trx', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboOutstanding_Trx', @del_cmd = N'CALL sp_MSdel_dboOutstanding_Trx', @upd_cmd = N'SCALL sp_MSupd_dboOutstanding_Trx'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Parameter_Assignments', @source_owner = N'dbo', @source_object = N'Parameter_Assignments', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Parameter_Assignments', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboParameter_Assignments', @del_cmd = N'CALL sp_MSdel_dboParameter_Assignments', @upd_cmd = N'SCALL sp_MSupd_dboParameter_Assignments'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Parameter_Options', @source_owner = N'dbo', @source_object = N'Parameter_Options', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Parameter_Options', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboParameter_Options', @del_cmd = N'CALL sp_MSdel_dboParameter_Options', @upd_cmd = N'SCALL sp_MSupd_dboParameter_Options'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Parameter_Options_Desc', @source_owner = N'dbo', @source_object = N'Parameter_Options_Desc', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Parameter_Options_Desc', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboParameter_Options_Desc', @del_cmd = N'CALL sp_MSdel_dboParameter_Options_Desc', @upd_cmd = N'SCALL sp_MSupd_dboParameter_Options_Desc'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Parameters', @source_owner = N'dbo', @source_object = N'Parameters', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Parameters', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboParameters', @del_cmd = N'CALL sp_MSdel_dboParameters', @upd_cmd = N'SCALL sp_MSupd_dboParameters'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Payment_Details', @source_owner = N'dbo', @source_object = N'Payment_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Payment_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPayment_Details', @del_cmd = N'CALL sp_MSdel_dboPayment_Details', @upd_cmd = N'SCALL sp_MSupd_dboPayment_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Payment_Documents', @source_owner = N'dbo', @source_object = N'Payment_Documents', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Payment_Documents', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPayment_Documents', @del_cmd = N'CALL sp_MSdel_dboPayment_Documents', @upd_cmd = N'SCALL sp_MSupd_dboPayment_Documents'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Payment_Headers', @source_owner = N'dbo', @source_object = N'Payment_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Payment_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPayment_Headers', @del_cmd = N'CALL sp_MSdel_dboPayment_Headers', @upd_cmd = N'SCALL sp_MSupd_dboPayment_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Payment_Invoices', @source_owner = N'dbo', @source_object = N'Payment_Invoices', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Payment_Invoices', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPayment_Invoices', @del_cmd = N'CALL sp_MSdel_dboPayment_Invoices', @upd_cmd = N'SCALL sp_MSupd_dboPayment_Invoices'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Payment_Terms', @source_owner = N'dbo', @source_object = N'Payment_Terms', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Payment_Terms', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPayment_Terms', @del_cmd = N'CALL sp_MSdel_dboPayment_Terms', @upd_cmd = N'SCALL sp_MSupd_dboPayment_Terms'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'PC_Reports', @source_owner = N'dbo', @source_object = N'PC_Reports', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'PC_Reports', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPC_Reports', @del_cmd = N'CALL sp_MSdel_dboPC_Reports', @upd_cmd = N'SCALL sp_MSupd_dboPC_Reports'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'PF_Details', @source_owner = N'dbo', @source_object = N'PF_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'PF_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPF_Details', @del_cmd = N'CALL sp_MSdel_dboPF_Details', @upd_cmd = N'SCALL sp_MSupd_dboPF_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'PF_Headers', @source_owner = N'dbo', @source_object = N'PF_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'PF_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPF_Headers', @del_cmd = N'CALL sp_MSdel_dboPF_Headers', @upd_cmd = N'SCALL sp_MSupd_dboPF_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Picture_Info', @source_owner = N'dbo', @source_object = N'Picture_Info', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Picture_Info', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPicture_Info', @del_cmd = N'CALL sp_MSdel_dboPicture_Info', @upd_cmd = N'SCALL sp_MSupd_dboPicture_Info'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Picture_Types', @source_owner = N'dbo', @source_object = N'Picture_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Picture_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPicture_Types', @del_cmd = N'CALL sp_MSdel_dboPicture_Types', @upd_cmd = N'SCALL sp_MSupd_dboPicture_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'POS_Coverages', @source_owner = N'dbo', @source_object = N'POS_Coverages', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'POS_Coverages', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPOS_Coverages', @del_cmd = N'CALL sp_MSdel_dboPOS_Coverages', @upd_cmd = N'SCALL sp_MSupd_dboPOS_Coverages'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'PR_DR_ADSD_Assignment', @source_owner = N'dbo', @source_object = N'PR_DR_ADSD_Assignment', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'PR_DR_ADSD_Assignment', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPR_DR_ADSD_Assignment', @del_cmd = N'CALL sp_MSdel_dboPR_DR_ADSD_Assignment', @upd_cmd = N'SCALL sp_MSupd_dboPR_DR_ADSD_Assignment'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Pre_Trx_Details', @source_owner = N'dbo', @source_object = N'Pre_Trx_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Pre_Trx_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPre_Trx_Details', @del_cmd = N'CALL sp_MSdel_dboPre_Trx_Details', @upd_cmd = N'SCALL sp_MSupd_dboPre_Trx_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Pre_TRX_Headers', @source_owner = N'dbo', @source_object = N'Pre_TRX_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Pre_TRX_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPre_TRX_Headers', @del_cmd = N'CALL sp_MSdel_dboPre_TRX_Headers', @upd_cmd = N'SCALL sp_MSupd_dboPre_TRX_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Pre_Trx_Trip_Status', @source_owner = N'dbo', @source_object = N'Pre_Trx_Trip_Status', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Pre_Trx_Trip_Status', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPre_Trx_Trip_Status', @del_cmd = N'CALL sp_MSdel_dboPre_Trx_Trip_Status', @upd_cmd = N'SCALL sp_MSupd_dboPre_Trx_Trip_Status'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Price_List_Assignments', @source_owner = N'dbo', @source_object = N'Price_List_Assignments', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Price_List_Assignments', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrice_List_Assignments', @del_cmd = N'CALL sp_MSdel_dboPrice_List_Assignments', @upd_cmd = N'SCALL sp_MSupd_dboPrice_List_Assignments'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Price_List_Calc_Types', @source_owner = N'dbo', @source_object = N'Price_List_Calc_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Price_List_Calc_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrice_List_Calc_Types', @del_cmd = N'CALL sp_MSdel_dboPrice_List_Calc_Types', @upd_cmd = N'SCALL sp_MSupd_dboPrice_List_Calc_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Price_List_Types', @source_owner = N'dbo', @source_object = N'Price_List_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Price_List_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrice_List_Types', @del_cmd = N'CALL sp_MSdel_dboPrice_List_Types', @upd_cmd = N'SCALL sp_MSupd_dboPrice_List_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Price_Lists', @source_owner = N'dbo', @source_object = N'Price_Lists', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Price_Lists', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrice_Lists', @del_cmd = N'CALL sp_MSdel_dboPrice_Lists', @upd_cmd = N'SCALL sp_MSupd_dboPrice_Lists'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Price_Protection_Details', @source_owner = N'dbo', @source_object = N'Price_Protection_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Price_Protection_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrice_Protection_Details', @del_cmd = N'CALL sp_MSdel_dboPrice_Protection_Details', @upd_cmd = N'SCALL sp_MSupd_dboPrice_Protection_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Price_Protection_Headers', @source_owner = N'dbo', @source_object = N'Price_Protection_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Price_Protection_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrice_Protection_Headers', @del_cmd = N'CALL sp_MSdel_dboPrice_Protection_Headers', @upd_cmd = N'SCALL sp_MSupd_dboPrice_Protection_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Prices', @source_owner = N'dbo', @source_object = N'Prices', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Prices', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrices', @del_cmd = N'CALL sp_MSdel_dboPrices', @upd_cmd = N'SCALL sp_MSupd_dboPrices'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Printer_List', @source_owner = N'dbo', @source_object = N'Printer_List', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Printer_List', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrinter_List', @del_cmd = N'CALL sp_MSdel_dboPrinter_List', @upd_cmd = N'SCALL sp_MSupd_dboPrinter_List'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'PrintOut_Types', @source_owner = N'dbo', @source_object = N'PrintOut_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'PrintOut_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPrintOut_Types', @del_cmd = N'CALL sp_MSdel_dboPrintOut_Types', @upd_cmd = N'SCALL sp_MSupd_dboPrintOut_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Advanced_Rule_Details', @source_owner = N'dbo', @source_object = N'Promo_Advanced_Rule_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Advanced_Rule_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Advanced_Rule_Details', @del_cmd = N'CALL sp_MSdel_dboPromo_Advanced_Rule_Details', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Advanced_Rule_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Advanced_Rule_Hierarchy', @source_owner = N'dbo', @source_object = N'Promo_Advanced_Rule_Hierarchy', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Advanced_Rule_Hierarchy', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Advanced_Rule_Hierarchy', @del_cmd = N'CALL sp_MSdel_dboPromo_Advanced_Rule_Hierarchy', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Advanced_Rule_Hierarchy'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Advanced_Rule_Relation', @source_owner = N'dbo', @source_object = N'Promo_Advanced_Rule_Relation', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Advanced_Rule_Relation', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Advanced_Rule_Relation', @del_cmd = N'CALL sp_MSdel_dboPromo_Advanced_Rule_Relation', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Advanced_Rule_Relation'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Advanced_Rules', @source_owner = N'dbo', @source_object = N'Promo_Advanced_Rules', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Advanced_Rules', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Advanced_Rules', @del_cmd = N'CALL sp_MSdel_dboPromo_Advanced_Rules', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Advanced_Rules'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Allocations', @source_owner = N'dbo', @source_object = N'Promo_Allocations', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Allocations', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Allocations', @del_cmd = N'CALL sp_MSdel_dboPromo_Allocations', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Allocations'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Assignments', @source_owner = N'dbo', @source_object = N'Promo_Assignments', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Assignments', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Assignments', @del_cmd = N'CALL sp_MSdel_dboPromo_Assignments', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Assignments'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Client_Basket_Details', @source_owner = N'dbo', @source_object = N'Promo_Client_Basket_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Client_Basket_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Client_Basket_Details', @del_cmd = N'CALL sp_MSdel_dboPromo_Client_Basket_Details', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Client_Basket_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Client_Basket_Headers', @source_owner = N'dbo', @source_object = N'Promo_Client_Basket_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Client_Basket_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Client_Basket_Headers', @del_cmd = N'CALL sp_MSdel_dboPromo_Client_Basket_Headers', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Client_Basket_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Details_Bundles', @source_owner = N'dbo', @source_object = N'Promo_Details_Bundles', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Details_Bundles', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Details_Bundles', @del_cmd = N'CALL sp_MSdel_dboPromo_Details_Bundles', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Details_Bundles'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Details_FamilyToFamily', @source_owner = N'dbo', @source_object = N'Promo_Details_FamilyToFamily', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Details_FamilyToFamily', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Details_FamilyToFamily', @del_cmd = N'CALL sp_MSdel_dboPromo_Details_FamilyToFamily', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Details_FamilyToFamily'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Details_FamilyToFamily_Rules', @source_owner = N'dbo', @source_object = N'Promo_Details_FamilyToFamily_Rules', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Details_FamilyToFamily_Rules', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Details_FamilyToFamily_Rules', @del_cmd = N'CALL sp_MSdel_dboPromo_Details_FamilyToFamily_Rules', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Details_FamilyToFamily_Rules'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Details_Instant', @source_owner = N'dbo', @source_object = N'Promo_Details_Instant', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Details_Instant', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Details_Instant', @del_cmd = N'CALL sp_MSdel_dboPromo_Details_Instant', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Details_Instant'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Details_Structural_Discount_Rules', @source_owner = N'dbo', @source_object = N'Promo_Details_Structural_Discount_Rules', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Details_Structural_Discount_Rules', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Details_Structural_Discount_Rules', @del_cmd = N'CALL sp_MSdel_dboPromo_Details_Structural_Discount_Rules', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Details_Structural_Discount_Rules'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Details_Structural_Discounts', @source_owner = N'dbo', @source_object = N'Promo_Details_Structural_Discounts', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Details_Structural_Discounts', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Details_Structural_Discounts', @del_cmd = N'CALL sp_MSdel_dboPromo_Details_Structural_Discounts', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Details_Structural_Discounts'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Headers', @source_owner = N'dbo', @source_object = N'Promo_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Headers', @del_cmd = N'CALL sp_MSdel_dboPromo_Headers', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Item_Basket_Details', @source_owner = N'dbo', @source_object = N'Promo_Item_Basket_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Item_Basket_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Item_Basket_Details', @del_cmd = N'CALL sp_MSdel_dboPromo_Item_Basket_Details', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Item_Basket_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Item_Basket_Headers', @source_owner = N'dbo', @source_object = N'Promo_Item_Basket_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Item_Basket_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Item_Basket_Headers', @del_cmd = N'CALL sp_MSdel_dboPromo_Item_Basket_Headers', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Item_Basket_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Rule_Types', @source_owner = N'dbo', @source_object = N'Promo_Rule_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Rule_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Rule_Types', @del_cmd = N'CALL sp_MSdel_dboPromo_Rule_Types', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Rule_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Promo_Simple_Instant', @source_owner = N'dbo', @source_object = N'Promo_Simple_Instant', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Promo_Simple_Instant', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboPromo_Simple_Instant', @del_cmd = N'CALL sp_MSdel_dboPromo_Simple_Instant', @upd_cmd = N'SCALL sp_MSupd_dboPromo_Simple_Instant'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Qadaas', @source_owner = N'dbo', @source_object = N'Qadaas', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Qadaas', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboQadaas', @del_cmd = N'CALL sp_MSdel_dboQadaas', @upd_cmd = N'SCALL sp_MSupd_dboQadaas'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'QRA_Details', @source_owner = N'dbo', @source_object = N'QRA_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'QRA_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboQRA_Details', @del_cmd = N'CALL sp_MSdel_dboQRA_Details', @upd_cmd = N'SCALL sp_MSupd_dboQRA_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'QRA_Headers', @source_owner = N'dbo', @source_object = N'QRA_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'QRA_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboQRA_Headers', @del_cmd = N'CALL sp_MSdel_dboQRA_Headers', @upd_cmd = N'SCALL sp_MSupd_dboQRA_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Ready_Query', @source_owner = N'dbo', @source_object = N'Ready_Query', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Ready_Query', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboReady_Query', @del_cmd = N'CALL sp_MSdel_dboReady_Query', @upd_cmd = N'SCALL sp_MSupd_dboReady_Query'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Reasons', @source_owner = N'dbo', @source_object = N'Reasons', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Reasons', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboReasons', @del_cmd = N'CALL sp_MSdel_dboReasons', @upd_cmd = N'SCALL sp_MSupd_dboReasons'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Regions', @source_owner = N'dbo', @source_object = N'Regions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Regions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRegions', @del_cmd = N'CALL sp_MSdel_dboRegions', @upd_cmd = N'SCALL sp_MSupd_dboRegions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Report_Columns', @source_owner = N'dbo', @source_object = N'Report_Columns', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Report_Columns', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboReport_Columns', @del_cmd = N'CALL sp_MSdel_dboReport_Columns', @upd_cmd = N'SCALL sp_MSupd_dboReport_Columns'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Report_Definition', @source_owner = N'dbo', @source_object = N'Report_Definition', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Report_Definition', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboReport_Definition', @del_cmd = N'CALL sp_MSdel_dboReport_Definition', @upd_cmd = N'SCALL sp_MSupd_dboReport_Definition'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Report_Levels', @source_owner = N'dbo', @source_object = N'Report_Levels', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Report_Levels', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboReport_Levels', @del_cmd = N'CALL sp_MSdel_dboReport_Levels', @upd_cmd = N'SCALL sp_MSupd_dboReport_Levels'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Report_Proc_Param', @source_owner = N'dbo', @source_object = N'Report_Proc_Param', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Report_Proc_Param', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboReport_Proc_Param', @del_cmd = N'CALL sp_MSdel_dboReport_Proc_Param', @upd_cmd = N'SCALL sp_MSupd_dboReport_Proc_Param'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Reports', @source_owner = N'dbo', @source_object = N'Reports', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Reports', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboReports', @del_cmd = N'CALL sp_MSdel_dboReports', @upd_cmd = N'SCALL sp_MSupd_dboReports'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'RoadNet_Export', @source_owner = N'dbo', @source_object = N'RoadNet_Export', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'RoadNet_Export', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRoadNet_Export', @del_cmd = N'CALL sp_MSdel_dboRoadNet_Export', @upd_cmd = N'SCALL sp_MSupd_dboRoadNet_Export'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'RoadNet_Import', @source_owner = N'dbo', @source_object = N'RoadNet_Import', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'RoadNet_Import', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRoadNet_Import', @del_cmd = N'CALL sp_MSdel_dboRoadNet_Import', @upd_cmd = N'SCALL sp_MSupd_dboRoadNet_Import'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Route_Client_Tracking', @source_owner = N'dbo', @source_object = N'Route_Client_Tracking', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Route_Client_Tracking', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRoute_Client_Tracking', @del_cmd = N'CALL sp_MSdel_dboRoute_Client_Tracking', @upd_cmd = N'SCALL sp_MSupd_dboRoute_Client_Tracking'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Route_Clients', @source_owner = N'dbo', @source_object = N'Route_Clients', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Route_Clients', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRoute_Clients', @del_cmd = N'CALL sp_MSdel_dboRoute_Clients', @upd_cmd = N'SCALL sp_MSupd_dboRoute_Clients'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Route_Constraint_Levels', @source_owner = N'dbo', @source_object = N'Route_Constraint_Levels', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Route_Constraint_Levels', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRoute_Constraint_Levels', @del_cmd = N'CALL sp_MSdel_dboRoute_Constraint_Levels', @upd_cmd = N'SCALL sp_MSupd_dboRoute_Constraint_Levels'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Route_Info', @source_owner = N'dbo', @source_object = N'Route_Info', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Route_Info', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRoute_Info', @del_cmd = N'CALL sp_MSdel_dboRoute_Info', @upd_cmd = N'SCALL sp_MSupd_dboRoute_Info'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Route_Users', @source_owner = N'dbo', @source_object = N'Route_Users', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Route_Users', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRoute_Users', @del_cmd = N'CALL sp_MSdel_dboRoute_Users', @upd_cmd = N'SCALL sp_MSupd_dboRoute_Users'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Routes', @source_owner = N'dbo', @source_object = N'Routes', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Routes', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRoutes', @del_cmd = N'CALL sp_MSdel_dboRoutes', @upd_cmd = N'SCALL sp_MSupd_dboRoutes'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'RVS_Journey_Tracking', @source_owner = N'dbo', @source_object = N'RVS_Journey_Tracking', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'RVS_Journey_Tracking', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboRVS_Journey_Tracking', @del_cmd = N'CALL sp_MSdel_dboRVS_Journey_Tracking', @upd_cmd = N'SCALL sp_MSupd_dboRVS_Journey_Tracking'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Sales_Planogram_Assignment', @source_owner = N'dbo', @source_object = N'Sales_Planogram_Assignment', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Sales_Planogram_Assignment', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSales_Planogram_Assignment', @del_cmd = N'CALL sp_MSdel_dboSales_Planogram_Assignment', @upd_cmd = N'SCALL sp_MSupd_dboSales_Planogram_Assignment'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Sales_Planogram_Template_Details', @source_owner = N'dbo', @source_object = N'Sales_Planogram_Template_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Sales_Planogram_Template_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSales_Planogram_Template_Details', @del_cmd = N'CALL sp_MSdel_dboSales_Planogram_Template_Details', @upd_cmd = N'SCALL sp_MSupd_dboSales_Planogram_Template_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Sales_Planogram_Template_Headers', @source_owner = N'dbo', @source_object = N'Sales_Planogram_Template_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Sales_Planogram_Template_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSales_Planogram_Template_Headers', @del_cmd = N'CALL sp_MSdel_dboSales_Planogram_Template_Headers', @upd_cmd = N'SCALL sp_MSupd_dboSales_Planogram_Template_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Scheduled_Visits', @source_owner = N'dbo', @source_object = N'Scheduled_Visits', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Scheduled_Visits', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboScheduled_Visits', @del_cmd = N'CALL sp_MSdel_dboScheduled_Visits', @upd_cmd = N'SCALL sp_MSupd_dboScheduled_Visits'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Season_Definitions', @source_owner = N'dbo', @source_object = N'Season_Definitions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Season_Definitions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSeason_Definitions', @del_cmd = N'CALL sp_MSdel_dboSeason_Definitions', @upd_cmd = N'SCALL sp_MSupd_dboSeason_Definitions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Share_Types', @source_owner = N'dbo', @source_object = N'Share_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Share_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboShare_Types', @del_cmd = N'CALL sp_MSdel_dboShare_Types', @upd_cmd = N'SCALL sp_MSupd_dboShare_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Source_Sub_Inventory', @source_owner = N'dbo', @source_object = N'Source_Sub_Inventory', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Source_Sub_Inventory', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSource_Sub_Inventory', @del_cmd = N'CALL sp_MSdel_dboSource_Sub_Inventory', @upd_cmd = N'SCALL sp_MSupd_dboSource_Sub_Inventory'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Stock_Count_Details', @source_owner = N'dbo', @source_object = N'Stock_Count_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Stock_Count_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboStock_Count_Details', @del_cmd = N'CALL sp_MSdel_dboStock_Count_Details', @upd_cmd = N'SCALL sp_MSupd_dboStock_Count_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Stock_Count_Headers', @source_owner = N'dbo', @source_object = N'Stock_Count_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Stock_Count_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboStock_Count_Headers', @del_cmd = N'CALL sp_MSdel_dboStock_Count_Headers', @upd_cmd = N'SCALL sp_MSupd_dboStock_Count_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Survey_Answer_Types', @source_owner = N'dbo', @source_object = N'Survey_Answer_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Survey_Answer_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSurvey_Answer_Types', @del_cmd = N'CALL sp_MSdel_dboSurvey_Answer_Types', @upd_cmd = N'SCALL sp_MSupd_dboSurvey_Answer_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Swap_Details', @source_owner = N'dbo', @source_object = N'Swap_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Swap_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSwap_Details', @del_cmd = N'CALL sp_MSdel_dboSwap_Details', @upd_cmd = N'SCALL sp_MSupd_dboSwap_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Swap_Headers', @source_owner = N'dbo', @source_object = N'Swap_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Swap_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSwap_Headers', @del_cmd = N'CALL sp_MSdel_dboSwap_Headers', @upd_cmd = N'SCALL sp_MSupd_dboSwap_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'sysdiagrams', @source_owner = N'dbo', @source_object = N'sysdiagrams', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'sysdiagrams', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dbosysdiagrams', @del_cmd = N'CALL sp_MSdel_dbosysdiagrams', @upd_cmd = N'SCALL sp_MSupd_dbosysdiagrams'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Target_Details', @source_owner = N'dbo', @source_object = N'Target_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Target_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTarget_Details', @del_cmd = N'CALL sp_MSdel_dboTarget_Details', @upd_cmd = N'SCALL sp_MSupd_dboTarget_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Target_Headers', @source_owner = N'dbo', @source_object = N'Target_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Target_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTarget_Headers', @del_cmd = N'CALL sp_MSdel_dboTarget_Headers', @upd_cmd = N'SCALL sp_MSupd_dboTarget_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Target_Types', @source_owner = N'dbo', @source_object = N'Target_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Target_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTarget_Types', @del_cmd = N'CALL sp_MSdel_dboTarget_Types', @upd_cmd = N'SCALL sp_MSupd_dboTarget_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Taxes', @source_owner = N'dbo', @source_object = N'Taxes', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Taxes', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTaxes', @del_cmd = N'CALL sp_MSdel_dboTaxes', @upd_cmd = N'SCALL sp_MSupd_dboTaxes'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_JOURNEYS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_JOURNEYS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_JOURNEYS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_JOURNEYS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_JOURNEYS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_JOURNEYS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_MOVEMENT_DETAILS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_MOVEMENT_DETAILS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_MOVEMENT_DETAILS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_MOVEMENT_DETAILS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_MOVEMENT_DETAILS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_MOVEMENT_DETAILS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_MOVEMENT_HEADERS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_MOVEMENT_HEADERS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_MOVEMENT_HEADERS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_MOVEMENT_HEADERS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_MOVEMENT_HEADERS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_MOVEMENT_HEADERS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_ORD_DETAILS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_ORD_DETAILS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_ORD_DETAILS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_ORD_DETAILS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_ORD_DETAILS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_ORD_DETAILS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_ORD_HEADERS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_ORD_HEADERS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_ORD_HEADERS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_ORD_HEADERS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_ORD_HEADERS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_ORD_HEADERS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_ORD_VISITS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_ORD_VISITS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_ORD_VISITS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_ORD_VISITS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_ORD_VISITS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_ORD_VISITS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_TRIPS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_TRIPS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_TRIPS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_TRIPS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_TRIPS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_TRIPS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_TRX_DETAILS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_TRX_DETAILS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_TRX_DETAILS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_TRX_DETAILS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_TRX_DETAILS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_TRX_DETAILS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_TRX_HEADERS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_TRX_HEADERS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_TRX_HEADERS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_TRX_HEADERS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_TRX_HEADERS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_TRX_HEADERS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_EXPORT_VISITS', @source_owner = N'dbo', @source_object = N'TEMP_EXPORT_VISITS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_EXPORT_VISITS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_EXPORT_VISITS', @del_cmd = N'CALL sp_MSdel_dboTEMP_EXPORT_VISITS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_EXPORT_VISITS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_JOURNEYS', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_JOURNEYS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_JOURNEYS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_JOURNEYS', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_JOURNEYS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_JOURNEYS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_PAYMENT_DETAILS', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_PAYMENT_DETAILS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_PAYMENT_DETAILS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_PAYMENT_DETAILS', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_PAYMENT_DETAILS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_PAYMENT_DETAILS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_PAYMENT_HEADERS', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_PAYMENT_HEADERS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_PAYMENT_HEADERS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_PAYMENT_HEADERS', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_PAYMENT_HEADERS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_PAYMENT_HEADERS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_PAYMENT_INVOICES', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_PAYMENT_INVOICES', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_PAYMENT_INVOICES', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_PAYMENT_INVOICES', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_PAYMENT_INVOICES', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_PAYMENT_INVOICES'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_TRIP_HELPERS', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_TRIP_HELPERS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_TRIP_HELPERS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_TRIP_HELPERS', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_TRIP_HELPERS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_TRIP_HELPERS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_TRIPS', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_TRIPS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_TRIPS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_TRIPS', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_TRIPS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_TRIPS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_TRX_DETAILS', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_TRX_DETAILS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_TRX_DETAILS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_TRX_DETAILS', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_TRX_DETAILS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_TRX_DETAILS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_TRX_HEADERS', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_TRX_HEADERS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_TRX_HEADERS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_TRX_HEADERS', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_TRX_HEADERS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_TRX_HEADERS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TEMP_REG_EXPORT_VISITS', @source_owner = N'dbo', @source_object = N'TEMP_REG_EXPORT_VISITS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TEMP_REG_EXPORT_VISITS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTEMP_REG_EXPORT_VISITS', @del_cmd = N'CALL sp_MSdel_dboTEMP_REG_EXPORT_VISITS', @upd_cmd = N'SCALL sp_MSupd_dboTEMP_REG_EXPORT_VISITS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TF_Cumulative_History', @source_owner = N'dbo', @source_object = N'TF_Cumulative_History', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TF_Cumulative_History', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTF_Cumulative_History', @del_cmd = N'CALL sp_MSdel_dboTF_Cumulative_History', @upd_cmd = N'SCALL sp_MSupd_dboTF_Cumulative_History'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TF_Details', @source_owner = N'dbo', @source_object = N'TF_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TF_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTF_Details', @del_cmd = N'CALL sp_MSdel_dboTF_Details', @upd_cmd = N'SCALL sp_MSupd_dboTF_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TF_Headers', @source_owner = N'dbo', @source_object = N'TF_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TF_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTF_Headers', @del_cmd = N'CALL sp_MSdel_dboTF_Headers', @upd_cmd = N'SCALL sp_MSupd_dboTF_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Trade_Fixtures', @source_owner = N'dbo', @source_object = N'Trade_Fixtures', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Trade_Fixtures', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTrade_Fixtures', @del_cmd = N'CALL sp_MSdel_dboTrade_Fixtures', @upd_cmd = N'SCALL sp_MSupd_dboTrade_Fixtures'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Transactional_Stock_Movements', @source_owner = N'dbo', @source_object = N'Transactional_Stock_Movements', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Transactional_Stock_Movements', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTransactional_Stock_Movements', @del_cmd = N'CALL sp_MSdel_dboTransactional_Stock_Movements', @upd_cmd = N'SCALL sp_MSupd_dboTransactional_Stock_Movements'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Trip_Helpers', @source_owner = N'dbo', @source_object = N'Trip_Helpers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Trip_Helpers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTrip_Helpers', @del_cmd = N'CALL sp_MSdel_dboTrip_Helpers', @upd_cmd = N'SCALL sp_MSupd_dboTrip_Helpers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Trips', @source_owner = N'dbo', @source_object = N'Trips', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Trips', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTrips', @del_cmd = N'CALL sp_MSdel_dboTrips', @upd_cmd = N'SCALL sp_MSupd_dboTrips'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Details', @source_owner = N'dbo', @source_object = N'TRX_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Details', @del_cmd = N'CALL sp_MSdel_dboTRX_Details', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Details_History', @source_owner = N'dbo', @source_object = N'TRX_Details_History', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Details_History', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Details_History', @del_cmd = N'CALL sp_MSdel_dboTRX_Details_History', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Details_History'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Headers', @source_owner = N'dbo', @source_object = N'TRX_Headers', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Headers', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Headers', @del_cmd = N'CALL sp_MSdel_dboTRX_Headers', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Headers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Headers_Info', @source_owner = N'dbo', @source_object = N'TRX_Headers_Info', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Headers_Info', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Headers_Info', @del_cmd = N'CALL sp_MSdel_dboTRX_Headers_Info', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Headers_Info'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Headers_Log', @source_owner = N'dbo', @source_object = N'TRX_Headers_Log', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Headers_Log', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Headers_Log', @del_cmd = N'CALL sp_MSdel_dboTRX_Headers_Log', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Headers_Log'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Item_Distribution', @source_owner = N'dbo', @source_object = N'TRX_Item_Distribution', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Item_Distribution', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Item_Distribution', @del_cmd = N'CALL sp_MSdel_dboTRX_Item_Distribution', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Item_Distribution'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Promo_Allocations', @source_owner = N'dbo', @source_object = N'TRX_Promo_Allocations', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Promo_Allocations', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Promo_Allocations', @del_cmd = N'CALL sp_MSdel_dboTRX_Promo_Allocations', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Promo_Allocations'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Promotions', @source_owner = N'dbo', @source_object = N'TRX_Promotions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Promotions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Promotions', @del_cmd = N'CALL sp_MSdel_dboTRX_Promotions', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Promotions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'TRX_Tracker', @source_owner = N'dbo', @source_object = N'TRX_Tracker', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TRX_Tracker', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboTRX_Tracker', @del_cmd = N'CALL sp_MSdel_dboTRX_Tracker', @upd_cmd = N'SCALL sp_MSupd_dboTRX_Tracker'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'UOMS', @source_owner = N'dbo', @source_object = N'UOMS', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'UOMS', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUOMS', @del_cmd = N'CALL sp_MSdel_dboUOMS', @upd_cmd = N'SCALL sp_MSupd_dboUOMS'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Access_Rights', @source_owner = N'dbo', @source_object = N'User_Access_Rights', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Access_Rights', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Access_Rights', @del_cmd = N'CALL sp_MSdel_dboUser_Access_Rights', @upd_cmd = N'SCALL sp_MSupd_dboUser_Access_Rights'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Branch_Plants', @source_owner = N'dbo', @source_object = N'User_Branch_Plants', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Branch_Plants', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Branch_Plants', @del_cmd = N'CALL sp_MSdel_dboUser_Branch_Plants', @upd_cmd = N'SCALL sp_MSupd_dboUser_Branch_Plants'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Device_Registration', @source_owner = N'dbo', @source_object = N'User_Device_Registration', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Device_Registration', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Device_Registration', @del_cmd = N'CALL sp_MSdel_dboUser_Device_Registration', @upd_cmd = N'SCALL sp_MSupd_dboUser_Device_Registration'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Device_Registration_History', @source_owner = N'dbo', @source_object = N'User_Device_Registration_History', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Device_Registration_History', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Device_Registration_History', @del_cmd = N'CALL sp_MSdel_dboUser_Device_Registration_History', @upd_cmd = N'SCALL sp_MSupd_dboUser_Device_Registration_History'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Devices', @source_owner = N'dbo', @source_object = N'User_Devices', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Devices', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Devices', @del_cmd = N'CALL sp_MSdel_dboUser_Devices', @upd_cmd = N'SCALL sp_MSupd_dboUser_Devices'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Divisions', @source_owner = N'dbo', @source_object = N'User_Divisions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Divisions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Divisions', @del_cmd = N'CALL sp_MSdel_dboUser_Divisions', @upd_cmd = N'SCALL sp_MSupd_dboUser_Divisions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Groups', @source_owner = N'dbo', @source_object = N'User_Groups', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Groups', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Groups', @del_cmd = N'CALL sp_MSdel_dboUser_Groups', @upd_cmd = N'SCALL sp_MSupd_dboUser_Groups'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_History_Cards', @source_owner = N'dbo', @source_object = N'User_History_Cards', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_History_Cards', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_History_Cards', @del_cmd = N'CALL sp_MSdel_dboUser_History_Cards', @upd_cmd = N'SCALL sp_MSupd_dboUser_History_Cards'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Import_Tables', @source_owner = N'dbo', @source_object = N'User_Import_Tables', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Import_Tables', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Import_Tables', @del_cmd = N'CALL sp_MSdel_dboUser_Import_Tables', @upd_cmd = N'SCALL sp_MSupd_dboUser_Import_Tables'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Item_Distribution', @source_owner = N'dbo', @source_object = N'User_Item_Distribution', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Item_Distribution', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Item_Distribution', @del_cmd = N'CALL sp_MSdel_dboUser_Item_Distribution', @upd_cmd = N'SCALL sp_MSupd_dboUser_Item_Distribution'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Parameters', @source_owner = N'dbo', @source_object = N'User_Parameters', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Parameters', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Parameters', @del_cmd = N'CALL sp_MSdel_dboUser_Parameters', @upd_cmd = N'SCALL sp_MSupd_dboUser_Parameters'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Parent_Hierarchy', @source_owner = N'dbo', @source_object = N'User_Parent_Hierarchy', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Parent_Hierarchy', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Parent_Hierarchy', @del_cmd = N'CALL sp_MSdel_dboUser_Parent_Hierarchy', @upd_cmd = N'SCALL sp_MSupd_dboUser_Parent_Hierarchy'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Parent_Link', @source_owner = N'dbo', @source_object = N'User_Parent_Link', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Parent_Link', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Parent_Link', @del_cmd = N'CALL sp_MSdel_dboUser_Parent_Link', @upd_cmd = N'SCALL sp_MSupd_dboUser_Parent_Link'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Reconciliation_Limit', @source_owner = N'dbo', @source_object = N'User_Reconciliation_Limit', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Reconciliation_Limit', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Reconciliation_Limit', @del_cmd = N'CALL sp_MSdel_dboUser_Reconciliation_Limit', @upd_cmd = N'SCALL sp_MSupd_dboUser_Reconciliation_Limit'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Regions', @source_owner = N'dbo', @source_object = N'User_Regions', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Regions', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Regions', @del_cmd = N'CALL sp_MSdel_dboUser_Regions', @upd_cmd = N'SCALL sp_MSupd_dboUser_Regions'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Reports', @source_owner = N'dbo', @source_object = N'User_Reports', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Reports', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Reports', @del_cmd = N'CALL sp_MSdel_dboUser_Reports', @upd_cmd = N'SCALL sp_MSupd_dboUser_Reports'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Sequences', @source_owner = N'dbo', @source_object = N'User_Sequences', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Sequences', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Sequences', @del_cmd = N'CALL sp_MSdel_dboUser_Sequences', @upd_cmd = N'SCALL sp_MSupd_dboUser_Sequences'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Types', @source_owner = N'dbo', @source_object = N'User_Types', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Types', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Types', @del_cmd = N'CALL sp_MSdel_dboUser_Types', @upd_cmd = N'SCALL sp_MSupd_dboUser_Types'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Vehicles', @source_owner = N'dbo', @source_object = N'User_Vehicles', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Vehicles', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Vehicles', @del_cmd = N'CALL sp_MSdel_dboUser_Vehicles', @upd_cmd = N'SCALL sp_MSupd_dboUser_Vehicles'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'User_Warehouses', @source_owner = N'dbo', @source_object = N'User_Warehouses', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'User_Warehouses', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUser_Warehouses', @del_cmd = N'CALL sp_MSdel_dboUser_Warehouses', @upd_cmd = N'SCALL sp_MSupd_dboUser_Warehouses'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Users', @source_owner = N'dbo', @source_object = N'Users', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Users', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboUsers', @del_cmd = N'CALL sp_MSdel_dboUsers', @upd_cmd = N'SCALL sp_MSupd_dboUsers'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Vehicle_Stock', @source_owner = N'dbo', @source_object = N'Vehicle_Stock', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Vehicle_Stock', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboVehicle_Stock', @del_cmd = N'CALL sp_MSdel_dboVehicle_Stock', @upd_cmd = N'SCALL sp_MSupd_dboVehicle_Stock'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Vehicle_Stock_Current', @source_owner = N'dbo', @source_object = N'Vehicle_Stock_Current', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Vehicle_Stock_Current', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboVehicle_Stock_Current', @del_cmd = N'CALL sp_MSdel_dboVehicle_Stock_Current', @upd_cmd = N'SCALL sp_MSupd_dboVehicle_Stock_Current'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Vehicles', @source_owner = N'dbo', @source_object = N'Vehicles', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Vehicles', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboVehicles', @del_cmd = N'CALL sp_MSdel_dboVehicles', @upd_cmd = N'SCALL sp_MSupd_dboVehicles'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Visit_Details', @source_owner = N'dbo', @source_object = N'Visit_Details', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Visit_Details', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboVisit_Details', @del_cmd = N'CALL sp_MSdel_dboVisit_Details', @upd_cmd = N'SCALL sp_MSupd_dboVisit_Details'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Visits', @source_owner = N'dbo', @source_object = N'Visits', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Visits', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboVisits', @del_cmd = N'CALL sp_MSdel_dboVisits', @upd_cmd = N'SCALL sp_MSupd_dboVisits'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'Warehouses', @source_owner = N'dbo', @source_object = N'Warehouses', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Warehouses', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboWarehouses', @del_cmd = N'CALL sp_MSdel_dboWarehouses', @upd_cmd = N'SCALL sp_MSupd_dboWarehouses'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'WH_Stock', @source_owner = N'dbo', @source_object = N'WH_Stock', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'WH_Stock', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboWH_Stock', @del_cmd = N'CALL sp_MSdel_dboWH_Stock', @upd_cmd = N'SCALL sp_MSupd_dboWH_Stock'
GO




use [ABP_SFA_BMB]
exec sp_addarticle @publication = N'ABP_SFA_BMB', @article = N'WHK_Post_Emails', @source_owner = N'dbo', @source_object = N'WHK_Post_Emails', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'WHK_Post_Emails', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboWHK_Post_Emails', @del_cmd = N'CALL sp_MSdel_dboWHK_Post_Emails', @upd_cmd = N'SCALL sp_MSupd_dboWHK_Post_Emails'
GO