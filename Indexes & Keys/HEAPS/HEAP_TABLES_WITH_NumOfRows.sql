-- FOCUS ONLY on the large tables, as the SQL Server Query Optimizer will not benefit from the indexes created on smaller tables.
SELECT OBJECT_NAME(IDX.object_id)  Table_Name
      , IDX.name  Index_name
	  , PAR.rows  NumOfRows
	  , IDX.type_desc  TypeOfIndex
FROM sys.partitions PAR
INNER JOIN sys.indexes IDX ON PAR.object_id = IDX.object_id  AND PAR.index_id = IDX.index_id AND IDX.type = 0
INNER JOIN sys.tables TBL
ON TBL.object_id = IDX.object_id and TBL.type ='U'
ORDER BY NumOfRows DESC