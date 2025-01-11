USE [msdb]
GO

/****** Object:  Alert [Critical_DTC calls_time>5sec]    Script Date: 12/16/2016 11:10:24 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_DTC calls_time>5sec', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'DTC calls_time>5SEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Exec Statistics|DTC calls|Average execution time (ms)|>|5000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Lock waits_Average wait time (ms)> 75 SEC]    Script Date: 12/16/2016 11:10:24 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Lock waits_Average wait time (ms)> 75 SEC', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Critical_Lock waits_Average wait time (ms)> 75 SEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Lock waits|Average wait time (ms)|>|75000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Log File(s) Size (KB)_tampdb > 95 GB]    Script Date: 12/16/2016 11:10:24 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Log File(s) Size (KB)_tampdb > 95 GB', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Log File(s) Size (KB)_tampdb > 95 GB', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Databases|Log File(s) Size (KB)|tempdb|>|95000000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Log File(s) Size (KB)_total>100 GB]    Script Date: 12/16/2016 11:10:24 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Log File(s) Size (KB)_total>100 GB', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Log File(s) Size (KB)_total>100 GB', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Databases|Log File(s) Size (KB)|_Total|>|100000000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Log Flush Wait Time> 13 SEC]    Script Date: 12/16/2016 11:10:24 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Log Flush Wait Time> 13 SEC', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Log Flush Wait Time> 13 SEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Databases|Log Flush Wait Time|_Total|>|13000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Log write waits_TIME>6SEC]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Log write waits_TIME>6SEC', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Log write waits_TIME>6SEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Log write waits|Average wait time (ms)|>|6000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Memory grant queue waits/sec>135]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Memory grant queue waits/sec>135', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Memory grant queue waits/sec>135', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Memory grant queue waits|Waits started per second|>|135', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Memory grant queue waits_time>8 sec]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Memory grant queue waits_time>8 sec', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Critical_Memory grant queue waits_time>8 sec', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Memory grant queue waits|Average wait time (ms)|>|8000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Network IO waits_TIME>6SEC]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Network IO waits_TIME>6SEC', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Critical_Network IO waits_TIME>6SEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Network IO waits|Average wait time (ms)|>|6000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Number of Deadlocks/sec>10]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Number of Deadlocks/sec>10', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=21300, 
		@include_event_description_in=1, 
		@notification_message=N'Critical Number of Deadlocks/sec>10', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Locks|Number of Deadlocks/sec|_Total|>|10', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_OLEDB calls_time>30 SEC]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_OLEDB calls_time>30 SEC', 
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

/****** Object:  Alert [Critical_Page IO latch waits_TIME>6 sec]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Page IO latch waits_TIME>6 sec', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Page IO latch waits_TIME>6000MSEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Page IO latch waits|Average wait time (ms)|>|6000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Page latch waits (sec) > 7 sec]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Page latch waits (sec) > 7 sec', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Critical_Page latch waits (sec) > 7 sec', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Page latch waits|Average wait time (ms)|>|7000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Page latch waits/sec > 10000]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Page latch waits/sec > 10000', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@notification_message=N'Critical_Page latch waits/sec > 10000', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Page latch waits|Waits started per second|>|10000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Critical_Wait for the worker time >5 sec]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Critical_Wait for the worker time >5 sec', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=21300, 
		@include_event_description_in=1, 
		@notification_message=N'Critical_Wait for the worker time >5 sec', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Wait for the worker|Waits started per second|>|5000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Disk Critical]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Disk Critical', 
		@message_id=64001, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=3, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Disk Warning]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Disk Warning', 
		@message_id=64000, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=3, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Error 823: The operating system returned an error]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Error 823: The operating system returned an error', 
		@message_id=823, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Error 824: Logical consistency-based I/O error]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Error 824: Logical consistency-based I/O error', 
		@message_id=824, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Error 825: Read-Retry Required]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Error 825: Read-Retry Required', 
		@message_id=825, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Error 832: Constant page has changed]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Error 832: Constant page has changed', 
		@message_id=832, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Sev 19 Error: Fatal Error in Resource]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Sev 19 Error: Fatal Error in Resource', 
		@message_id=0, 
		@severity=19, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Sev 20 Error: Fatal Error in Current Process]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Sev 20 Error: Fatal Error in Current Process', 
		@message_id=0, 
		@severity=20, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Sev 21 Error: Fatal Error in Database Process]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Sev 21 Error: Fatal Error in Database Process', 
		@message_id=0, 
		@severity=21, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Sev 22 Error: Fatal Error: Table Integrity Suspect]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Sev 22 Error: Fatal Error: Table Integrity Suspect', 
		@message_id=0, 
		@severity=22, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Sev 23 Error: Fatal Error Database Integrity Suspect]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Sev 23 Error: Fatal Error Database Integrity Suspect', 
		@message_id=0, 
		@severity=23, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Sev 24 Error: Fatal Hardware Error]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Sev 24 Error: Fatal Hardware Error', 
		@message_id=0, 
		@severity=24, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [RUH1SFADB Alert - Sev 25 Error: Fatal Error]    Script Date: 12/16/2016 11:10:25 ******/
