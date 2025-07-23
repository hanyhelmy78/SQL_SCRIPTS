--Suspect database
alter availability group [AG] REMOVE DATABASE [AdventureWorks2019]
go
alter database [AdventureWorks2019] set emergency, single_user
go
dbcc checkdb ([AdventureWorks2019], repair_allow_data_loss) with no_infomsgs
go
/*
dbcc checkdb result
File activation failure. The physical file name "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019_log.ldf" may be incorrect.
The log cannot be rebuilt because there were open transactions/users when the database was shutdown, no checkpoint occurred to the database, or the database was read-only. This error could occur if the transaction log file was manually deleted or lost due to a hardware or environment failure.
Warning: The log for database 'AdventureWorks2019' has been rebuilt. Transactional consistency has been lost. The RESTORE chain was broken, and the server no longer has context on the previous log files, 
so you will need to know what they were. You should run DBCC CHECKDB to validate physical consistency. The database has been put in dbo-only mode. When you are ready to make the database available for use, 
you will need to reset database options and delete any extra log files.
*/
  
-- In the case of system table corruption, the hidden tables such as sys.sysobjvalues, sys.syscolpars, sys.sysallocunits, you can connect using DAC connection, but you can't fix them.
-- The recommended solution is to recover the secondary database on any secondary node, restore the affected node, and recover it.

-- let's say we choose Node 2 (SQLSERVERVM02) to be the primary replica.
:CONNECT SQLSERVERVM02
RESTORE DATABASE [AdventureWorks2019] WITH RECOVERY;
GO
ALTER AVAILABILITY GROUP [AG] FAILOVER;
GO
ALTER AVAILABILITY GROUP [AG] ADD DATABASE [AdventureWorks2019];
GO
:CONNECT SQLSERVERVM03
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO
:CONNECT SQLSERVERVM02
BACKUP DATABASE [AdventureWorks2019] 
TO DISK = N'\\192.168.100.101\share\AdventureWorks2019_after_suspect_db.bak' WITH NOFORMAT, INIT,  
NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10
GO
BACKUP LOG [AdventureWorks2019] 
TO DISK = N'\\192.168.100.101\share\AdventureWorks2019_after_suspect_db.bak' WITH NOFORMAT, NOINIT,  
NAME = N'AdventureWorks2019-Log Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10
GO

:CONNECT SQLSERVERVM01
RESTORE DATABASE [AdventureWorks2019] 
FROM  DISK = N'\\192.168.100.101\share\AdventureWorks2019_after_suspect_db.bak' WITH  FILE = 1,  
NOUNLOAD, NORECOVERY, STATS = 10
GO
RESTORE LOG [AdventureWorks2019] 
FROM  DISK = N'\\192.168.100.101\share\AdventureWorks2019_after_suspect_db.bak' WITH  FILE = 2,  
NOUNLOAD, NORECOVERY, STATS = 10
GO
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO
ALTER AVAILABILITY GROUP [AG] FAILOVER;
GO
