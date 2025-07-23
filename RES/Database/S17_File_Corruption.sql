ALTER DATABASE [AdventureWorks2019] SET ONLINE;
/*
Msg 5181, Level 16, State 5, Line 1
Could not restart database "AdventureWorks2019". Reverting to the previous status.
Msg 5069, Level 16, State 1, Line 1
ALTER DATABASE statement failed.
Msg 824, Level 24, State 6, Line 1
SQL Server detected a logical consistency-based I/O error: incorrect checksum (expected: 0xd91d45ef; actual: 0xa16245ef). It occurred during a read of page (1:0) in database ID 6 at offset 0000000000000000 in file 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019.mdf'. Additional messages in the SQL Server error log or operating system error log may provide more detail. This is a severe error condition that threatens database integrity and must be corrected immediately. Complete a full database consistency check (DBCC CHECKDB). This error can be caused by many factors; for more information, see SQL Server Books Online.
*/

DBCC CHECKDB (AdventureWorks2019)
/*
Msg 945, Level 14, State 2, Line 11
Database 'AdventureWorks2019' cannot be opened due to inaccessible files or insufficient memory or disk space.  See the SQL Server errorlog for details.
*/
ALTER DATABASE [AdventureWorks2019] SET EMERGENCY WITH ROLLBACK IMMEDIATE;
/*
Msg 1468, Level 16, State 1, Line 12
The operation cannot be performed on database "AdventureWorks2019" because it is involved in a database mirroring session or an availability group. Some operations are not allowed on a database that is participating in a database mirroring session or in an availability group.
Msg 5069, Level 16, State 1, Line 12
ALTER DATABASE statement failed.
*/
ALTER AVAILABILITY GROUP [AG] REMOVE DATABASE [AdventureWorks2019];
GO
ALTER DATABASE [AdventureWorks2019] SET SINGLE_USER;
GO
ALTER DATABASE [AdventureWorks2019] SET EMERGENCY WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE [AdventureWorks2019] SET OFFLINE;
GO

--Open sqlcmd and execute the below commands to resolve it:
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
:CONNECT SQLSERVERVM02
BACKUP DATABASE [AdventureWorks2019] 
TO DISK = N'\\192.168.100.101\share\AdventureWorks2019_recover.bak' WITH NOFORMAT, INIT,  
NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 5
GO
BACKUP log [AdventureWorks2019] 
TO  DISK = N'\\192.168.100.101\share\AdventureWorks2019_recover.bak' WITH NOFORMAT, NOINIT,  
NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 5
GO
:CONNECT SQLSERVERVM01
RESTORE DATABASE [AdventureWorks2019] FROM DISK = N'C:\share\AdventureWorks2019_recover.bak' WITH FILE = 1, REPLACE, NORECOVERY, NOUNLOAD, STATS = 5
GO
RESTORE LOG [AdventureWorks2019] FROM  DISK = N'C:\share\AdventureWorks2019_recover.bak' WITH FILE = 2, NOUNLOAD, NORECOVERY, STATS = 5
GO
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO
:CONNECT SQLSERVERVM01
ALTER AVAILABILITY GROUP [AG] FAILOVER;
GO