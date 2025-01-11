/*get the current database name*/ 
DECLARE @DBName VARCHAR(500) 
SELECT @DBName = DB_NAME() 

/*set the tsql to be executed in a variable as it needs to be combined with the @DBName variable */ 
DECLARE @strSQL VARCHAR(200) 
SET @strSQL = 'SELECT COUNT(*) FROM [' + @DBName + '].sys.check_constraints WHERE is_not_trusted = 1' 

/*execute the tsql*/ 
EXEC (@strSQL) 

--Alert name: Untrusted check constraints
--This alert is raised when SQL Monitor detects check constraints that have their is_not_trusted flag set to 1 in the sys.check_constraints table. 
--Default threshold values: High: 0
--						    Medium: Disabled 
--						    Low: Disabled 