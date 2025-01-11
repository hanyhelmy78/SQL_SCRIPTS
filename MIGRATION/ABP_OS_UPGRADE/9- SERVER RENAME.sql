sp_dropremotelogin RUH1SFAB
GO

sp_dropserver [ruh1iSellR-ABP]
GO
sp_addserver ruh1iSellRABP, local
GO
--====================================
sp_dropserver RUH1SFAS
GO
sp_addserver RUH1SFASTG, local
GO
--====================================
SELECT @@SERVERNAME AS 'Server Name'
sp_helpserver

sp_dropserver RUH1ABCSTG
GO
sp_addserver RUH1ABCSTGOLD, local
GO
--====================================
sp_dropserver RUH1ABCB
GO
sp_addserver RUH1ABCDB, local
GO
--====================================