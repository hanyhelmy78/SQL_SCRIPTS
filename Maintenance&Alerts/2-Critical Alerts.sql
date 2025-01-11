USE [msdb]
GO

SELECT @@SERVERNAME [Actual Name]

/* IN SECONDARY NODE*/
USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'AG Failover Detected - Now Primary',
@message_id=1480,
@severity=0,
@enabled=1,
@delay_between_responses=0,
@include_event_description_in=1,
@event_description_keyword=N'"RESOLVING" to "PRIMARY"',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AG Failover Detected - Now Primary', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--================================================================================================
/*
IN PRIMARY NODE
*/
USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'AG Failover Detected - Now Secondary',
@message_id=1480,
@severity=0,
@enabled=1,
@delay_between_responses=0,
@include_event_description_in=1,
@event_description_keyword=N'"RESOLVING" to "SECONDARY"',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AG Failover Detected - Now Secondary', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--================================================================================================
/****** Object:  Alert [AG Connection Termintaed]    Script Date: 23/12/2018 1:02:10 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AG Connection Termintaed', 
		@message_id=35267, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AG Connection Termintaed', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--================================================================================================
/****** Object:  Alert [AlwaysOn - Data Movement Suspended]    Script Date: 23/12/2018 3:33:05 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AG Data Movement Suspended', 
		@message_id=35264, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'AG Data Movement Suspended', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Data File Size (KB) 4 TEMPDB > 45 GB', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Data File Size (KB) 4 TEMPDB > 45 GB', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Databases|Data File(s) Size (KB)|tempdb|>|45000000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Data File Size (KB) 4 TEMPDB > 45 GB', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--================================================================================================
/****** Object:  Alert [Disk Critical]    Script Date: 07/05/2017 08:43:22 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Disk Critical', 
		@message_id=64001, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=3, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Disk Critical', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--====================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical DTC calls time > 5 sec',
@message_id=0,
@severity=0,
@enabled=1,
@delay_between_responses=300,
@include_event_description_in=1,
@notification_message=N'DTC calls time> 5 SEC',
@category_name=N'[Uncategorized]',
@performance_condition=N'SQLServer:Exec Statistics|DTC calls|Average execution time (ms)|>|5000',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical DTC calls time > 5 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Lock waits Average wait time (ms)> 50 SEC',
@message_id=0,
@severity=0,
@enabled=1,
@delay_between_responses=300,
@include_event_description_in=1,
@notification_message=N'Critical Lock waits Average wait time (ms)> 50 SEC',
@category_name=N'[Uncategorized]',
@performance_condition=N'SQLServer:Wait Statistics|Lock waits|Average wait time (ms)|>|50000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Lock waits Average wait time (ms)> 50 SEC', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Log Flush Wait Time> 6 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=300,

@include_event_description_in=1,

@notification_message=N'Log Flush Wait Time> 6 SEC',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Databases|Log Flush Wait Time|_Total|>|6000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Log Flush Wait Time> 6 SEC', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Log write waits time >6 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=300,

@include_event_description_in=1,

@notification_message=N'Log write waits_TIME>6 SEC',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Log write waits|Average wait time (ms)|>|6000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Log write waits time >6 SEC', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Memory grant queue waits time> 5 sec',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=300,

@include_event_description_in=1,

@notification_message=N'Critical Memory grant queue waits time> 5 sec',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Memory grant queue waits|Average wait time (ms)|>|5000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Memory grant queue waits time> 5 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Network I/O waits time > 6 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=300,

@include_event_description_in=1,

@notification_message=N'Critical Network I/O waits time > 6 SEC',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Network IO waits|Average wait time (ms)|>|6000',

@job_id=N'00000000-0000-0000-0000-000000000000'

GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Network I/O waits time > 6 SEC', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Number of Deadlocks/sec > 10',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=21300,

@include_event_description_in=1,

@notification_message=N'Critical Number of Deadlocks/sec>10 ',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Locks|Number of Deadlocks/sec|_Total|>|10',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Number of Deadlocks/sec > 10', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical OLEDB calls time> 30 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=300,

@include_event_description_in=1,

@notification_message=N'OLEDB calls_time>30 sec',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Exec Statistics|OLEDB calls|Average execution time (ms)|>|30000',

@job_id=N'00000000-0000-0000-0000-000000000000'

GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical OLEDB calls time> 30 SEC', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical I/O WAIT TIME> 15 sec',
@message_id=0,
@severity=0,
@enabled=1,
@delay_between_responses=300,
@include_event_description_in=1,
@notification_message=N'Page IO waits time> 15000 MSEC',
@category_name=N'[Uncategorized]',
@performance_condition=N'SQLServer:Wait Statistics|Page IO latch waits|Average wait time (ms)|>|15000',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical I/O WAIT TIME> 15 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Page latch waits (sec) > 6 sec',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=300,

@include_event_description_in=1,

@notification_message=N'Critical_Page latch waits (sec) >6 sec',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Page latch waits|Average wait time (ms)|>|6000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Page latch waits (sec) > 6 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Page latch waits/sec >2000',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=300,

@include_event_description_in=1,

@notification_message=N'Critical_Page latch waits/sec >2000',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Page latch waits|Waits started per second|>|2000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Page latch waits/sec >2000', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Wait for the worker time > 5 sec',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Critical_Wait for the worker time >5 sec',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Wait for the worker|Waits started per second|>|5000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Wait for the worker time > 5 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Log File(s) Size (KB) 4 tampdb > 40 GB',
 
@message_id=0,
 
@severity=0,
 
@enabled=1,
 
@delay_between_responses=300,
 
@include_event_description_in=1,
 
@notification_message=N'Log File(s) Size (KB)_tampdb > 40GB',
 
@category_name=N'[Uncategorized]',
 
@performance_condition=N'SQLServer:Databases|Log File(s) Size (KB)|tempdb|>|40000000',
 
@job_id=N'00000000-0000-0000-0000-000000000000'
 
GO 
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Log File(s) Size (KB) 4 tampdb > 40 GB', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Log File Size(KB) total > 80 GB',
 
@message_id=0,
 
@severity=0,
 
@enabled=1,
 
@delay_between_responses=300,
 
@include_event_description_in=1,
 
@notification_message=N'Log File(s) Size (KB)_total>80 GB',
 
@category_name=N'[Uncategorized]',
 
@performance_condition=N'SQLServer:Databases|Log File(s) Size (KB)|_Total|>|80000000',
 
@job_id=N'00000000-0000-0000-0000-000000000000'
 
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Log File Size(KB) total > 80 GB', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Critical Memory grant queue waits/sec > 100',
 
@message_id=0,
 
@severity=0,
 
@enabled=1,
 
@delay_between_responses=300,
 
@include_event_description_in=1,
 
@notification_message=N'Memory grant queue waits/sec>100',
 
@category_name=N'[Uncategorized]',
 
@performance_condition=N'SQLServer:Wait Statistics|Memory grant queue waits|Waits started per second|>|100',
 
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Critical Memory grant queue waits/sec > 100', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===============================================================================================================
-- Blocked Process Alert
EXEC msdb.dbo.sp_add_alert @name = 
     N'Blocked Process Alert', @enabled = 1,
      @category_name = N'[Uncategorized]',
      @performance_condition = N'General Statistics|Processes blocked||>|5'
GO  
-- Add one e-mail notification to one operator
EXEC msdb.dbo.sp_add_notification @alert_name = N'Blocked Process Alert',
       @operator_name = N'SQL_DBA'               
       , @notification_method = 1;
GO