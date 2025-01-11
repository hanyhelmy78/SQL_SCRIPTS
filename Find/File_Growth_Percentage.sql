    SELECT d.name as database_name,
        mf.name as file_name,
        mf.type_desc as file_type,
        mf.growth as current_percent_growth
    FROM sys.master_files mf (NOLOCK)
    JOIN sys.databases d (NOLOCK) on mf.database_id=d.database_id
    WHERE is_percent_growth=1
    GO