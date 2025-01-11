DECLARE @TableName varchar(250)
DECLARE @ForUser varchar(50)
DECLARE @GrantPermission varchar(25)
DECLARE @Query varchar(MAX)
DECLARE @Tables CURSOR
DECLARE @HasPerm BIT

SET @GrantPermission = 'SELECT' -- Provide the Permission
SET @ForUser = 'coreBio' -- Provide for which User
SET @Tables = CURSOR FOR
SELECT name FROM sys.tables WHERE is_ms_shipped = 0
OPEN @Tables
FETCH NEXT
FROM @Tables INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC AS USER = @ForUser
	SET @HasPerm = HAS_PERMS_BY_NAME(QUOTENAME('dbo') + '.' + QUOTENAME(@TableName), 'OBJECT', @GrantPermission)
	REVERT
	IF @HasPerm = 1 -- 0 FALSE DOESN`T HAVE PERMISSION, 1 HAS PERMISSION
	BEGIN
		SET @Query = 'Grant ' + @GrantPermission + ' ON ' + @TableName  + ' To ' + @ForUser
		--EXEC(@Query) -- Uncomment this Line to Execute Permissions		
		PRINT @Query
	END
	FETCH NEXT
	FROM @Tables INTO @TableName
END

CLOSE @Tables
DEALLOCATE @Tables