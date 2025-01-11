SET NOCOUNT ON;
DECLARE @printOnly  BIT =0 -- change to 1 if you don't want to execute, just print commands
    ,   @tableName    VARCHAR(256)
    ,   @schemaName   VARCHAR(100)
    ,   @sqlStatement NVARCHAR(1000)
    ,   @tableCount   INT
    ,   @statusMsg    VARCHAR(1000);
 
IF EXISTS(SELECT * FROM tempdb.sys.tables WHERE name LIKE '%#tables%')
    DROP TABLE #tables; 
 
CREATE TABLE #tables
(
      database_name     sysname
    , schemaName        sysname NULL
    , tableName         sysname NULL
    , processed         bit);
 
IF EXISTS(SELECT * FROM tempdb.sys.tables WHERE name LIKE '%#compression%')
    DROP TABLE #compressionResults;
 
IF NOT EXISTS(SELECT * FROM tempdb.sys.tables WHERE name LIKE '%#compression%')
BEGIN 
    CREATE TABLE #compressionResults
    (
          objectName                    varchar(100)
        , schemaName                    varchar(50)
        , index_id                      int
        , partition_number              int
        , size_current_compression      bigint
        , size_requested_compression    bigint
        , sample_current_compression    bigint
        , sample_requested_compression  bigint);
END;
 
INSERT INTO #tables
SELECT DB_NAME()
    , SCHEMA_NAME([schema_id])
    , name
    , 0 -- unprocessed
FROM sys.tables;
 
SELECT @tableCount = COUNT(*) FROM #tables;
 
WHILE EXISTS(SELECT * FROM #tables WHERE processed = 0)
BEGIN
 
    SELECT TOP 1 @tableName = tableName
        , @schemaName = schemaName
    FROM #tables WHERE processed = 0;
 
    SELECT @statusMsg = 'Working on ' + CAST(((@tableCount - COUNT(*)) + 1) AS VARCHAR(10)) 
        + ' of ' + CAST(@tableCount AS VARCHAR(10))
    FROM #tables
    WHERE processed = 0;
 
    RAISERROR(@statusMsg, 0, 42) WITH NOWAIT;
 
    SET @sqlStatement = 'EXECUTE sp_estimate_data_compression_savings ''' 
                        + @schemaName + ''', ''' + @tableName + ''', NULL, NULL, ''PAGE'';' -- ROW, PAGE, or NONE
    IF @printOnly = 1
    BEGIN 
        SELECT @sqlStatement;
    END
    ELSE
    BEGIN
        INSERT INTO #compressionResults
        EXECUTE sp_executesql @sqlStatement;
    END;
 
    UPDATE #tables
    SET processed = 1
    WHERE tableName = @tableName
        AND schemaName = @schemaName;
END;
 
SELECT objectName TableName,index_id,size_current_compression/1024 Size_Before_MB,size_requested_compression/1024 Size_After_MB
FROM #compressionResults
ORDER BY size_current_compression DESC;