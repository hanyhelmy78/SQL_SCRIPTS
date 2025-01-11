-- SELECT sp = OBJECT_NAME(1686297067, 32); 

SELECT object_name, CONVERT(XML, event_data), file_name, file_offset
FROM   sys.fn_xe_file_target_read_file('*.xel', NULL, NULL, NULL)
WHERE  object_name = 'xml_deadlock_report'

select convert(xml, query_plan), eqs.creation_time 
from sys.dm_exec_query_stats eqs
cross apply sys.dm_exec_text_query_plan(eqs.plan_handle, eqs.statement_start_offset, eqs.statement_end_offset) eqp
where sql_handle = 0x030005007919673b640317003ea7000000000000000000000000000000000000000000000000000000000000
 and statement_start_offset = 492

/*
 CREATE EVENT SESSION 
    deadlock
ON SERVER
    ADD EVENT 
        sqlserver.xml_deadlock_report
    ADD TARGET 
        package0.event_file
    (
        SET filename = N'deadlock'
    )
WITH
(
    MAX_MEMORY = 4096KB,
    EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY = 5 SECONDS,
    MAX_EVENT_SIZE = 0KB,
    MEMORY_PARTITION_MODE = NONE,
    TRACK_CAUSALITY = OFF,
    STARTUP_STATE = ON
);
GO

ALTER EVENT SESSION
    deadlock
ON SERVER 
    STATE = START;
GO
 */