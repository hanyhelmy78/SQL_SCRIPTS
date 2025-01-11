SELECT
     LogicalName = dbf.name
    ,FileType = dbf.type_desc
    ,FilegroupName = fg.name
    ,PhysicalFileLocation = dbf.physical_name
    ,FileSizeMB = CONVERT(DECIMAL(10,2),dbf.size/128.0)
    ,UsedSpaceMB = CONVERT(DECIMAL(10,2),dbf.size/128.0 - ((dbf.size/128.0)
               - CAST(FILEPROPERTY(dbf.name, 'SPACEUSED') AS INT) /128.0))
    ,FreeSpaceMB = CONVERT(DECIMAL(10,2),dbf.size/128.0
           - CAST(FILEPROPERTY(dbf.name, 'SPACEUSED') AS INT)/128.0)
FROM sys.database_files dbf
LEFT JOIN sys.filegroups fg ON dbf.data_space_id = fg.data_space_id
ORDER BY dbf.type DESC, dbf.name;