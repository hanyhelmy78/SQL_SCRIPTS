--SELECT * FROM SYS.databases
CREATE EVENT SESSION CheckpointTracking ON SERVER 
ADD EVENT sqlserver.checkpoint_begin
(
  WHERE 
  (
       sqlserver.database_id > 0 )
)
, ADD EVENT sqlserver.checkpoint_end
(
  WHERE 
  (
       sqlserver.database_id > 0
  )
)
ADD TARGET package0.event_file
(
  SET filename = N'C:\SQL\CHECK_POINT\CheckPointTracking.xel',
      max_file_size = 50, -- MB
      max_rollover_files = 50
)
WITH 
(
  MAX_MEMORY = 4096 KB,
  MAX_DISPATCH_LATENCY = 30 SECONDS, 
  STARTUP_STATE = ON
);
GO
 
ALTER EVENT SESSION CheckpointTracking ON SERVER STATE = START;