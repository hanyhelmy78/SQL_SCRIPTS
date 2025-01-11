-- FOR A SINGLE TABLE
UPDATE STATISTICS [<TABLE_NAME>] WITH FULLSCAN -- 1ST STEP 2 DO IN INITIAL TROUBLESHOOTING + SCHEDULE IT MONTHLY ***
WITH SAMPLE 10 PERCENT;

-- FOR THE WHOLE DB
EXEC sp_MSForEachTable 'UPDATE STATISTICS ? WITH FULLSCAN;'
EXEC sp_updatestats

/* turn off auto-update stats on a specific table or index */

UPDATE STATISTICS [<TABLE_NAME>] WITH NORECOMPUTE;

ALTER INDEX [<INDEX_NAME>] ON [<TABLE_NAME>] WITH (STATISTICS_NORECOMPUTE);

/* UPDATE STATS HISTORY */
;with cte as (SELECT CAST(((rows_sampled * 1.00)/ [rows] )*100.00 AS NUMERIC(5,2)) AS SamplePCT, OBJECT_NAME(s.object_id) as TableNAME, s.name StatsName,
    sp.*
    FROM sys.stats AS s
    OUTER APPLY sys.dm_db_stats_properties (s.[object_id], s.stats_id) AS sp
    JOIN sys.objects o on s.object_id = o.object_id and o.is_ms_shipped = 0
    WHERE 1=1)
    select * from cte where SamplePCT IS NULL or SamplePCT < 10
    order by SamplePCT