EXEC msdb.dbo.sp_add_alert @name=N'RUH1SFADB Alert - Sev 25 Error: Fatal Error', 
		@message_id=0, 
		@severity=25, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'SQL Server Agent Alerts', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_DTC calls_time>1sec]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_DTC calls_time>1sec', 
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

/****** Object:  Alert [Warning_Lock waits_Average wait time (ms)> 50 SEC]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Lock waits_Average wait time (ms)> 50 SEC', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Warning_Lock waits_Average wait time (ms)> 50 SEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Lock waits|Average wait time (ms)|>|50000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_Log File(s) Size (KB)_tampdb > 85 GB]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Log File(s) Size (KB)_tampdb > 85 GB', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Log File(s) Size (KB)_tampdb > 85 GB', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Databases|Log File(s) Size (KB)|tempdb|>|85000000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_Log File(s) Size (KB)_total>90 GB]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Log File(s) Size (KB)_total>90 GB', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Log File(s) Size (KB)_total>90 GB', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Databases|Log File(s) Size (KB)|_Total|>|90000000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_Log Flush Wait Time> 12 SEC]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Log Flush Wait Time> 12 SEC', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Log Flush Wait Time> 12 SEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Databases|Log Flush Wait Time|_Total|>|12000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_Log write waits_TIME>2SEC]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Log write waits_TIME>2SEC', 
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

/****** Object:  Alert [Warning_Memory grant queue waits/sec>50]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Memory grant queue waits/sec>50', 
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

/****** Object:  Alert [Warning_Memory grant queue waits_time>7 sec]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Memory grant queue waits_time>7 sec', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Warning_Memory grant queue waits_time>7 sec', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Memory grant queue waits|Average wait time (ms)|>|7000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_Network IO waits_TIME>2SEC]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Network IO waits_TIME>2SEC', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Warning_Network IO waits_TIME>2SEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Network IO waits|Average wait time (ms)|>|2015', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [warning_Number of Deadlocks/sec>5]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'warning_Number of Deadlocks/sec>5', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=21600, 
		@include_event_description_in=1, 
		@notification_message=N'warning Number of Deadlocks/sec>5', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Locks|Number of Deadlocks/sec|_Total|>|5', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_OLEDB calls_time>20 SEC]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_OLEDB calls_time>20 SEC', 
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

/****** Object:  Alert [Warning_Page IO latch waits_TIME>2Sec]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Page IO latch waits_TIME>2Sec', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Page IO latch waits_TIME>2000MSEC', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Page IO latch waits|Average wait time (ms)|>|2000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_Page latch waits (sec) >4 sec]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Page latch waits (sec) >4 sec', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Warning_Page latch waits (sec) >4 sec', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Page latch waits|Average wait time (ms)|>|4000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_Page latch waits/sec > 9000]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Page latch waits/sec > 9000', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@notification_message=N'Warning_Page latch waits/sec >9000', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Wait Statistics|Page latch waits|Waits started per second|>|9000', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Warning_Wait for the worker time >1 sec]    Script Date: 12/16/2016 11:10:26 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Warning_Wait for the worker time >1 sec', 
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