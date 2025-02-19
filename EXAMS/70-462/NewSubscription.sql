-----------------BEGIN: Script to be run at Publisher 'HANY_ISD'-----------------
use [AdventureWorks2008R2]
exec sp_addsubscription @publication = N'NewPublication', @subscriber = N'HANY_ISD', @destination_db = N'SubscriberDatabase', @sync_type = N'Automatic', @subscription_type = N'pull', @update_mode = N'read only'
GO
-----------------END: Script to be run at Publisher 'HANY_ISD'-----------------

-----------------BEGIN: Script to be run at Subscriber 'HANY_ISD'-----------------
use [SubscriberDatabase]
exec sp_addpullsubscription @publisher = N'HANY_ISD', @publication = N'NewPublication', @publisher_db = N'AdventureWorks2008R2', @independent_agent = N'True', @subscription_type = N'pull', @description = N'', @update_mode = N'read only', @immediate_sync = 1

exec sp_addpullsubscription_agent @publisher = N'HANY_ISD', @publisher_db = N'AdventureWorks2008R2', @publication = N'NewPublication', @distributor = N'HANY_ISD', @distributor_security_mode = 1, @distributor_login = N'', @distributor_password = null, @enabled_for_syncmgr = N'False', @frequency_type = 64, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 20120829, @active_end_date = 99991231, @alt_snapshot_folder = N'', @working_directory = N'', @use_ftp = N'False', @job_login = N'Hany_ISD\hany-isd', @job_password = null, @publication_type = 0
GO
-----------------END: Script to be run at Subscriber 'HANY_ISD'-----------------

