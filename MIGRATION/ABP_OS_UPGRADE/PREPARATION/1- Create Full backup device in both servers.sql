USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk',
@logicalname = N'_tape', @physicalname = N'\\_tape.bak'
GO
