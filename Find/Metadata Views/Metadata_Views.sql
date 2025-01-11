CREATE VIEW tables
AS
  SELECT 
    t.[object_id], 
    [schema] = QUOTENAME(s.name),
    [table] = QUOTENAME(t.name),
    [object] = QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s 
  ON t.[schema_id] = s.[schema_id];
GO
CREATE VIEW schemabound_references
AS
  SELECT 
    t.[object_id],
    reference_count = COUNT(*)
  FROM tables AS t
  CROSS APPLY sys.dm_sql_referencing_entities(t.[object], N'OBJECT') AS r
  WHERE EXISTS
  (
    SELECT 1 
    FROM sys.sql_modules AS m
    WHERE m.[object_id] = r.referencing_id
    AND m.is_schema_bound = 1
  )
  GROUP BY t.[object_id];
GO
CREATE VIEW foreign_key_counts
AS
  SELECT 
    [object_id],
    inbound_count = COUNT(CASE t WHEN 'I' THEN 1 END),
    outbound_count = COUNT(CASE t WHEN 'O' THEN 1 END)
  FROM
  (
    SELECT [object_id] = referenced_object_id, t = 'I'
    FROM sys.foreign_keys
    UNION ALL
    SELECT [object_id] = parent_object_id, t = 'O'
    FROM sys.foreign_keys
  ) AS c
  GROUP BY [object_id];
GO
CREATE VIEW basic_storage
AS
  SELECT
    [object_id],
    [data_compression], -- on at least one partition
    has_partitions = CASE partition_count WHEN 1 THEN 0 ELSE 1 END,
    partition_count
  FROM
  (
    SELECT   
      [object_id],
      [data_compression] = MAX(COALESCE(NULLIF(data_compression_desc,'NONE'),'')),
      partition_count = COUNT(*)
    FROM sys.partitions
    WHERE index_id IN (0,1)
    GROUP BY [object_id]
  ) AS p;
GO
CREATE VIEW trigger_counts
AS
  SELECT 
    [object_id] = parent_id,
    after_trigger_count = COUNT(NULLIF(is_instead_of_trigger,1)),
    instead_of_trigger_count = COUNT(NULLIF(is_instead_of_trigger,0))
  FROM sys.triggers
  GROUP BY parent_id;
GO
CREATE VIEW constraint_counts
AS
  SELECT 
    [object_id] = parent_object_id,
    default_constraint_count = COUNT(CASE t WHEN 'D' THEN 1 END),
    check_constraint_count = COUNT(CASE t WHEN 'C' THEN 1 END)
  FROM
  (
    SELECT parent_object_id, t = 'D'
    FROM sys.default_constraints
    UNION ALL
    SELECT parent_object_id, t = 'C'
    FROM sys.check_constraints
  ) AS c
  GROUP BY parent_object_id;
GO
CREATE VIEW indexes
AS
  SELECT 
    i.[object_id],
    i.has_clustered_index,
    i.has_primary_key,
    i.unique_index_count,
    i.filtered_index_count,
    p.nonclustered_index_count,
    p.xml_index_count,
    p.spatial_index_count
  FROM
  (
    SELECT [object_id],
      has_clustered_index = MIN(index_id),
      has_primary_key = MAX(CONVERT(TINYINT,is_primary_key)),
      unique_index_count = COUNT(CASE WHEN is_unique = 1 THEN 1 END),
      filtered_index_count = COUNT(CASE WHEN has_filter = 1 THEN 1 END)
    FROM sys.indexes AS i
    GROUP BY i.[object_id]
  ) AS i
  LEFT OUTER JOIN
  (
    SELECT [object_id], 
      nonclustered_index_count = COALESCE([2],0), 
      xml_index_count = COALESCE([3],0), 
      spatial_index_count = COALESCE([4],0)
      -- columnstore, hash etc. too if you like
    FROM 
    (
      SELECT [object_id], [type], c = COUNT(*)
      FROM sys.indexes 
      GROUP BY [object_id], [type]
    ) AS x
    PIVOT (MAX(c) FOR type IN ([2],[3],[4],[5],[6],[7])) AS p
  ) AS p
  ON i.[object_id] = p.[object_id];
