DECLARE @version NVARCHAR(12);
SET @version =  CONVERT(NVARCHAR(12),SERVERPROPERTY('productversion'));
IF  (SELECT SUBSTRING(@version, 1, 1)) = '8'
     select 'NullableTimestampCols' AS IssueName,
        OBJECT_NAME(id) AS TableName
    FROM syscolumns WHERE xtype=189 AND status & 0x08 > 0
ELSE
    SELECT DISTINCT 'NullableTimestampCols' AS IssueName,
        OBJECT_NAME(object_id) as TableName
    FROM sys.columns WHERE system_type_id = 189 AND is_nullable = 1