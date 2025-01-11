SELECT DISTINCT 'Count' = COUNT(*),Type T, 'Type' = CASE type 
                WHEN 'C' THEN 'CHECK constraints' 
                WHEN 'D' THEN 'Default or DEFAULT constraints' 
                WHEN 'F' THEN 'FOREIGN KEY constraints' 
                WHEN 'FN' THEN 'Scalar functions' 
                WHEN 'IF' THEN 'Inlined table-functions' 
                WHEN 'K' THEN 'PRIMARY KEY or UNIQUE constraints' 
                WHEN 'L' THEN 'Logs' 
                WHEN 'P' THEN 'Stored procedures' 
                WHEN 'R' THEN 'Rules' 
                WHEN 'RF' THEN 'Replication filter stored procedures' 
                WHEN 'S' THEN 'System tables' 
                WHEN 'TF' THEN 'Table functions' 
                WHEN 'TR' THEN 'Triggers' 
                WHEN 'U' THEN 'User tables' 
                WHEN 'V' THEN 'Views' 
                WHEN 'X' THEN 'Extended stored procedures' 
				WHEN 'SQ' THEN 'Queue'
				WHEN 'TT' THEN 'Temp Table'
    END 
    FROM sysobjects 
    GROUP BY type
    ORDER BY type 
GO