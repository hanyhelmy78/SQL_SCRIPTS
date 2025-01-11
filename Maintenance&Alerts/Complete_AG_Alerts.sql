USE [msdb]
GO

/****** Object:  Alert [AlwaysOn - AG-Replica Changed States-Error(19406)]    Script Date: 9/28/2020 2:54:14 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn - AG-Replica Changed States-Error(19406)', 
		@message_id=19406, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn - AG-Replica Changed States-Error(19406) 
		Replica State Changed because of startup , Failover,Communication issue , or Cluster issue,
		invistigate why this accurred to determind what is the action needs to be taken', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn - AG-Replica Changed States-Error(19406)', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn - Alert-Database Inaccessible-Error(35273)]    Script Date: 9/28/2020 2:54:14 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn - Alert-Database Inaccessible-Error(35273)', 
		@message_id=35273, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : Always On - Bypassing recovery for database ''%ls'' because it is marked as an inaccessible availability database-Error Number (35273)
		Or this is issue on WSFC Quorum,links,endpoint,Configuration,permissions', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn - Alert-Database Inaccessible-Error(35273)', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn - Connection to the Primary Server is inactive-Error(35250)]    Script Date: 9/28/2020 2:54:14 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn - Connection to the Primary Server is inactive-Error(35250)', 
		@message_id=35250, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn - Connection to the Primary Server is inactive-Error(35250) 
		Check SQL Server Error Log to Verify if the SQL Listening to the ports and all IPs', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn - Connection to the Primary Server is inactive-Error(35250)', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-AG not ready for Auto Failover-Error 41406]    Script Date: 9/28/2020 2:54:14 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-AG not ready for Auto Failover-Error 41406', 
		@message_id=41406, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-AG not ready for Auto Failover-Error 41406
  Primary and Secondary Server and Configure for Automatic Failover but the Secondary is not ready , For more infrmation check Error log in Secondry Server', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-AG not ready for Auto Failover-Error 41406', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-Alert(35274)-Recovery of Availability Database is pending]    Script Date: 9/28/2020 2:54:14 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-Alert(35274)-Recovery of Availability Database is pending', 
		@message_id=35274, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-Alert(35274)-Recovery of Availability Database is pending 
  Secondary is waiting for transaction log from the primary Make sure all of the instance is online', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-Alert(35274)-Recovery of Availability Database is pending', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-An error occurred while accessing the availability group metadata-Error 35254]    Script Date: 9/28/2020 2:54:14 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-An error occurred while accessing the availability group metadata-Error 35254', 
		@message_id=35254, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-An error occurred while accessing the availability group metadata. Remove this database or replica from the availability group, and reconfigure the availability group to add the database or replica again-Error 35254', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-An error occurred while accessing the availability group metadata-Error 35254', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-Database in Suspect Status-Error(35275)]    Script Date: 9/28/2020 2:54:14 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-Database in Suspect Status-Error(35275)', 
		@message_id=35275, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-Database in Suspect Status-Error(35275) 
  Database is in Potential damage status, Fix it and rejoin the DB again to Always on', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-Database in Suspect Status-Error(35275)', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-Database Out of Sync-Error 35276]    Script Date: 9/28/2020 2:54:15 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-Database Out of Sync-Error 35276', 
		@message_id=35276, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-Databae Out of Sync-Error 35276
  Check SQL Server Log to Know why the DB is Out of Sync', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-Database Out of Sync-Error 35276', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-Failed to Bring AG Online-Error 41131]    Script Date: 9/28/2020 2:54:15 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-Failed to Bring AG Online-Error 41131', 
		@message_id=41131, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-Failed to Bring AG Online-Error 41131
  Check SQL Server Log and Check all of Always on Configuration and WSFC Resources', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-Failed to Bring AG Online-Error 41131', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-Replica Cannot Become Primary-Error 41142]    Script Date: 9/28/2020 2:54:15 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-Replica Cannot Become Primary-Error 41142', 
		@message_id=41142, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-Replica Cannot Become Primary-Error 41142
  One or More Databases not Synced or No Joined the Availability Group or the cluster started in Force Quorum', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-Replica Cannot Become Primary-Error 41142', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-Replica Going Offline-Error 41091]    Script Date: 9/28/2020 2:54:15 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-Replica Going Offline-Error 41091', 
		@message_id=41091, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-Replica Going Offline-Error 41091
  Check SQL Server Log and Check all of Always on Configuration and WSFC Resources', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-Replica Going Offline-Error 41091', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-Secondary Not Connected-Error 41414]    Script Date: 9/28/2020 2:54:15 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-Secondary Not Connected-Error 41414', 
		@message_id=41414, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-Secondary Not Connected-Error 41414
  Check SQL Server Log and Check all of Always on Configuration and WSFC Resources', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-Secondary Not Connected-Error 41414', @operator_name=N'SQL_DBA', @notification_method = 1;
GO
/****** Object:  Alert [AlwaysOn-The attempt to join database to the availability group was rejected-Error 35279]    Script Date: 9/28/2020 2:54:15 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AlwaysOn-The attempt to join database to the availability group was rejected-Error 35279', 
		@message_id=35279, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Alert : AlwaysOn-The attempt to join database to the availability group was rejected by the primary database with error 
  For more information, see the SQL Server error log for the primary replica.Error 35279', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AlwaysOn-The attempt to join database to the availability group was rejected-Error 35279', @operator_name=N'SQL_DBA', @notification_method = 1;
GO