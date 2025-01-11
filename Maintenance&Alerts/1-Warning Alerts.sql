USE [msdb]
GO

SELECT @@SERVERNAME
--S-HQ-CL-SQ-01\instancename

/****** Object:  Alert [Disk Warning]    Script Date: 07/05/2017 08:43:27 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Disk Warning', 
		@message_id=64000, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=3, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Disk Warning', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning DTC calls_time > 1 sec',
@message_id=0,
@severity=0,
@enabled=1,
@delay_between_responses=600,
@include_event_description_in=1,
@notification_message=N'DTC calls_time>1SEC',
@category_name=N'[Uncategorized]',
@performance_condition=N'SQLServer:Exec Statistics|DTC calls|Average execution time (ms)|>|1000',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning DTC calls_time > 1 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Lock waits Average wait time (ms)> 30 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Warning_Lock waits_Average wait time (ms)> 30 SEC',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Lock waits|Average wait time (ms)|>|30000',

@job_id=N'00000000-0000-0000-0000-000000000000'

GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Lock waits Average wait time (ms)> 30 SEC', @operator_name=N'SQL_DBA', @notification_method = 1

GO
--=======================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Log File Size(KB) 4 tampdb > 25 GB',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Log File(s) Size (KB)_tampdb > 20GB',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Databases|Log File(s) Size (KB)|tempdb|>|25000000',

@job_id=N'00000000-0000-0000-0000-000000000000'

GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Log File Size(KB) 4 tampdb > 25 GB', @operator_name=N'SQL_DBA', @notification_method = 1

GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Log File Size(KB) total > 50 GB',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Log File(s) Size (KB)_total>50GB',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Databases|Log File(s) Size (KB)|_Total|>|50000000',

@job_id=N'00000000-0000-0000-0000-000000000000'

GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Log File Size(KB) total > 50 GB', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Log Flush Wait Time > 4 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Log Flush Wait Time> 4 SEC',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Databases|Log Flush Wait Time|_Total|>|4000',

@job_id=N'00000000-0000-0000-0000-000000000000'

GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Log Flush Wait Time > 4 SEC', @operator_name=N'SQL_DBA', @notification_method = 1

GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Log write waits time >2 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Log write waits_TIME>2SEC',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Log write waits|Average wait time (ms)|>|2000',

@job_id=N'00000000-0000-0000-0000-000000000000'

GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Log write waits time >2 SEC', @operator_name=N'SQL_DBA', @notification_method = 1

GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Memory grant queue waits/sec > 50',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Memory grant queue waits/sec>50',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Memory grant queue waits|Waits started per second|>|50',

@job_id=N'00000000-0000-0000-0000-000000000000'

GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Memory grant queue waits/sec > 50', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===============================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Memory grant queue waits time > 1 sec',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Warning_Memory grant queue waits_time>1 sec',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Memory grant queue waits|Average wait time (ms)|>|1000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Memory grant queue waits time > 1 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Network IO waits time >2 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Warning Network IO waits_TIME>2 SEC',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Network IO waits|Average wait time (ms)|>|2000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Network IO waits time >2 SEC', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Number of Deadlocks/sec > 5',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=21600,

@include_event_description_in=1,

@notification_message=N'Warning Number of Deadlocks/sec>5 ',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Locks|Number of Deadlocks/sec|_Total|>|5',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Number of Deadlocks/sec > 5', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning OLEDB calls time > 20 SEC',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'OLEDB calls_time>20 sec',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Exec Statistics|OLEDB calls|Average execution time (ms)|>|20000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning OLEDB calls time > 20 SEC', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning I/O WAIT TIME> 10 Sec',
@message_id=0,
@severity=0,
@enabled=1,
@delay_between_responses=600,
@include_event_description_in=1,
@notification_message=N'Page IO latch waits_TIME>10000 MSEC',
@category_name=N'[Uncategorized]',
@performance_condition=N'SQLServer:Wait Statistics|Page IO latch waits|Average wait time (ms)|>|10000',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning I/O WAIT TIME> 10 Sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Page latch waits (sec) > 10 sec',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Warning_Page latch waits (sec) > 10 sec',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Page latch waits|Average wait time (ms)|>|10000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Page latch waits (sec) > 10 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Page latch waits/sec >1000',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=600,

@include_event_description_in=1,

@notification_message=N'Warning_Page latch waits/sec >1000',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Page latch waits|Waits started per second|>|1000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Page latch waits/sec >1000', @operator_name=N'SQL_DBA', @notification_method = 1
GO
--===========================================================================================================
EXEC msdb.dbo.sp_add_alert @name=N'Warning Wait for the worker time >1 sec',

@message_id=0,

@severity=0,

@enabled=1,

@delay_between_responses=21600,

@include_event_description_in=1,

@notification_message=N'Warning_Wait for the worker time >1 sec',

@category_name=N'[Uncategorized]',

@performance_condition=N'SQLServer:Wait Statistics|Wait for the worker|Waits started per second|>|1000',

@job_id=N'00000000-0000-0000-0000-000000000000'
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'Warning Wait for the worker time >1 sec', @operator_name=N'SQL_DBA', @notification_method = 1
GO