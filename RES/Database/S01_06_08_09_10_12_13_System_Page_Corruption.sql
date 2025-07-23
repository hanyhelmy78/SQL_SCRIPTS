-- These script applies to the below issues
/*
1- Boot page corruption
2- File Header corruption
3- GAM page corruption
4- IAM page corruption
5- PSF page corruption
6- SGAM page corruption
*/
--After checking the error log and after some steps the main issue is that the database
--has been corrupted on the boot system page (9) and there is no option rather than restore
--it from the SECONDARY node after fixing it.

--open sqlcmd and start to execute these commands

:CONNECT SQLSERVERVM01
ALTER AVAILABILITY GROUP [AG] REMOVE DATABASE [AdventureWorks2019];
GO
:CONNECT SQLSERVERVM02
ALTER AVAILABILITY GROUP [AG] FAILOVER;
GO
RESTORE DATABASE [AdventureWorks2019]
GO
ALTER AVAILABILITY GROUP [AG] ADD DATABASE [AdventureWorks2019];
GO
:CONNECT SQLSERVERVM03
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO
:CONNECT SQLSERVERVM01

--verifing that the boot page (9) has corruption
dbcc checkdb (AdventureWorks2019) with no_infomsgs
alter database AdventureWorks2019 set emergency with rollback immediate
dbcc checkdb (AdventureWorks2019) with no_infomsgs
-------
  
:CONNECT SQLSERVERVM02
BACKUP DATABASE [AdventureWorks2019] 
TO  DISK = N'\\192.168.100.101\share\AdventureWorks2019_recover.bak' WITH NOFORMAT, NOINIT,  
NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10
GO
BACKUP log [AdventureWorks2019] 
TO  DISK = N'\\192.168.100.101\share\AdventureWorks2019_recover.bak' WITH NOFORMAT, NOINIT,  
NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10
GO

:CONNECT SQLSERVERVM01
RESTORE DATABASE [AdventureWorks2019] FROM  DISK = N'C:\share\AdventureWorks2019_recover.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5
GO
RESTORE LOG [AdventureWorks2019] FROM  DISK = N'C:\share\AdventureWorks2019_recover.bak' WITH  FILE = 2,  NOUNLOAD, NORECOVERY, STATS = 5
GO
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO