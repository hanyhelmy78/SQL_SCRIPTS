-- =============================================================================
-- Top 25 Query Store Missing Index Recommendations
-- =============================================================================
-- Description:  Identifies the top 25 missing indexes by cross-referencing
--               SQL Server's missing index DMVs with Query Store execution
--               data, filtering for business hours only, to calculate
--               real-world impact.
--
-- Original Author: Pinal Dave (SQLAuthority.com)
-- Extended by:     Joao Barbosa
-- Additions:       Query Store cross-reference, business-hours filtering
--                  (weekdays 07:30-18:30), memory/IO metrics, calculated
--                  impact scoring, table write activity, existing index count
--
-- Requirements:    SQL Server 2019+ with Query Store enabled
-- Usage:           Execute in the context of the target database
--                  USE [YourDatabaseName];
-- =============================================================================

WITH BusinessHoursStats AS (
    -- Aggregate Query Store execution stats per missing index group,
    -- filtered to business hours only (weekdays 07:30-18:30)
    SELECT
        miq.group_handle,
        SUM(qrs.count_executions)                                                AS total_executions,
        AVG(CAST(qrs.avg_duration / 1000 AS BIGINT))                             AS avg_duration_ms,
        SUM(CAST(qrs.count_executions * qrs.avg_duration / 1000 AS BIGINT))      AS total_execution_time_ms,
        AVG(CAST(qrs.avg_query_max_used_memory * 8.0 / 1024.0 AS DECIMAL(15,2))) AS avg_memory_mb,
        MIN(CAST(qrs.min_query_max_used_memory * 8.0 / 1024.0 AS DECIMAL(15,2))) AS min_memory_mb,
        MAX(CAST(qrs.max_query_max_used_memory * 8.0 / 1024.0 AS DECIMAL(15,2))) AS max_memory_mb,
        AVG(CAST(qrs.avg_logical_io_reads * 8.0 / 1024.0 AS DECIMAL(15,2)))      AS avg_logical_reads_mb,
        MIN(CAST(qrs.min_logical_io_reads * 8.0 / 1024.0 AS DECIMAL(15,2)))      AS min_logical_reads_mb,
        MAX(CAST(qrs.max_logical_io_reads * 8.0 / 1024.0 AS DECIMAL(15,2)))      AS max_logical_reads_mb
    FROM sys.dm_db_missing_index_group_stats_query AS miq
    INNER JOIN sys.query_store_query AS qs
        ON qs.query_hash = miq.query_hash
    INNER JOIN sys.query_store_plan AS qp
        ON qp.query_id = qs.query_id
    INNER JOIN sys.query_store_runtime_stats AS qrs
        ON qrs.plan_id = qp.plan_id
    INNER JOIN sys.query_store_runtime_stats_interval AS rsi
        ON rsi.runtime_stats_interval_id = qrs.runtime_stats_interval_id
    WHERE
        DATENAME(WEEKDAY, rsi.start_time) IN ('Monday','Tuesday','Wednesday','Thursday','Friday')
        AND CAST(rsi.start_time AS TIME) >= '07:30:00'
        AND CAST(rsi.start_time AS TIME) <= '18:30:00'
    GROUP BY
        miq.group_handle
)

SELECT TOP 25
    -- Table identification
    DB_NAME(mid.database_id)                                          AS database_name,
    sche.name                                                         AS schema_name,
    tab.name                                                          AS table_name,
    migs.group_handle,

    -- Query Store: calculated impact (total time x estimated improvement %)
    -- NULL when no Query Store data exists for business hours (sorted last)
    CAST(bhs.total_execution_time_ms * migs.avg_user_impact AS BIGINT)
                                                                      AS qs_calculated_impact,

    -- DMV-based impact (traditional calculation)
    migs.avg_user_impact * (migs.user_seeks + migs.user_scans)        AS dmv_calculated_impact,
    migs.avg_user_impact                                              AS percent_impact,
    migs.last_user_seek,
    migs.last_user_scan,
    migs.user_seeks,
    migs.user_scans,
    migs.avg_total_system_cost,
    migs.unique_compiles,

    -- Query Store: highest-impact query_id for this missing index
    (
        SELECT TOP 1 qs.query_id
        FROM sys.dm_db_missing_index_group_stats_query AS miq
        INNER JOIN sys.query_store_query AS qs
            ON qs.query_hash = miq.query_hash
        WHERE miq.group_handle = migs.group_handle
        ORDER BY miq.avg_user_impact * (miq.user_seeks + miq.user_scans) DESC
    )                                                                 AS query_id_highest_impact,

    -- Query Store: execution metrics
    bhs.total_executions                                              AS qs_total_executions,
    bhs.avg_duration_ms                                               AS qs_avg_duration_ms,
    bhs.total_execution_time_ms,

    -- Query Store: memory metrics
    bhs.min_memory_mb,
    bhs.avg_memory_mb,
    bhs.max_memory_mb,

    -- Query Store: logical IO metrics
    bhs.min_logical_reads_mb,
    bhs.avg_logical_reads_mb,
    bhs.max_logical_reads_mb,

    -- Write activity on the clustered index (index maintenance cost indicator)
    (
        SELECT TOP 1 u.user_updates
        FROM sys.dm_db_index_usage_stats AS u
        INNER JOIN sys.indexes AS i
            ON u.object_id = i.object_id AND u.index_id = i.index_id
        WHERE u.object_id = tab.object_id
            AND i.index_id = 1
            AND u.database_id = DB_ID()
    )                                                                 AS writes_on_pk,

    -- Total indexes on this table (avoid over-indexing)
    (
        SELECT COUNT(*)
        FROM sys.indexes AS i
        WHERE i.object_id = tab.object_id
            AND i.index_id > 0
    )                                                                 AS existing_index_count,

    -- Missing index details
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns,

    -- Ready-to-use CREATE INDEX statement
    'CREATE INDEX [IX_' + OBJECT_NAME(mid.object_id, mid.database_id) + '_'
        + REPLACE(REPLACE(REPLACE(ISNULL(mid.equality_columns, ''), ', ', '_'), '[', ''), ']', '')
        + CASE
            WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN '_'
            ELSE ''
          END
        + REPLACE(REPLACE(REPLACE(ISNULL(mid.inequality_columns, ''), ', ', '_'), '[', ''), ']', '')
        + '] ON ' + mid.statement
        + ' (' + ISNULL(mid.equality_columns, '')
        + CASE
            WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ', '
            ELSE ''
          END
        + ISNULL(mid.inequality_columns, '')
        + ')'
        + ISNULL(' INCLUDE (' + mid.included_columns + ')', '')       AS create_statement

FROM sys.dm_db_missing_index_groups AS mig
INNER JOIN sys.dm_db_missing_index_group_stats AS migs
    ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid
    ON mig.index_handle = mid.index_handle
INNER JOIN sys.objects AS tab
    ON mid.object_id = tab.object_id
INNER JOIN sys.schemas AS sche
    ON tab.schema_id = sche.schema_id
LEFT JOIN BusinessHoursStats AS bhs
    ON bhs.group_handle = migs.group_handle
WHERE
    mid.database_id = DB_ID()
ORDER BY
    -- NULLs go last: rows without Query Store data rank below those with data
    qs_calculated_impact DESC
OPTION (MAXDOP 1);
GO