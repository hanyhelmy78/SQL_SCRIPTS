USE master; 
GO 
SELECT name, database_id, page_verify_option_desc 
FROM sys.databases 
WHERE page_verify_option <> 2
GO 
--Reset the option by running the following script:
USE master; 
GO 
--ALTER DATABASE [database_name] SET PAGE_VERIFY CHECKSUM; 
GO