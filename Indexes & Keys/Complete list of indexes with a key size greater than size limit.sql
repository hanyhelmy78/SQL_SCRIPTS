/*
- For SQL Server 2014 and earlier versions: the limit is 900 bytes for both clustered and non-clustered indexes.
- For SQL Server 2016 and later versions: the limit is 900 bytes for clustered indexes and 1700 bytes for non-clustered indexes.
If an INSERT or UPDATE operation exceeds the limit, you will receive an error message and the operation will fail.

You should avoid exceeding the size limit when creating indexes in order to avoid INSERT and UPDATE operation failures. Narrower indexes also take up less disk space and require fewer system resources to maintain. To allow for larger indexes without exceeding the index key byte limit, use the INCLUDE option provided in SQL Server 2008 and later versions.

Use the following Transact-SQL (T-SQL) script to generate the complete list of indexes with a key size greater than size limit in a given database:
*/
DECLARE @sqlmajorver int, @sqlcmd NVARCHAR(max)
SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff)
SET @sqlcmd='SELECT @@servername InstanceName, DB_Name() DBName, 
schema_name (o.schema_id) AS ''SchemaName'',o.name AS TableName, 
i.name AS IndexName, i.type AS IndexType, sum(max_length) AS KeyLength,'
IF @sqlmajorver >= 13  SET @sqlcmd=@sqlcmd+'CASE WHEN i.type=2 THEN 1700 ELSE 900 END'
ELSE SET @sqlcmd=@sqlcmd+'900'
SET @sqlcmd=@sqlcmd+' SizeLimit, count (ic.index_id) AS ''ColumnCount''
FROM sys.indexes i (NOLOCK) 
INNER JOIN sys.objects o (NOLOCK)  ON i.object_id =o.object_id  '
IF @sqlmajorver >= 11 SET @sqlcmd=@sqlcmd+' INNER JOIN sys.tables t (NOLOCK)  ON o.object_id =t.object_id AND t.is_filetable=0 '
IF @sqlmajorver >= 12 SET @sqlcmd=@sqlcmd+' AND t.is_memory_optimized=0 '
SET @sqlcmd=@sqlcmd+' INNER JOIN sys.index_columns ic  (NOLOCK) ON ic.object_id =i.object_id and ic.index_id =i.index_id
INNER JOIN sys.columns c  (NOLOCK) ON c.object_id = ic.object_id and c.column_id = ic.column_id
WHERE o.type =''U'' and i.index_id >0 and ic.is_included_column=0
GROUP BY o.schema_id,o.object_id,o.name,i.object_id,i.name,i.index_id,i.type
HAVING (sum(max_length) > '
IF @sqlmajorver >= 13 SET @sqlcmd=@sqlcmd+'CASE WHEN i.type=2 THEN 1700 ELSE 900 END)'
ELSE SET @sqlcmd=@sqlcmd+'900)'
SET @sqlcmd=@sqlcmd+' ORDER BY 1,2,3,4'
EXEC sp_executesql @sqlcmd