GO
CREATE VIEW columns
AS
  SELECT 
    c.[object_id],
    column_count = COUNT(c.column_id),
    column_list = STUFF((SELECT N',' + QUOTENAME(name)
      FROM sys.columns AS c2
      WHERE c2.[object_id] = c.[object_id]
      ORDER BY c2.column_id
      FOR XML PATH, TYPE).value(N'.[1]',N'nvarchar(max)'),1,1,N''),
    has_identity_column = COUNT(NULLIF(c.is_identity,0)),
    computed_column_count = COUNT(NULLIF(c.is_computed,0)),
    persisted_computed_column_count = COUNT(NULLIF(cc.is_persisted,0)),
    LOB_column_count = COUNT
    (
      CASE 
        WHEN c.system_type_id IN (34,35,99,241) THEN 1
        WHEN c.system_type_id IN (165,167,231) AND c.max_length = -1 THEN 1
      END
    ),
    XML_column_count = COUNT(CASE WHEN c.system_type_id = 241 THEN 1 END),
    spatial_column_count = COUNT(CASE WHEN c.user_type_id IN (129,130) THEN 1 END),
    hierarchyid_column_count = COUNT(CASE WHEN c.user_type_id = 128 THEN 1 END),
    rowversion_column_count = COUNT(CASE WHEN c.system_type_id = 189 THEN 1 END),
    GUID_column_count = COUNT(CASE WHEN c.system_type_id = 36 THEN 1 END),
    deprecated_column_count = COUNT(CASE WHEN c.system_type_id IN (34,35,99) THEN 1 END),
    alias_type_count = COUNT(NULLIF(t.is_user_defined,0))
  FROM sys.columns AS c
  INNER JOIN sys.types AS t
  ON c.system_type_id = t.system_type_id
  LEFT OUTER JOIN sys.computed_columns AS cc
  ON c.[object_id] = cc.[object_id]
  AND c.column_id = cc.column_id
  GROUP BY c.[object_id];
GO
CREATE VIEW table_access
AS
  SELECT 
    [object_id],
    last_read = MAX(last_read),
    last_write = MAX(last_write)
  FROM
  (
    SELECT [object_id], 
      last_read = (SELECT MAX(d) FROM (VALUES
        (last_user_seek),(last_user_scan),(last_user_lookup))
         AS reads(d)),
      last_write = (SELECT MAX(d) FROM (VALUES
        (last_user_update))
         AS writes(d))
    FROM sys.dm_db_index_usage_stats
  ) AS x GROUP BY [object_id];
GO
CREATE FUNCTION tvf_spaceused
(
  @object_id INT
)
RETURNS TABLE
AS
  RETURN 
  (
    SELECT
      [rows],
      reserved_kb = r,
      data_kb = p,
      index_size_kb = CASE WHEN u > p THEN u - p ELSE 0 END,
      unused_kb = CASE WHEN r > u THEN r - u ELSE 0 END
    FROM 
    (
      SELECT 
        r = (SUM (p1.reserved_page_count) + COALESCE(MAX(it.r),0)) * 8,
        u = (SUM (p1.used_page_count) + COALESCE(MAX(it.u),0)) * 8,
        p = (SUM (CASE WHEN p1.index_id >= 2 THEN 0 ELSE
          (p1.in_row_data_page_count + p1.lob_used_page_count + p1.row_overflow_used_page_count)
        END) * 8),
        [rows] = SUM (CASE WHEN p1.index_id IN (0,1) 
          THEN p1.row_count ELSE 0 END)
      FROM sys.dm_db_partition_stats AS p1
      LEFT OUTER JOIN
      (
        SELECT it.parent_id,
          r = SUM(p2.reserved_page_count),
          u = SUM(p2.used_page_count)
        FROM sys.internal_tables AS it
        INNER JOIN sys.dm_db_partition_stats AS p2
        ON it.[object_id] = p2.[object_id]
        WHERE it.parent_id = @object_id
        AND it.internal_type IN (202,204,207,211,212,213,214,215,216,221,222,236)
        GROUP BY it.parent_id
      ) AS it
      ON p1.[object_id] = it.parent_id
      WHERE p1.[object_id] = @object_id
    ) AS x);
GO