-- old and deprecated sp_attach_single_file_db
USE master 
GO 

EXEC sys.sp_attach_single_file_db @dbname = 'TestDB', 
    @physname = N'E:\MSSQL\TestDBCopy.mdf' 
GO

CREATE DATABASE [TestDB] ON 
(FILENAME = N'E:\MSSQL\TestDBCopy.mdf')
FOR ATTACH_REBUILD_LOG 
GO