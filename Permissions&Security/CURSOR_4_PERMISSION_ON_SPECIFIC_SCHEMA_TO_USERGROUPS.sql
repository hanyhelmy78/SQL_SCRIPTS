DECLARE @Query NVARCHAR(2000)
DECLARE @tableName NVARCHAR(200)
DECLARE cursed CURSOR FOR
SELECT t.name
FROM sys.tables t 
            INNER JOIN sys.schemas s on t.schema_id = s.schema_id
            WHERE s.name = 'demo' -- CHANGE THE SCHEMA NAME
            and t.name like 'T%' -- CHANGE THE TABLE ALIAS
 
OPEN cursed
FETCH NEXT FROM cursed into @tableName
WHILE @@FETCH_STATUS = 0
BEGIN
 
    SET @Query =  'GRANT SELECT ON demo.' + @tableName + ' TO USERGROUP;'
 
    print @query
    -- EXEC sp_executesql @query;
 
    FETCH NEXT FROM cursed INTO @tableName
 
END
CLOSE cursed
DEALLOCATE cursed