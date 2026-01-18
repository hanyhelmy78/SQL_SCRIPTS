-- alert when log file size exceeds 50% of data file size
SELECT db.name, 
    CAST(SUM(CASE WHEN mf.type = 1 THEN mf.size END) * 100.0 / 
	NULLIF(SUM(CASE WHEN mf.type = 0 THEN mf.size END), 0) AS DECIMAL(5,1)) AS LogToDataRatio
FROM sys.databases db INNER JOIN sys.master_files mf 
  ON db.database_id = mf.database_id
GROUP BY db.name
HAVING SUM(CASE WHEN mf.type = 1 THEN mf.size END) * 100.0 / 
 NULLIF(SUM(CASE WHEN mf.type = 0 THEN mf.size END), 0) > 50;