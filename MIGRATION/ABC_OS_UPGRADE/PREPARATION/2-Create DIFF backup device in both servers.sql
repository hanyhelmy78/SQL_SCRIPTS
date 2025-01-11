USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk',
@logicalname = N'ABP_BMB', @physicalname = N'\\RUH1ABCB\ACB_Backup\ABP_BMB.trn'
GO

USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk',
@logicalname = N'ABP_SFA_BMB', @physicalname = N'\\RUH1ABCB\ACB_Backup\ABP_SFA_BMB.trn'
GO

USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk',
@logicalname = N'PEPSI', @physicalname = N'\\RUH1ABCS\ACB_Backup\PEPSI.trn'
GO