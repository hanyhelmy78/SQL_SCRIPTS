-- SELECT * FROM uber_table_info ORDER BY [table];
CREATE OR ALTER VIEW uber_table_info
AS
  SELECT
    -- basic metadata
    t.[schema],
    t.[table],
      
    -- mimic spaceused
    su.[rows], 
    su.reserved_kb,
    su.data_kb,
    su.index_size_kb,
    su.unused_kb,
  
    -- last access:
    ta.last_read,
    ta.last_write,
  
    -- column info
    c.column_count,
    c.column_list,
    c.has_identity_column,
    c.computed_column_count,
    c.persisted_computed_column_count,
    c.LOB_column_count,
    c.XML_column_count,
    c.spatial_column_count,
    c.hierarchyid_column_count,
    c.rowversion_column_count,
    c.GUID_column_count,
    c.deprecated_column_count,
    c.alias_type_count,
  
    -- index info
    i.has_clustered_index,
    i.has_primary_key,
    i.nonclustered_index_count,
    i.unique_index_count,
    i.filtered_index_count,
    i.xml_index_count,
    i.spatial_index_count,
  
    -- constraint info
    default_constraint_count = COALESCE(cc.default_constraint_count,0),
    check_constraint_count = COALESCE(cc.check_constraint_count,0),
  
    -- trigger info
    after_trigger_count = COALESCE(tr.after_trigger_count,0),
    instead_of_trigger_count = COALESCE(tr.instead_of_trigger_count,0),
  
    -- storage info
    st.[data_compression],
    st.has_partitions,
    st.partition_count,
  
    -- foreign key counts - inbound, outbound
    inbound_fk_count = COALESCE(fk.inbound_count,0),
    outbound_fk_count = COALESCE(fk.outbound_count,0),
  
    -- schema-bound references:
    schemabound_references = COALESCE(sb.reference_count,0)
  
  FROM tables AS t
  CROSS     APPLY tvf_spaceused(t.[object_id]) AS su
  LEFT OUTER JOIN table_access AS ta
  ON t.[object_id] = ta.[object_id]
  INNER JOIN columns AS c
  ON t.[object_id] = c.[object_id]
  LEFT OUTER JOIN indexes AS i
  ON t.[object_id] = i.[object_id]
  LEFT OUTER JOIN constraint_counts AS cc
  ON t.[object_id] = cc.[object_id]
  LEFT OUTER JOIN trigger_counts AS tr
  ON t.[object_id] = tr.[object_id]
  LEFT OUTER JOIN basic_storage AS st
  ON t.[object_id] = st.[object_id]
  LEFT OUTER JOIN foreign_key_counts AS fk
  ON t.[object_id] = fk.[object_id]
  LEFT OUTER JOIN schemabound_references AS sb
  ON t.[object_id] = sb.[object_id];