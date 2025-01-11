-- query returns details about the number of deadlocks for the instance since the last server restart

SELECT cntr_value AS NumberOfDeadLocks
   FROM sys.dm_os_performance_counters  
WHERE object_name = MSSQL$SQL2016:Locks'
    AND counter_name = 'Number of Deadlocks/sec'
    AND instance_name = '_Total'

-- query the System Health Extended Event session directly in order to mine for deadlock details

SELECT XEvent.query('(event/data/value/deadlock)[1]') AS DeadlockGraph 
FROM ( SELECT XEvent.query('.') AS XEvent 
       FROM ( SELECT CAST(target_data AS XML) AS TargetData 
              FROM sys.dm_xe_session_targets st 
                   JOIN sys.dm_xe_sessions s 
                   ON s.address = st.event_session_address 
              WHERE s.name = 'system_health' 
                    AND st.target_name = 'ring_buffer' 
              ) AS Data 
              CROSS APPLY 
                 TargetData.nodes 
                    ('RingBufferTarget/event[@name="xml_deadlock_report"]')
              AS XEventData ( XEvent ) 
      ) AS src;