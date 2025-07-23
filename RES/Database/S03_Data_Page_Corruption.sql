SELECT DISTINCT BusinessEntityID FROM Person.Person WITH (INDEX=0) ORDER BY BusinessEntityID DESC
/*
Msg 824, Level 24, State 2, Line 1
SQL Server detected a logical consistency-based I/O error: incorrect checksum (expected: 0x587f71db; 
actual: 0x6f009183). It occurred during a read of page (1:1844) in database ID 6 at offset 0x00000000e68000 
in file 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019.mdf'.  
Additional messages in the SQL Server error log or operating system error log may provide more detail. 
This is a severe error condition that threatens database integrity and must be corrected immediately. 
Complete a full database consistency check (DBCC CHECKDB). This error can be caused by many factors; 
for more information, see SQL Server Books Online.
*/

DBCC CHECKDB(AdventureWorks2019) WITH NO_INFOMSGS
/*
Commands completed successfully.

Because it is in the availability replica dbcc checkdb does catch anything
Becuase the auto repair, so, remove it from the availability group,
Then execute the case again
*/
USE master
GO
ALTER AVAILABILITY GROUP [AG] REMOVE DATABASE [AdventureWorks2019];
GO
use [AdventureWorks2019]
GO
SELECT DISTINCT BusinessEntityID FROM Person.Person WITH (INDEX=0) ORDER BY BusinessEntityID DESC
/*
the same error
*/
--now execute the dbcc checkdb
DBCC CHECKDB(AdventureWorks2019) WITH NO_INFOMSGS
/*
Msg 8939, Level 16, State 98, Line 32
Table error: 
Object ID 2101582525, 
index ID 1, 
partition ID 72057594049724416, 
alloc unit ID 72057594057523200 (type In-row data), 
page (1:1766). Test (IS_OFF (BUF_IOERR, pBUF->bstat)) failed. Values are 133129 and -4.
Msg 8928, Level 16, State 1, Line 32
Object ID 2101582525, 
index ID 1, 
partition ID 72057594049724416, 
alloc unit ID 72057594057523200 (type In-row data): 
Page (1:1766) could not be processed.  See other errors for details.
Msg 8976, Level 16, State 1, Line 32
Table error: 
Object ID 2101582525, 
index ID 1, 
partition ID 72057594049724416, 
alloc unit ID 72057594057523200 (type In-row data). 
Page (1:1766) was not seen in the scan 
although its parent (1:1584) and previous (1:1765) refer to it. 
Check any previous errors.
Msg 8978, Level 16, State 1, Line 32
Table error: 
Object ID 2101582525, 
index ID 1, 
partition ID 72057594049724416, 
alloc unit ID 72057594057523200 (type In-row data). 
Page (1:1767) is missing a reference from previous page (1:1766). 
Possible chain linkage problem.
CHECKDB found 0 allocation errors and 4 consistency errors in table 'Person.Person' (object ID 2101582525).
CHECKDB found 0 allocation errors and 4 consistency errors in database 'AdventureWorks2019'.
repair_allow_data_loss is the minimum repair level for the errors found by DBCC CHECKDB (AdventureWorks2019).

*/
USE AdventureWorks2019
GO
DBCC TRACEON (3604)
--all these pages are corrupted
DBCC PAGE (0,1,1584,3) --Index page
DBCC PAGE (0,1,1767,3) --Next page
DBCC PAGE (0,1,1766,3) --Source Corruption
DBCC PAGE (0,1,1765,3) --Previous Page

RESTORE DATABASE AdventureWorks2019 
PAGE='1:1766, 1:1767, 1:1584, 1:1765' 
FROM disk = N'\\192.168.100.101\share\AdventureWorks2019_recover.bak' WITH FILE = 1, NORECOVERY;
GO
RESTORE LOG AdventureWorks2019  
FROM disk = N'\\192.168.100.101\share\AdventureWorks2019_recover.bak' WITH FILE = 2, NORECOVERY;
GO
RESTORE LOG AdventureWorks2019  
FROM disk = N'\\192.168.100.101\share\AdventureWorks2019_XXXXX.bak' WITH NORECOVERY;
--until the last transaction log backup 
--to rollforward any change on these pages
--then take a log backup to recover at the last LSN
GO
BACKUP LOG AdventureWorks2019 
TO disk = N'\\192.168.100.101\share\AdventureWorks2019_page_corrupt.bak';
GO
RESTORE LOG AdventureWorks2019 
FROM disk = N'\\192.168.100.101\share\AdventureWorks2019_page_corrupt.bak' 
WITH RECOVERY;
GO

DBCC CHECKDB(AdventureWorks2019) WITH NO_INFOMSGS
/*
Commands completed successfully.
*/
USE AdventureWorks2019
GO
SELECT DISTINCT BusinessEntityID FROM Person.Person WITH (INDEX=0) ORDER BY BusinessEntityID DESC
/*
(19972 rows affected)
*/
GO
-- to sync all replicas again we need to restore the last transaction log backup \\192.168.100.101\share\AdventureWorks2019_page_corrupt.bak in all replicas
USE master
GO
:CONNECT SQLSERVERVM01
ALTER AVAILABILITY GROUP [AG] ADD DATABASE [AdventureWorks2019];
GO
:CONNECT SQLSERVERVM02
RESTORE LOG AdventureWorks2019 
FROM disk = N'\\192.168.100.101\share\AdventureWorks2019_page_corrupt.bak' 
WITH NORECOVERY;
GO
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO
:CONNECT SQLSERVERVM03
RESTORE LOG AdventureWorks2019 
FROM disk = N'\\192.168.100.101\share\AdventureWorks2019_page_corrupt.bak' 
WITH NORECOVERY;
GO
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO

