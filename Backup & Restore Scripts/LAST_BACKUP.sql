/* 2 REMOVE OLDEST_PAGE (TAKE LOG BKP) ISSUE:
CHECKPOINT;
GO
select distinct type from msdb.dbo.backupset
last FULL backup */
;with FULLBUs 
as (
    select d.name, max(b.backup_finish_date) as 'Last FULL Backup'
    from sys.databases d
        join msdb.dbo.backupset b
            on d.name = b.database_name
    where b.type = 'D'
    group by d.name
),
/* last Diff Backup */
DIFFBUs 
as (
    select d.name, max(b.backup_finish_date) as 'Last DIFF Backup'
    from sys.databases d
        join msdb.dbo.backupset b
            on d.name = b.database_name
    where b.type = 'I'
    group by d.name
),
/* last LOG backup for FULL and BULK_LOGGED databases */
LOGBUs
as (
    select d.name, max(b.backup_finish_date) as 'Last LOG Backup'
    from sys.databases d
        join msdb.dbo.backupset b
            on d.name = b.database_name
    where d.recovery_model_desc <> 'SIMPLE'
        and b.type = 'L'
    group by d.name
)
/* general overview of databases, recovery model, and what is filling the log, last FULL, last LOG BKP */
select d.name [Database Name], d.state_desc [Database Status], d.recovery_model_desc [Recovery Model], d.log_reuse_wait_desc [Disk space reclaim wait for], f.[Last Full Backup], i.[Last Diff Backup], l.[Last Log Backup]
from sys.databases d
    left outer join FULLBUs f
        on d.name = f.name
	left outer join DIFFBUs i
        on d.name = i.name
    left outer join LOGBUs l
        on d.name = l.name
/* where d.name in ('ABP_SFA_BMB', 'distribution') */
order by d.name /* 'Last log Backup' DESC */