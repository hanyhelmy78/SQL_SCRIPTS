DECLARE @ViewName varchar(250)
DECLARE @ForUser varchar(50)
DECLARE @GrantPermission varchar(25)
DECLARE @Query varchar(max)
DECLARE @Views CURSOR
DECLARE @HasPerm BIT

SET @GrantPermission = 'SELECT' --Provide the Permission Select alter control
SET @ForUser = 'USM_USER' --Provide for which User 

SET @Views = CURSOR FOR
SELECT name FROM sys.objects WHERE type = 'V' and is_ms_shipped = 0

OPEN @Views
FETCH NEXT
FROM @Views INTO @ViewName
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC AS USER = @ForUser
	SET @HasPerm = HAS_PERMS_BY_NAME(QUOTENAME('dbo') + '.' + QUOTENAME(@ViewName), 'OBJECT', @GrantPermission)
	REVERT
	IF @HasPerm = 0
	BEGIN
		SET @Query = 'GRANT ' + @GrantPermission + ' ON ' + @ViewName + ' TO ' + @ForUser
		--EXEC(@Query) -- Uncomment this Line to Execute the Permissions
		PRINT @Query
	END
	FETCH NEXT
	FROM @Views INTO @ViewName
END

CLOSE @Views
DEALLOCATE @Views