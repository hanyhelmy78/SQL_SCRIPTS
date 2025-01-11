CREATE PARTITION FUNCTION PartFn_Date (DATETIME)
AS RANGE RIGHT FOR VALUES ('2014-01-01','2015-01-01','2016-01-01','2017-01-01','2018-01-01','2019-01-01')
GO
--DROP PARTITION FUNCTION PartFn_Date

CREATE PARTITION SCHEME PartSc_Date 
AS PARTITION PartFn_Date
TO ('2013','2014','2015','2016','2017','2018','2019')
GO
--DROP PARTITION SCHEME PartSc_Date

SELECT DISTINCT Movement_Code, $partition.pf_hash4(HashValue) Partition#
FROM Movement_Details
ORDER BY Movement_Code

select *
FROM sys.partitions
WHERE OBJECT_NAME(OBJECT_ID) = 'Movement_Details'
GO

SELECT ps.name PartitionSchemeName, pf.name PartitionFnName,boundary_id, value
FROM sys.partition_schemes ps
INNER JOIN sys.partition_functions pf ON pf.function_id=ps.function_id
INNER JOIN sys.partition_range_values prf ON pf.function_id = prf.function_id