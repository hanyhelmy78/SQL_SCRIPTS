USE [TEST_RESTORE_FG]
GO
ALTER DATABASE [TEST_RESTORE_FG] MODIFY FILE (NAME=N'StackOverflow2013_1', NEWNAME=N'TEST_RESTORE_FG_1')
GO
ALTER DATABASE [TEST_RESTORE_FG] MODIFY FILE (NAME=N'StackOverflow2013_2', NEWNAME=N'TEST_RESTORE_FG_2')
GO
ALTER DATABASE [TEST_RESTORE_FG] MODIFY FILE (NAME=N'StackOverflow2013_3', NEWNAME=N'TEST_RESTORE_FG_3')
GO
ALTER DATABASE [TEST_RESTORE_FG] MODIFY FILE (NAME=N'StackOverflow2013_4', NEWNAME=N'TEST_RESTORE_FG_4')
GO
ALTER DATABASE [TEST_RESTORE_FG] MODIFY FILE (NAME=N'StackOverflow2013_5', NEWNAME=N'TEST_RESTORE_FG_5')
GO
ALTER DATABASE [TEST_RESTORE_FG] MODIFY FILE (NAME=N'StackOverflow2013_6', NEWNAME=N'TEST_RESTORE_FG_6')
GO
ALTER DATABASE [TEST_RESTORE_FG] MODIFY FILE (NAME=N'Medium_StackOverflow2013_log', NEWNAME=N'TEST_RESTORE_FG_log')
GO