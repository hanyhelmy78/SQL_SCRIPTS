DECLARE @dbname sysname
SET @dbname = NULL --set this to be whatever dbname you want

SELECT bup.user_name AS [User],
 bup.database_name AS [Database],
 bup.server_name AS [Server],
 CASE WHEN TYPE = 'L' THEN 'LOG BKP'
	  WHEN TYPE = 'D' THEN 'FULL BKP'
	  WHEN TYPE = 'I' THEN 'DIFF BKP' 
	  WHEN TYPE = 'F' THEN 'FileGroup BKP' END AS 'BKP Type',
 bup.backup_start_date AS [Backup Started],
 bup.backup_finish_date AS [Backup Finished]
 ,CAST((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS int))/3600 AS varchar) + ' hours, ' 
+ CAST(((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS int))/60)%60 AS varchar)+ ' minutes, '
+ CAST((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS int))%60 AS varchar)+ ' seconds'
 AS [Total Time],
 ROUND(backup_size/1024/1024/1024,2) AS [BKP Size in GB]

FROM msdb.dbo.backupset bup WITH (NOLOCK)

WHERE bup.database_name = 'Medium_StackOverflow2013' --IN (SELECT name FROM master.dbo.sysdatabases)
/* AND CASE WHEN TYPE = 'L' THEN 'LOG BKP'
		 WHEN TYPE = 'D' THEN 'FULL BKP'
		 WHEN TYPE = 'I' THEN 'DIFF BKP' 
		 WHEN TYPE = 'F' THEN 'FileGroup BKP' END = 'FULL BKP' */
ORDER BY bup.backup_start_date DESC