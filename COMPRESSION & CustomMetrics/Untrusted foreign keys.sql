/*get the current database name*/ 
DECLARE @DBName VARCHAR(500) 
SELECT @DBName = DB_NAME() 

/*set the tsql to be executed in a variable as it need to be combined with the @DBName variable */ 
DECLARE @strSQL VARCHAR(200) 
SET @strSQL = 'SELECT COUNT(*) FROM [' + @DBName + '].sys.foreign_keys WHERE is_not_trusted = 1' 

/*execute the tsql*/ 
EXEC (@strSQL) 

--Alert name: Untrusted foreign keys
--This alert is raised when the number of foreign keys detected exceeds the thresholds set. If foreign keys exist, find out which ones they are by running
--Default threshold values: High: 0 
--						    Medium: Disabled 
--						    Low: Disabled 
 --select * from sys.foreign_keys where is_not_trusted = 1