USE StackOverflow
GO

SET NOCOUNT ON

-- ENABLE MINIMAL LOGGING FOR BULK OPERATION OPTIMIZATIONS
DBCC TRACEON(610)

PRINT 'Migration Script Starting …'
PRINT 'Start time: ' + CONVERT(varchar, GETDATE(), 120)
PRINT 'Migrating remaining rows from PostHistory to PostHistory_Partitioned …'

-- CHECK CURRENT STATE
DECLARE @SourceCount BIGINT, @TargetCount BIGINT, @StartingCount BIGINT
SELECT @SourceCount = COUNT(*) FROM dbo.PostHistory
SELECT @StartingCount = COUNT(*) FROM dbo.PostHistory_Partitioned

PRINT 'Source table rows: ' + CAST(@SourceCount AS varchar(20))
PRINT 'Target table rows (before): ' + CAST(@StartingCount AS varchar(20))
PRINT 'Remaining to migrate: ' + CAST(@SourceCount - @StartingCount AS varchar(20))

-- THE ACTUAL BULK MIGRATION
INSERT INTO dbo.PostHistory_Partitioned WITH (TABLOCK)
SELECT Id, PostHistoryTypeId, PostId, RevisionGUID, CreationDate, 
       UserId, UserDisplayName, Comment, Text
FROM dbo.PostHistory
WHERE Id > (SELECT ISNULL(MAX(Id), 0) FROM dbo.PostHistory_Partitioned)
ORDER BY CreationDate, Id

-- GET FINAL COUNTS AND STATS
DECLARE @MigratedRows BIGINT = @@ROWCOUNT
SELECT @TargetCount = COUNT(*) FROM dbo.PostHistory_Partitioned

PRINT ''
PRINT '🎉 Migration completed at: ' + CONVERT(varchar, GETDATE(), 120)
PRINT 'Rows migrated this run: ' + CAST(@MigratedRows AS varchar(20))
PRINT 'Total target table rows: ' + CAST(@TargetCount AS varchar(20))

-- VALIDATION
IF @SourceCount = @TargetCount
BEGIN
    PRINT '✅ SUCCESS: Row counts match perfectly!'
    PRINT '✅ Migration completed successfully!'
    
-- UPDATE STATISTICS FOR OPTIMAL PERFORMANCE
    PRINT 'Updating statistics…'
    UPDATE STATISTICS dbo.PostHistory_Partitioned
    PRINT '📊 Statistics updated'
END
ELSE
BEGIN
    PRINT '❌ WARNING: Row count mismatch!'
    PRINT 'Expected: ' + CAST(@SourceCount AS varchar(20))
    PRINT 'Actual: ' + CAST(@TargetCount AS varchar(20))
    PRINT 'Difference: ' + CAST(@SourceCount - @TargetCount AS varchar(20))
END

-- SHOW PARTITION DISTRIBUTION
PRINT ''
PRINT '📊 Partition Distribution:'
SELECT 
    '$partition.pf_PostHistory_Quarterly(CreationDate)' as PartitionNumber,
    COUNT(*) as RowCount,
    MIN(CreationDate) as MinDate,
    MAX(CreationDate) as MaxDate
FROM dbo.PostHistory_Partitioned
GROUP BY $partition.pf_PostHistory_Quarterly(CreationDate)
ORDER BY PartitionNumber

PRINT ''
PRINT '🍻 Script completed!'

-- DISABLE TRACE FLAG
DBCC TRACEOFF(610)