--DBCC USEROPTIONS;
GO 
----------------------------------------------------------------------
SELECT name,is_read_committed_snapshot_on FROM sys.databases WHERE is_read_committed_snapshot_on =1