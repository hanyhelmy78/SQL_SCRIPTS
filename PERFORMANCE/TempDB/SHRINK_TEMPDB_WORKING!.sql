CHECKPOINT
GO
-- DBCC FREEPROCCACHE /* ONLY USE THIS IF SHRINKING TempDB FILES IS NOT WORKING */
-- DBCC DROPCLEANBUFFERS 
GO
DBCC SHRINKFILE (TEMPDEV, 1024)
GO