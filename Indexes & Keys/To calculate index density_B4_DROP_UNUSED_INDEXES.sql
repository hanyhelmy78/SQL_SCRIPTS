DBCC SHOW_STATISTICS(Movement_Details,[INDEX_MOVEMENT_CODE])

-- “All density” column should always be less than 0.1 (means index selectivity more than 90%)
-- these values are in exponential notation so 3.984854E-07 = 0.000003984854