Declare @DBName sysname,
    	@DBBackupLSN numeric(25, 0);
Declare @Baks Table (
    BakID int identity(1, 1) not null primary key,
    backup_set_id int not null,
    media_set_id int not null,
    first_family_number tinyint not null,
    last_family_number tinyint not null,
    first_lsn numeric(25, 0) null,
    last_lsn numeric(25, 0) null,
    database_backup_lsn numeric(25, 0) null,
    backup_finish_date datetime null,
    type char(1) null,
    family_sequence_number tinyint not null,
    physical_device_name nvarchar(260) not null,
    device_type tinyint null)

Set NoCount On;

-- Set the name of the database you want to restore
Set @DBName = N'ABP_SFA_BMB';

-- Get the most recent full backup with all backup files
Insert Into @Baks (backup_set_id,
    media_set_id,
    first_family_number,
    last_family_number,
    first_lsn,
    last_lsn,
    database_backup_lsn,
    backup_finish_date,
    type,
    family_sequence_number,
    physical_device_name,
    device_type)
Select Top(1) With Ties B.backup_set_id,
    B.media_set_id,
    B.first_family_number,
    B.last_family_number,
    B.first_lsn,
    B.last_lsn,
    B.database_backup_lsn,
    B.backup_finish_date,
    B.type,
    BF.family_sequence_number,
    BF.physical_device_name,
    BF.device_type
From msdb.dbo.backupset As B
Inner Join msdb.dbo.backupmediafamily As BF
    On BF.media_set_id = B.media_set_id
        And BF.family_sequence_number Between B.first_family_number And B.last_family_number
Where B.database_name = @DBName
And B.is_copy_only = 0
And B.type = 'D'
And BF.physical_device_name Not In ('Nul', 'Nul:')
Order By backup_finish_date desc, backup_set_id;

-- Get the lsn that the differential backups, if any, will be based on
Select @DBBackupLSN = database_backup_lsn
From @Baks;

-- Get the most recent differential backup based on that full backup
Insert Into @Baks (backup_set_id,
    media_set_id,
    first_family_number,
    last_family_number,
    first_lsn,
    last_lsn,
    database_backup_lsn,
    backup_finish_date,
    type,
    family_sequence_number,
    physical_device_name,
    device_type)
Select Top(1) With Ties B.backup_set_id,
    B.media_set_id,
    B.first_family_number,
    B.last_family_number,
    B.first_lsn,
    B.last_lsn,
    B.database_backup_lsn,
    B.backup_finish_date,
    B.type,
    BF.family_sequence_number,
    BF.physical_device_name,
    BF.device_type
From msdb.dbo.backupset As B
Inner Join msdb.dbo.backupmediafamily As BF
    On BF.media_set_id = B.media_set_id
        And BF.family_sequence_number Between B.first_family_number And B.last_family_number
Where B.database_name = @DBName
And B.is_copy_only = 0
And B.type = 'I'
And BF.physical_device_name Not In ('Nul', 'Nul:')
And B.database_backup_lsn = @DBBackupLSN
Order By backup_finish_date Desc, backup_set_id;

-- Get the last LSN included in the differential backup,
-- if one was found, or of the full backup
Select Top 1 @DBBackupLSN = last_lsn
From @Baks
Where type In ('D', 'I')
Order By BakID Desc;

-- Get first log backup, if any, for restore, where
-- last_lsn of previous backup is >= first_lsn of the
-- log backup and <= the last_lsn of the log backup
Insert Into @Baks (backup_set_id,
    media_set_id,
    first_family_number,
    last_family_number,
    first_lsn,
    last_lsn,
    database_backup_lsn,
    backup_finish_date,
    type,
    family_sequence_number,
    physical_device_name,
    device_type)
Select Top(1) With Ties B.backup_set_id,
    B.media_set_id,
    B.first_family_number,
    B.last_family_number,
    B.first_lsn,
    B.last_lsn,
    B.database_backup_lsn,
    B.backup_finish_date,
    B.type,
    BF.family_sequence_number,
    BF.physical_device_name,
    BF.device_type
From msdb.dbo.backupset B
Inner Join msdb.dbo.backupmediafamily As BF
    On BF.media_set_id = B.media_set_id
        And BF.family_sequence_number Between B.first_family_number And B.last_family_number
Where B.database_name = @DBName
And B.is_copy_only = 0
And B.type = 'L'
And BF.physical_device_name Not In ('Nul', 'Nul:')
And @DBBackupLSN Between B.first_lsn And B.last_lsn
Order By backup_finish_date, backup_set_id;

-- Get last_lsn of the first log backup that will be restored
Set @DBBackupLSN = Null;
Select @DBBackupLSN = Max(last_lsn)
From @Baks
Where type = 'L';

-- Recursively get all log backups, in order, to be restored
-- first_lsn of the log backup = last_lsn of the previous log backup
With Logs
As (Select B.backup_set_id,
        B.media_set_id,
        B.first_family_number,
        B.last_family_number,
        B.first_lsn,
        B.last_lsn,
        B.database_backup_lsn,
        B.backup_finish_date,
        B.type,
        BF.family_sequence_number,
        BF.physical_device_name,
        BF.device_type,
        1 As LogLevel
    From msdb.dbo.backupset B
    Inner Join msdb.dbo.backupmediafamily As BF
        On BF.media_set_id = B.media_set_id
            And BF.family_sequence_number Between B.first_family_number And B.last_family_number
    Where B.database_name = @DBName
    And B.is_copy_only = 0
    And B.type = 'L'
    And BF.physical_device_name Not In ('Nul', 'Nul:')
    And B.first_lsn = @DBBackupLSN
    Union All
    Select B.backup_set_id,
        B.media_set_id,
        B.first_family_number,
        B.last_family_number,
        B.first_lsn,
        B.last_lsn,
        B.database_backup_lsn,
        B.backup_finish_date,
        B.type,
        BF.family_sequence_number,
        BF.physical_device_name,
        BF.device_type,
        L.LogLevel + 1
    From msdb.dbo.backupset B
    Inner Join msdb.dbo.backupmediafamily As BF
        On BF.media_set_id = B.media_set_id
            And BF.family_sequence_number Between B.first_family_number And B.last_family_number
    Inner Join Logs L On L.database_backup_lsn = B.database_backup_lsn
    Where B.database_name = @DBName
    And B.is_copy_only = 0
    And B.type = 'L'
    And BF.physical_device_name Not In ('Nul', 'Nul:')
    And B.first_lsn = L.last_lsn)
Insert Into @Baks (backup_set_id,
    media_set_id,
    first_family_number,
    last_family_number,
    first_lsn,
    last_lsn,
    database_backup_lsn,
    backup_finish_date,
    type,
    family_sequence_number,
    physical_device_name,
    device_type)
Select backup_set_id,
    media_set_id,
    first_family_number,
    last_family_number,
    first_lsn,
    last_lsn,
    database_backup_lsn,
    backup_finish_date,
    type,
    family_sequence_number,
    physical_device_name,
    device_type
From Logs
Option(MaxRecursion 0);

-- Select out just the columns needed to script restore
Select RestoreOrder = Row_Number() Over(Partition By family_sequence_number Order By BakID),
    RestoreType = Case When type In ('D', 'I') Then 'Database'
            When type = 'L' Then 'Log'
        End,
    DeviceType = Case When device_type in (2, 102) Then 'Disk'
            When device_type in (5, 105) Then 'Tape'
        End,
    PhysicalFileName = physical_device_name
From @Baks
Order By BakID;
Set NoCount Off;