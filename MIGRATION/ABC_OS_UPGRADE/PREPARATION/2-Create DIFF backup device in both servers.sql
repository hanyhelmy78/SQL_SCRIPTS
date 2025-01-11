USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk',
@logicalname = N'', @physicalname = N'\\.trn'
GO
