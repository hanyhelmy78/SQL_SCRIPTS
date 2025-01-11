--Use the below T-SQL script to generate the complete list of tables that need statistics update in a given database:
Declare @Major int,
@Minor int,
@build int,
@revision int,
@i int,
@str nvarchar(100),
@str2 NVARCHAR(10)
 
Set @str=cast(serverproperty('ProductVersion') as NVARCHAR(100))
 
Set @str2=left(@str,charindex('.',@str))
SET @i=len(@str)
Set @str=right(@str,@i-charindex('.',@str))
SET @Major=CAST(Replace(@STR2,'.','') AS INT)
Set @str2=left(@str,charindex('.',@str))
SET @i=len(@str)
Set @str=right(@str,@i-charindex('.',@str))
SET @Minor=CAST(Replace(@STR2,'.','') AS INT)
Set @str2=left(@str,charindex('.',@str))
SET @i=len(@str)
Set @str=right(@str,@i-charindex('.',@str))
SET @Build=CAST(Replace(@STR2,'.','') AS INT)
SET @revision=CAST(@str as int)

IF @Major<10
  SET @i=1
ELSE
IF @Major>10
  SET @i=0
ELSE
  IF @minor=50 AND @Build>=4000
    SET @i=0
  ELSE
    SET @i=1
 
IF @i=1
BEGIN
    EXEC sp_executesql N';WITH StatTables AS(
      SELECT  so.schema_id AS ''schema_id'',  
              so.name AS ''TableName'',
        so.object_id AS ''object_id'',
        CASE indexproperty(so.object_id, dmv.name, ''IsStatistics'') 
                WHEN 0 THEN dmv.rows
                ELSE (SELECT TOP 1 row_count FROM sys.dm_db_partition_stats ps (NOLOCK) WHERE ps.object_id=so.object_id AND ps.index_id in (1,0))
          END AS ''ApproximateRows'',
          dmv.rowmodctr AS ''RowModCtr''
      FROM sys.objects so (NOLOCK)
        JOIN sysindexes dmv (NOLOCK) ON so.object_id = dmv.id 
        LEFT JOIN sys.indexes si (NOLOCK) ON so.object_id = si.object_id AND so.type in (''U'',''V'') AND si.index_id = dmv.indid
      WHERE so.is_ms_shipped = 0
        AND dmv.indid<>0
        AND so.object_id not in (SELECT major_id FROM sys.extended_properties (NOLOCK) WHERE name = N''microsoft_database_tools_support'')
    ),
    StatTableGrouped AS
    (
    SELECT 
      ROW_NUMBER() OVER(ORDER BY TableName) AS seq1, 
      ROW_NUMBER() OVER(ORDER BY TableName DESC) AS seq2,
      TableName,
      cast(Max(ApproximateRows) AS bigint) AS ApproximateRows,
      cast(Max(RowModCtr) AS bigint) AS RowModCtr,
      schema_id,object_id
    FROM StatTables st
    GROUP BY schema_id,object_id,TableName
    HAVING (Max(ApproximateRows) > 500 AND Max(RowModCtr) > (Max(ApproximateRows)*0.2 + 500 ))
    )
    SELECT
      @@SERVERNAME AS InstanceName,
      seq1 + seq2 - 1 AS #Occurences,
      SCHEMA_NAME(stg.schema_id) AS ''SchemaName'', 
      stg.TableName,
      CASE OBJECTPROPERTY(stg.object_id, ''TableHasClustIndex'')
            WHEN 1 THEN ''Clustered''
            WHEN 0 THEN ''Heap''
            ELSE ''Indexed View''
          END AS ClusteredHeap,
      CASE objectproperty(stg.object_id, ''TableHasClustIndex'')
              WHEN 0 THEN (SELECT count(*) FROM sys.indexes i (NOLOCK) where i.object_id= stg.object_id) - 1
              ELSE (SELECT count(*) FROM sys.indexes i (NOLOCK) where i.object_id= stg.object_id)
        END AS IndexCount,
      (SELECT count(*) FROM sys.columns c (NOLOCK) WHERE c.object_id = stg.object_id ) AS ColumnCount ,
      (SELECT count(*) FROM sys.stats s (NOLOCK) WHERE s.object_id = stg.object_id) AS StatCount ,
      stg.ApproximateRows,
      stg.RowModCtr,
      stg.schema_id,
      stg.object_id
    FROM StatTableGrouped stg'
END
ELSE
BEGIN
    EXEC sp_executesql N';WITH StatTables AS(
      SELECT  so.schema_id AS ''schema_id'',  
              so.name AS ''TableName'',
        so.object_id AS ''object_id''
        , ISNULL(sp.rows,0) AS ''ApproximateRows''
        , ISNULL(sp.modification_counter,0) AS ''RowModCtr''
      FROM sys.objects so (NOLOCK)
        JOIN sys.stats st (NOLOCK) ON so.object_id=st.object_id
        CROSS APPLY sys.dm_db_stats_properties(so.object_id, st.stats_id) AS sp
      WHERE so.is_ms_shipped = 0
        AND st.stats_id<>0
        AND so.object_id not in (SELECT major_id FROM sys.extended_properties (NOLOCK) WHERE name = N''microsoft_database_tools_support'')
    ),
    StatTableGrouped AS
    (
    SELECT 
      ROW_NUMBER() OVER(ORDER BY TableName) AS seq1, 
      ROW_NUMBER() OVER(ORDER BY TableName DESC) AS seq2,
      TableName,
      cast(Max(ApproximateRows) AS bigint) AS ApproximateRows,
      cast(Max(RowModCtr) AS bigint) AS RowModCtr,
      count(*) AS StatCount,
      schema_id,object_id
    FROM StatTables st
    GROUP BY schema_id,object_id,TableName
    HAVING (Max(ApproximateRows) > 500 AND Max(RowModCtr) > (Max(ApproximateRows)*0.2 + 500 ))
    )
    SELECT
      @@SERVERNAME AS InstanceName,
      seq1 + seq2 - 1 AS #Occurences,
      SCHEMA_NAME(stg.schema_id) AS ''SchemaName'', 
      stg.TableName,
      CASE OBJECTPROPERTY(stg.object_id, ''TableHasClustIndex'')
            WHEN 1 THEN ''Clustered''
            WHEN 0 THEN ''Heap''
            ELSE ''Indexed View''
          END AS ClusteredHeap,
      CASE objectproperty(stg.object_id, ''TableHasClustIndex'')
              WHEN 0 THEN (SELECT count(*) FROM sys.indexes i (NOLOCK) where i.object_id= stg.object_id) - 1
              ELSE (SELECT count(*) FROM sys.indexes i (NOLOCK) where i.object_id= stg.object_id)
        END AS IndexCount,
      (SELECT count(*) FROM sys.columns c (NOLOCK) WHERE c.object_id = stg.object_id ) AS ColumnCount ,
      stg.StatCount,
      stg.ApproximateRows,
      stg.RowModCtr,
      stg.schema_id,
      stg.object_id
    FROM StatTableGrouped stg'
END