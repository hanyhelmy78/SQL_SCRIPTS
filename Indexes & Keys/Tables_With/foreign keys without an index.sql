SELECT 
   RC.Constraint_Name AS FK_Constraint,
   RC.Constraint_Catalog AS FK_Database,
   RC.Constraint_Schema AS FK_Schema,
   CCU.Table_Name AS FK_Table,
   CCU.Column_Name AS FK_Column
FROM 
   information_schema.referential_constraints RC JOIN
   INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE CCU ON 
       RC.CONSTRAINT_NAME = CCU.CONSTRAINT_NAME JOIN
   INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE CCU2 ON
       RC.UNIQUE_CONSTRAINT_NAME = CCU2.CONSTRAINT_NAME LEFT JOIN
   sys.columns C ON
       CCU.Column_Name = C.name AND
       CCU.Table_Name = OBJECT_NAME(C.OBJECT_ID) LEFT JOIN
   sys.index_columns IC ON
       C.OBJECT_ID = IC.OBJECT_ID AND
       C.column_id = IC.column_id LEFT JOIN
   sys.indexes I ON
       IC.OBJECT_ID = I.OBJECT_ID AND
       IC.index_Id = I.index_Id 
WHERE
   I.name IS NULL
ORDER BY
   RC.Constraint_NAME