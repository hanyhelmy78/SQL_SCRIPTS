DECLARE @FunctionName varchar(250)
DECLARE @ForUser varchar(50)
DECLARE @GrantPermission varchar(25)
DECLARE @Query varchar(max)
DECLARE @Functions CURSOR
DECLARE @HasPerm BIT

SET @GrantPermission = 'EXEC' --Provide the Permission alter Control
SET @ForUser = 'EAI_USER' --Provide for which User  pharmauser HmgDbReader

SET @Functions = CURSOR FOR
SELECT name FROM sys.objects WHERE type = 'FN' and is_ms_shipped = 0

OPEN @Functions
FETCH NEXT
FROM @Functions INTO @FunctionName
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC AS USER = @ForUser
	SET @HasPerm = HAS_PERMS_BY_NAME(QUOTENAME('dbo') + '.' + QUOTENAME(@FunctionName), 'OBJECT', @GrantPermission)
	REVERT
	IF @HasPerm = 1
	BEGIN
		SET @Query = 'Grant ' + @GrantPermission + ' ON ' + @FunctionName + ' To ' + @ForUser
		--EXEC(@Query) -- Uncomment this Line to Execute the Permissions
		PRINT @Query
	END
	FETCH NEXT
	FROM @Functions INTO @FunctionName
END

CLOSE @Functions
DEALLOCATE @Functions