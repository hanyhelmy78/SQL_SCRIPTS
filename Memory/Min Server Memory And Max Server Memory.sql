SELECT
    x.name, 
    x.value_gb, 
    x.value_in_use_gb, 
    x.total_physical_memory_gb,
    percent_of_total_memory = 
        (x.value_in_use_gb / x.total_physical_memory_gb) * 100
FROM 
    (
    SELECT
        c.name,
        value_gb = 
            CONVERT
            (
                bigint,
                c.value
            ) / 1024,
        value_in_use_gb = 
            CONVERT
            (
                bigint,
                c.value_in_use
            ) / 1024,
        dosm.total_physical_memory_gb     
    FROM sys.configurations AS c
    CROSS JOIN
    (
        SELECT 
            total_physical_memory_gb = 
                CEILING
                (
                    dosm.total_physical_memory_kb / 1024. / 1024.
                )
        FROM sys.dm_os_sys_memory AS dosm
    ) dosm
    WHERE c.name IN 
    (
        N'min server memory (MB)',
        N'max server memory (MB)'
    )
) AS x;