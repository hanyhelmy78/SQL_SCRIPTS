-----------------BEGIN: Script to be run at Publisher 'RUH1ISELLABPT2'-----------------
--use [master]
exec sp_addsubscription @publication = N'ABC_BMB', @subscriber = N'ruh1isellabct2', @destination_db = N'ABP_SFA_BMB_SUBSCRIBER', @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
exec sp_addpushsubscription_agent @publication = N'ABP_SFA_BMB', @subscriber = N'ruh1isellabct2', @subscriber_db = N'ABP_SFA_BMB_SUBSCRIBER', @job_login = N'ALJOMAIHBEV\sqladmin', @job_password = null, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 20161016, @active_end_date = 99991231, @enabled_for_syncmgr = N'False', @dts_package_location = N'Distributor'
GO
-----------------END: Script to be run at Publisher 'RUH1ISELLABPT2'-----------------


-----------------BEGIN: Script to be run at Publisher 'RUH1ISELLABCT2'-----------------
use [ABP_SFA_BMB]
exec sp_addsubscription @publication = N'ABC_BMB', @subscriber = N'ruh1isellabpt2', @destination_db = N'ABP_SFA_BMB_SUBSCRIBER', @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
exec sp_addpushsubscription_agent @publication = N'ABC_BMB', @subscriber = N'ruh1isellabpt2', @subscriber_db = N'ABP_SFA_BMB_SUBSCRIBER', @job_login = N'ALJOMAIHBEV\sqladmin', @job_password = null, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 20161020, @active_end_date = 99991231, @enabled_for_syncmgr = N'False', @dts_package_location = N'Distributor'
GO
-----------------END: Script to be run at Publisher 'RUH1ISELLABCT2'-----------------

