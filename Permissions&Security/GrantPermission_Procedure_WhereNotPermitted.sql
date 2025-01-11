DECLARE @Procedures CURSOR
DECLARE @ProcedureName varchar(250)
DECLARE @ForUser varchar(250)
DECLARE @GrantPermission varchar(25)
DECLARE @Query varchar(max)
DECLARE @HasPerm bit

SET @GrantPermission = 'VIEW DEFINITION' --Provide the Permission VIEW DEFINITION
SET @ForUser = 'BMBBE' --Provide for which User

SET @Procedures = CURSOR FOR
SELECT name FROM sys.procedures where is_ms_shipped = 0 and name not like 'sp_%diagram%'

OPEN @Procedures
FETCH NEXT
FROM @Procedures INTO @ProcedureName
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC AS USER = @ForUser
	SET @HasPerm = HAS_PERMS_BY_NAME(QUOTENAME('dbo') + '.' + QUOTENAME(@ProcedureName), 
	'OBJECT', @GrantPermission)
	REVERT
	IF @HasPerm = 0
	BEGIN
		SET @Query = 'Grant ' + @GrantPermission + ' ON ' + @ProcedureName + ' To ' + @ForUser
		--EXEC(@Query) -- Uncomment this Line to Execute the Permissions
		PRINT @Query	
	END
FETCH NEXT
FROM @Procedures INTO @ProcedureName
END

CLOSE @Procedures
DEALLOCATE @Procedures 