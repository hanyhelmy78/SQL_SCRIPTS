SELECT  B.name AS DBNAme,D.database_id,D.* ,
        s.avg_total_user_cost ,
        s.avg_user_impact ,
        s.last_user_seek ,
        s.last_user_scan        ,
        s.unique_compiles ,
        'CREATE INDEX [Indx_' + OBJECT_NAME(d.object_id, d.database_id) + '_'
        + REPLACE(REPLACE(REPLACE(ISNULL(d.equality_columns, ''), ', ', '_'),
                          '[', ''), ']', '')
        + CASE WHEN d.equality_columns IS NOT NULL
                    AND d.inequality_columns IS NOT NULL THEN '_'
               ELSE ''
          END + REPLACE(REPLACE(REPLACE(ISNULL(d.inequality_columns, ''), ', ',
                                        '_'), '[', ''), ']', '') + ']'
        + ' ON ' + d.statement + ' (' + ISNULL(d.equality_columns, '')
        + CASE WHEN d.equality_columns IS NOT NULL
                    AND d.inequality_columns IS NOT NULL THEN ','
               ELSE ''
          END + ISNULL(d.inequality_columns, '') + ')' + ISNULL(' INCLUDE ('
                                                              + d.included_columns
                                                              + ')', '')
        + ' WITH(FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ' + CHAR(10)
        + CHAR(13) + 'PRINT ''Index '
        + CONVERT(VARCHAR(10), ROW_NUMBER() OVER ( ORDER BY avg_user_impact DESC ))
        + ' [Indx_' + OBJECT_NAME(d.object_id, d.database_id) + '_'
        + REPLACE(REPLACE(REPLACE(ISNULL(d.equality_columns, ''), ', ', '_'),
                          '[', ''), ']', '')
        + CASE WHEN d.equality_columns IS NOT NULL
                    AND d.inequality_columns IS NOT NULL THEN '_'
               ELSE ''
          END + REPLACE(REPLACE(REPLACE(ISNULL(d.inequality_columns, ''), ', ',
                                        '_'), '[', ''), ']', '') + '] '
        + 'Created '' + CONVERT(VARCHAR(103),GETDATE())' + CHAR(10) + CHAR(13)
        + 'Go' + CHAR(10) + CHAR(13) AS Create_Statement
FROM    sys.dm_db_missing_index_group_stats s ,
        sys.dm_db_missing_index_groups g ,
        sys.dm_db_missing_index_details d   
		INNER JOIN Sys.databases AS B  
		ON d.database_id = B.database_id 
WHERE   s.group_handle = g.index_group_handle
        AND d.index_handle = g.index_handle 
AND s.avg_user_impact >= 80
AND D.database_id > 4 AND B.NAME <> 'distribution'
--AND B.Name = 'distribution'    --Option 
ORDER BY name,avg_user_impact DESC
GO