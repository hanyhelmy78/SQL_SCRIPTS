USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk',
@logicalname = N'ABP_BMB_tape', @physicalname = N'\\RUH1SFAB\ABP_Backup\ABP_BMB_tape.bak'
GO

USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk',
@logicalname = N'ABP_SFA_BMB_tape', @physicalname = N'\\RUH1SFAB\ABP_Backup\ABP_SFA_BMB_tape.bak'
GO

USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk',
@logicalname = N'PEPSI_tape', @physicalname = N'\\RUH1SFAS\ABP_Backup\PEPSI_tape.bak'
GO