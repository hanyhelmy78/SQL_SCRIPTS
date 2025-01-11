USE master
GO
-- SELECT * FROM sys.master_files WHERE name LIKE 'TEMP%'

ALTER DATABASE [tempdb] MODIFY FILE (name = templog, FILENAME = 'T:\TEMP_DATA\templog.ldf')
ALTER DATABASE [tempdb] MODIFY FILE (name = tempdev, FILENAME = 'T:\TEMP_DATA\tempdb.mdf')
ALTER DATABASE [tempdb] MODIFY FILE (name = temp2, FILENAME = 'T:\TEMP_DATA\temp2.mdf')
ALTER DATABASE [tempdb] MODIFY FILE (name = temp3, FILENAME = 'T:\TEMP_DATA\temp3.mdf')
ALTER DATABASE [tempdb] MODIFY FILE (name = temp4, FILENAME = 'T:\TEMP_DATA\temp4.mdf')
ALTER DATABASE [tempdb] MODIFY FILE (name = temp5, FILENAME = 'T:\TEMP_DATA\temp5.mdf')
ALTER DATABASE [tempdb] MODIFY FILE (name = temp6, FILENAME = 'T:\TEMP_DATA\temp6.mdf')
ALTER DATABASE [tempdb] MODIFY FILE (name = temp7, FILENAME = 'T:\TEMP_DATA\temp7.mdf')
ALTER DATABASE [tempdb] MODIFY FILE (name = temp8, FILENAME = 'T:\TEMP_DATA\temp8.mdf')
GO