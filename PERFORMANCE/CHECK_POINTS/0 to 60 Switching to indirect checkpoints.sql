/* https://sqlperformance.com/2020/05/system-configuration/0-to-60-switching-to-indirect-checkpoints

SELECT database_id, name, TARGET_RECOVERY_TIME_IN_SECONDS FROM sys.databases 
*/
DECLARE @sql nvarchar(max) = N'';
SELECT @sql += CASE
  WHEN ag.role = N'PRIMARY' OR ag.role IS NULL THEN N'
    ALTER DATABASE ' + QUOTENAME(d.name) + N' SET TARGET_RECOVERY_TIME = 60 SECONDS;' 
  ELSE N'
    PRINT N''-- fix ' + QUOTENAME(d.name) + N' on Primary.'';' 
  END
FROM sys.databases AS d 
OUTER APPLY
(
  SELECT role = s.role_desc
    FROM sys.dm_hadr_availability_replica_states AS s
    INNER JOIN sys.availability_databases_cluster AS c
       ON s.group_id = c.group_id 
       AND d.name = c.database_name
    WHERE s.is_local = 1
) AS ag
WHERE d.target_recovery_time_in_seconds <> 60
  AND d.database_id > 0
  AND d.[state] = 0 
  AND d.is_in_standby = 0 
  AND d.is_read_only = 0;
SELECT DatabaseCount = @@ROWCOUNT, Version = @@VERSION, cmd = @sql;
 
EXEC sys.sp_executesql @sql;