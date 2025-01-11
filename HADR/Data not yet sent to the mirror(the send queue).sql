DECLARE @MonitorResults AS TABLE (database_name VARCHAR(255), 
							      role INT, 
								  mirror_state TINYINT, 
								  witness_status TINYINT, 
								  log_generat_rate INT, 
								  unsent_log INT, 
								  sent_rate INT, 
								  unrestored_log INT, 
								  recovery_rate INT, 
								  transaction_delay INT, 
								  transaction_per_sec INT, 
								  average_delay INT, 
								  time_recorded DATETIME, 
								  time_behind DATETIME, 
								  local_time DATETIME); 
INSERT INTO @MonitorResults 
EXEC sp_dbmmonitorresults @database_name = 'InsertDatabaseNameHere', -- change db_name
						  @mode = 0, 
						  @update_table = 0; 
SELECT  unsent_log 
FROM    @MonitorResults;