SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
IF OBJECT_ID('tempdb..#MissingIndexInfo', 'U') IS NOT NULL
    DROP TABLE #MissingIndexInfo;
IF OBJECT_ID('tempdb..#MissingIdxSuperInfo', 'U') IS NOT NULL
    DROP TABLE #MissingIdxSuperInfo;
IF OBJECT_ID('tempdb..#top20', 'U') IS NOT NULL
    DROP TABLE #top20;

SET NOCOUNT ON;

WITH XMLNAMESPACES  
   (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan') 

SELECT query_plan, plan_handle,sql_handle,execution_count,
       n.value('(@StatementText)[1]', 'VARCHAR(4000)') AS sql_text, 
       --n.value('(//MissingIndexGroup/@Impact)[1]', 'FLOAT') AS impact, 
       DB_ID(REPLACE(REPLACE(n.value('(//MissingIndex/@Database)[1]', 'VARCHAR(128)'),'[',''),']','')) AS database_id, 
       OBJECT_ID(n.value('(//MissingIndex/@Database)[1]', 'VARCHAR(128)') + '.' + 
           n.value('(//MissingIndex/@Schema)[1]', 'VARCHAR(128)') + '.' + 
           n.value('(//MissingIndex/@Table)[1]', 'VARCHAR(128)')) AS OBJECT_ID, 
       n.value('(//MissingIndex/@Database)[1]', 'VARCHAR(128)') + '.' + 
           n.value('(//MissingIndex/@Schema)[1]', 'VARCHAR(128)') + '.' + 
           n.value('(//MissingIndex/@Table)[1]', 'VARCHAR(128)')  
       AS STATEMENT
INTO #MissingIndexInfo 
FROM  
( 
   SELECT query_plan,plan_handle,sql_handle,execution_count
   FROM (    
           SELECT DISTINCT plan_handle,sql_handle,execution_count
           FROM sys.dm_exec_query_stats
         ) AS qs 
       OUTER APPLY sys.dm_exec_query_plan(qs.plan_handle) tp     
   WHERE tp.query_plan.exist('//MissingIndex')=1 
) AS tab (query_plan,plan_handle,sql_handle,execution_count) 
CROSS APPLY query_plan.nodes('//StmtSimple') AS q(n) 
WHERE n.exist('QueryPlan/MissingIndexes') = 1 
	AND DB_ID(REPLACE(REPLACE(n.value('(//MissingIndex/@Database)[1]', 'VARCHAR(128)'),'[',''),']','')) = DB_ID()

CREATE CLUSTERED INDEX ci_sqlhandle ON #MissingIndexInfo(sql_handle)

SELECT  MII.database_id ,
        MII.OBJECT_ID ,
        MII.plan_handle ,
        MII.sql_handle ,
        MII.execution_count ,
        CA.equality_columns ,
        CA.inequality_columns ,
        CA.included_columns ,
        CA.Impact ,
        CA.unique_compiles ,
        CA.user_seeks ,
        CA.avg_total_user_cost ,
        CA.avg_user_impact ,
        CA.last_user_seek
INTO    #MissingIdxSuperInfo
FROM    #MissingIndexInfo MII
        CROSS APPLY ( SELECT    mid.database_id ,
                                mid.object_id ,
                                mid.equality_columns ,
                                mid.inequality_columns ,
                                mid.included_columns ,
                                migs.unique_compiles ,
                                migs.user_seeks ,
                                migs.avg_total_user_cost ,
                                migs.avg_user_impact ,
                                migs.last_user_seek ,
                                ( avg_total_user_cost * avg_user_impact )
                                * ( user_seeks + user_scans ) AS Impact
                      FROM      sys.dm_db_missing_index_group_stats AS migs
                                INNER JOIN sys.dm_db_missing_index_groups AS mig 
									ON migs.group_handle = mig.index_group_handle
                                INNER JOIN sys.dm_db_missing_index_details AS mid 
									ON mig.index_handle = mid.index_handle
                                    AND mid.database_id = DB_ID()
                    ) CA
WHERE   1 = 1
	AND CA.database_id = MII.database_id
	AND CA.object_id = MII.OBJECT_ID;

SELECT DISTINCT TOP 20
        plan_handle ,
        MAX(Impact) AS Impact
INTO    #top20
FROM    #MissingIdxSuperInfo
GROUP BY plan_handle
ORDER BY Impact DESC;

WITH finalsel
          AS ( SELECT   SI.* ,
                        ROW_NUMBER() OVER ( PARTITION BY SI.equality_columns,
                                            SI.inequality_columns,
                                            SI.execution_count ORDER BY SI.Impact DESC ) AS RowNum
               FROM     #MissingIdxSuperInfo SI
                        INNER JOIN #top20 t 
							ON t.plan_handle = SI.plan_handle
             )
    SELECT  fs.* ,
            MII.query_plan ,
            MII.sql_text AS sql_text_inExecplan ,
            MII.STATEMENT AS DB_Schema_Obj ,
            sub.Name ,
            ROW_NUMBER() OVER ( PARTITION BY fs.plan_handle, sub.Name ORDER BY sub.Name ) AS InnerRowNum ,
            ( SELECT    COUNT(*)
              FROM      sys.dm_exec_query_stats s
              WHERE     s.query_hash = sub.query_hash
            ) AS SimilarQueries ,
            ( SELECT    COUNT(*)
              FROM      sys.dm_exec_query_stats s
              WHERE     s.query_plan_hash = sub.query_plan_hash
            ) AS SimilarQueryPlans ,
            ( SELECT    COUNT(qs.query_hash)
              FROM      sys.dm_exec_query_stats qs
              WHERE     qs.sql_handle = MII.sql_handle
              GROUP BY  qs.sql_handle
            ) AS QueriesRelatedtoPlan ,
            ( SELECT    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT
					(NVARCHAR(MAX), N'--' + NCHAR(13) + NCHAR(10) + ist.text
                                                              + NCHAR(13)
                                                              + NCHAR(10)
                                                              + N'--' COLLATE Latin1_General_Bin2),
                                                              NCHAR(31), N'?'),
                                                              NCHAR(30), N'?'),
                                                              NCHAR(29), N'?'),
                                                              NCHAR(28), N'?'),
                                                              NCHAR(27), N'?'),
                                                              NCHAR(26), N'?'),
                                                              NCHAR(25), N'?'),
                                                              NCHAR(24), N'?'),
                                                              NCHAR(23), N'?'),
                                                              NCHAR(22), N'?'),
                                                              NCHAR(21), N'?'),
                                                              NCHAR(20), N'?'),
                                                              NCHAR(19), N'?'),
                                                              NCHAR(18), N'?'),
                                                              NCHAR(17), N'?'),
                                                              NCHAR(16), N'?'),
                                                              NCHAR(15), N'?'),
                                                              NCHAR(14), N'?'),
                                                              NCHAR(12), N'?'),
                                                              NCHAR(11), N'?'),
                                                              NCHAR(8), N'?'),
                                                              NCHAR(7), N'?'),
                                                              NCHAR(6), N'?'),
                                                              NCHAR(5), N'?'),
                                                              NCHAR(4), N'?'),
                                                        NCHAR(3), N'?'),
                                                NCHAR(2), N'?'), NCHAR(1),
                                        N'?'), NCHAR(0), N'') AS [processing-instruction(query)]
              FROM      sys.dm_exec_sql_text(fs.sql_handle) AS ist
            FOR
              XML PATH('') ,
                  TYPE
            ) AS QueryDef ,
            cp.objtype
    INTO    #finalsel
    FROM    finalsel fs
            INNER JOIN #MissingIndexInfo MII 
				ON fs.database_id = MII.database_id
                AND fs.OBJECT_ID = MII.OBJECT_ID
                AND fs.plan_handle = MII.plan_handle
            INNER JOIN sys.dm_exec_cached_plans cp 
				ON fs.plan_handle = cp.plan_handle
            CROSS APPLY ( SELECT TOP 1
                                    ISNULL(p.name, 'ADHOC') AS Name ,
                                    query_hash ,
                                    query_plan_hash
                          FROM      sys.dm_exec_query_stats qs
                                    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle)
                                    AS qt
                                    LEFT OUTER JOIN sys.procedures p 
										ON qt.objectid = p.object_id
                          WHERE     qs.plan_handle = fs.plan_handle
                        ) sub
    WHERE   RowNum = 1;

SELECT  fls.database_id,fls.OBJECT_ID,fls.DB_Schema_Obj,fls.Name,fls.objtype,fls.execution_count
		,fls.equality_columns,fls.inequality_columns,fls.included_columns,fls.Impact,fls.unique_compiles
		,fls.user_seeks,fls.avg_total_user_cost,fls.avg_user_impact,fls.last_user_seek
		,fls.query_plan,fls.sql_text_inExecplan,fls.QueryDef
		,fls.SimilarQueries,fls.SimilarQueryPlans,fls.QueriesRelatedtoPlan
FROM    #finalsel AS fls
WHERE   InnerRowNum = 1
ORDER BY Impact DESC;

DROP TABLE #MissingIndexInfo;
DROP TABLE #MissingIdxSuperInfo;
DROP TABLE #top20;
DROP TABLE #finalsel;