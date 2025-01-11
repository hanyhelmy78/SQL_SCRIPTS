/*************Script To Find Database Restore History In SQL Server****************/

/***************************************************
Along with Restore history this script will also give you Source database , Server time taken in backup , user who did restore , and type of backup used for restore.
***************************************************/
SELECT
              [rs].[destination_database_name] as [Restored_database_name],
              [rs].[restore_date],
              CASE
                       WHEN rs.restore_type = 'D' THEN 'Database'
                       WHEN rs.restore_type = 'F' THEN 'File'
                       WHEN rs.restore_type = 'G' THEN 'Filegroup'
                       WHEN rs.restore_type = 'I' THEN 'Differential'
                       WHEN rs.restore_type = 'L' THEN 'Log'
                       ELSE rs.restore_type
              END AS [Restore Type],
                     bs.server_name as backup_Source_Server,
                     [bs].[database_name] as [source_database_name],
                     [bmf].[physical_device_name] as [backup_file_used_for_restore] ,
                     [bs].[backup_start_date],
                     [bs].[backup_finish_date],
                     [rs].user_name
FROM msdb..restorehistory rs
INNER JOIN msdb..backupset bs
       ON [rs].[backup_set_id] = [bs].[backup_set_id]
INNER JOIN msdb..backupmediafamily bmf
       ON [bs].[media_set_id] = [bmf].[media_set_id]
Order by [rs].[restore_date]
 /***************************************************/
