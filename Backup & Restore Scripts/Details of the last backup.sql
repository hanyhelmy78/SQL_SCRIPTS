SELECT
  bkup.compressed,
  COUNT(*) AS total_dbs,
  bkup.[weekday],
  DATEDIFF(MINUTE, MIN(bkup.backup_start_date), MAX(bkup.backup_finish_date)) AS duration_minutes,
  AVG(speed_mb_sec) avg_mb_sec,
  MIN(bkup.backup_start_date) AS backup_began,
  MAX(bkup.backup_finish_date) AS backup_finished
FROM (SELECT
  DATENAME(WEEKDAY, bs.backup_start_date) AS [weekday],
  bs.backup_start_date,
  bs.backup_finish_date,
  speed_mb_sec = (bs.compressed_backup_size / 1048576.0) /
  CASE
    WHEN DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date) > 0 THEN DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date)
    ELSE 1
  END,
  CASE
    WHEN (bs.backup_size % bs.compressed_backup_size) > 0 THEN '1'
    ELSE '0'
  END [compressed],
  RANK() OVER (PARTITION BY bs.database_name ORDER BY bs.backup_start_date DESC) AS rank
FROM msdb..backupset bs (NOLOCK)
WHERE 1 = 1
AND bs.type = 'd' -- d = full backups, l = log backups
AND bs.is_copy_only = 0
AND bs.database_name NOT IN ('master', 'msdb', 'model') --excludes server with no user dbs
AND bs.backup_start_date > DATEADD(DAY, -7, GETDATE()) --backups in last one week
--and datename(weekday,bs.backup_start_date) = 'Monday' -- filter by day
) bkup
WHERE bkup.rank = 1 -- latest full backup 
GROUP BY bkup.compressed,
         bkup.[weekday];