-- when the transaction log is FULL
SELECT name, log_reuse_wait_desc FROM sys.databases where name = 'HISGENX'

-- log space usage
DBCC SQLPERF(LOGSPACE);

/* 1. Take a log backup immediately.
   2. Shrink the log file.

or 1. Change the recovery model to Simple.
   2. Shrink the log file.
   3. Change the recovery model to Full.
   4. Take Full backup then a log backup.*/