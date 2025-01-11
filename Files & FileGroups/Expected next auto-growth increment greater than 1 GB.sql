USE master; 
GO 
SELECT 
database_id, db_name(database_id) AS database_name, name AS Log_Filename, 
is_percent_growth As growth_in_percentage_set, 
CASE WHEN is_percent_growth = 1 THEN growth else 0 END AS Percentage_growth_value, 
CASE WHEN is_percent_growth = 1 THEN CAST((size*8) AS FLOAT) /1024 
ELSE 0 END as File_Size_in_MB, 
CASE WHEN is_percent_growth = 1 THEN CAST((size*8*growth) AS FLOAT)/100/1024 
ELSE CAST((8*growth) AS FLOAT)/1024 END AS next_growth_in_MB, 
type_desc AS Filetype 
FROM sys.master_files 
WHERE 
CASE WHEN is_percent_growth = 1 THEN CAST((size*8*growth) AS FLOAT)/100/1024 
ELSE CAST((8*growth) AS FLOAT)/1024 END >1023 
AND type_desc='LOG'; 
GO