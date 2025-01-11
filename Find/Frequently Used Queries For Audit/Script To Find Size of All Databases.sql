SELECT
       d.name,
       d.create_date,
       d.database_id,
       ROUND(SUM(mf.size) * 8 / 1024, 0) Size_MBs
FROM
       sys.master_files mf
INNER JOIN sys.databases d
       ON d.database_id = mf.database_id
--WHERE
--     d.database_id &gt; 4 -- Skip system databases
GROUP BY
       d.name, d.create_date,d.database_id
ORDER BY
       Size_MBs desc