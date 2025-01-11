SELECT c.name AS [Column]
     , t.name AS [Data Type]
     , c.collation_name
  FROM Dental4U.sys.columns AS c
          INNER JOIN HISGENX.sys.types AS t ON t.system_type_id = c.system_type_id
 WHERE object_id = object_id('Dental4U..address_oltp')
 ORDER BY c.column_id;