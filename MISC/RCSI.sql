-- Enable RCSI (This gives readers a row version from tempdb instead of a shared lock so readers won't block writers)

ALTER DATABASE  
SET READ_COMMITTED_SNAPSHOT ON
WITH ROLLBACK AFTER 5;  -- give active connections 5 seconds to commit
GO

SELECT name,is_read_committed_snapshot_on 
FROM sys.databases 
WHERE is_read_committed_snapshot_on = 1
