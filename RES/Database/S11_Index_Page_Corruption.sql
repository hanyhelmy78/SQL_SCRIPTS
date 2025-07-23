USE AdventureWorks2019
GO
SELECT DISTINCT rowguid 
FROM Sales.SalesOrderDetail WITH (INDEX=[AK_SalesOrderDetail_rowguid]) 
ORDER BY rowguid DESC
GO
use master
GO
DBCC CHECKDB(AdventureWorks2019) WITH NO_INFOMSGS
GO
ALTER AVAILABILITY GROUP [AG] REMOVE DATABASE AdventureWorks2019
GO
DBCC CHECKDB(AdventureWorks2019) WITH NO_INFOMSGS
/*
Msg 8939, Level 16, State 98, Line 7
Table error: 
Object ID 1490104349, 
index ID 2, 
partition ID 72057594056474624, 
alloc unit ID 72057594064535552 (type In-row data), 
page (1:12336). Test (IS_OFF (BUF_IOERR, pBUF->bstat)) failed. Values are 133129 and -4.
Msg 8928, Level 16, State 1, Line 7
Object ID 1490104349, 
index ID 2, 
partition ID 72057594056474624, 
alloc unit ID 72057594064535552 (type In-row data): 
Page (1:12336) could not be processed.  See other errors for details.
Msg 8976, Level 16, State 1, Line 7
Table error: 
Object ID 1490104349, 
index ID 2, 
partition ID 72057594056474624, 
alloc unit ID 72057594064535552 (type In-row data). 
Page (1:12336) was not seen in the scan although 
its parent (1:12192) 
and previous (1:12335) refer to it. Check any previous errors.
Msg 8978, Level 16, State 1, Line 7
Table error: Object ID 1490104349, index ID 2, partition ID 72057594056474624, alloc unit ID 72057594064535552 (type In-row data). 
Page (1:12337) is missing a reference from previous page (1:12336). 
Possible chain linkage problem.
*/
GO


USE AdventureWorks2019
GO
-- If you tried to rebuild the index, it will show you the below error message 
-- because SQL Server will try to use the same pages when you rebuild the index 
-- while some of them are physically corrupted
ALTER INDEX [AK_SalesOrderDetail_rowguid] ON [Sales].[SalesOrderDetail] REBUILD WITH (MAXDOP=1)
/*
Msg 824, Level 24, State 2, Line 49
SQL Server detected a logical consistency-based I/O error: incorrect checksum (expected: 0x3852aa35; actual: 0x56965bf8). 
It occurred during a read of page (1:12409) in database ID 6 at offset 0x000000060f2000 in file 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019.mdf'.  
Additional messages in the SQL Server error log or operating system error log may provide more detail. This is a severe error condition that threatens database integrity and must be corrected immediately. 
Complete a full database consistency check (DBCC CHECKDB). This error can be caused by many factors; for more information, see SQL Server Books Online.
*/

-- You have 2 choices 
--1. to drop the index, but do not forget to export the script of the index
USE AdventureWorks2019
GO
DROP INDEX [AK_SalesOrderDetail_rowguid] ON [Sales].[SalesOrderDetail]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesOrderDetail_rowguid] ON [Sales].[SalesOrderDetail] ([rowguid] ASC) ON [PRIMARY]
GO
--2. to disable the index, then rebuild it

USE AdventureWorks2019
GO
ALTER INDEX [AK_SalesOrderDetail_rowguid] ON [Sales].[SalesOrderDetail] DISABLE
GO
ALTER INDEX [AK_SalesOrderDetail_rowguid] ON [Sales].[SalesOrderDetail] REBUILD WITH (MAXDOP=1)
GO

--Resync again
:CONNECT SQLSERVERVM01
ALTER AVAILABILITY GROUP [AG] ADD DATABASE [AdventureWorks2019]
GO
BACKUP LOG [AdventureWorks2019] 
TO DISK = N'\\192.168.100.101\share\AdventureWorks2019_after_index_corruption.bak' WITH NOFORMAT, NOINIT,  
NAME = N'AdventureWorks2019-Log Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10
GO
:CONNECT SQLSERVERVM02
RESTORE LOG [AdventureWorks2019] 
FROM  DISK = N'\\192.168.100.101\share\AdventureWorks2019_after_index_corruption.bak' WITH  FILE = 1,  
NOUNLOAD, NORECOVERY, STATS = 10
GO
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG];
GO
:CONNECT SQLSERVERVM03
RESTORE LOG [AdventureWorks2019] 
FROM  DISK = N'\\192.168.100.101\share\AdventureWorks2019_after_index_corruption.bak' WITH  FILE = 1,  
NOUNLOAD, NORECOVERY, STATS = 10
GO
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG];
GO
