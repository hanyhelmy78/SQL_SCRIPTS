/*
The restore operation STOPPED, Repeat the original RESTORE statement specifying WITH RESTART ****
*/
-- Only one page is corrupt, so let’s do a page restore -- Switch to master to restore the damaged page
USE master;
Go
-- Set the database in restricted user mode to keep average users out
Alter Database CorruptDB Set Restricted_User With Rollback Immediate;
Go
-- Restore the corrupt page from the good full backup
Restore Database CorruptDB
Page = '1:27707'
From Disk = '<Path to full backup>\CorruptDB.bak';
Go
-- Restore the 1st pre-existing log backup to bring the page current
-- SQL knows which transations to apply, no need to specify any special commands
Restore Log CorruptDB
From Disk = '<Path to log backups>\CorruptDB.trn'
With NoRecovery;
Go
-- If there were more pre-existing log backups, we would restore them in order
-- Now backup the tail of the log...
backup Log CorruptDB
To Disk = '<Path to tail log backup>\CorruptDB_LOG_TAIL.trn'
With init;
Go
-- Restore the tail of the log bringing the page current
Restore Log CorruptDB
From Disk = '<Path to tail log backup>\CorruptDB_LOG_TAIL.trn'
With NoRecovery;
Go
-- Finally, recover the database to bring it online
Restore Database CorruptDB With Recovery;
Go
-- Allow users back in
Alter Database CorruptDB Set Multi_User;
Go
-- Recheck the database for corruption again
DBCC CheckDB(CorruptDB) With All_ErrorMsgs, No_InfoMsgs, TableResults;
Go
-- To Verify the Bkp file if it`s recoverable or not.
Restore VerifyOnly
From Disk = N'TheBkpPath.bak'