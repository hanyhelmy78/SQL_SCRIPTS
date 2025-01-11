sp_dropremotelogin DEVSFADB
GO

sp_dropserver [WIN-6QV50K25A58]
GO
sp_addserver RUH1PRODTA, local
GO
--====================================
SELECT @@SERVERNAME AS 'Server Name'
sp_helpserver

sp_dropserver RUH1SERVICE
GO
sp_addserver 'RUH1SERVICE-T3', local
GO
--====================================
sp_dropserver RUH1ABCS
GO
sp_addserver RUH1ABCSTG, local
GO
--====================================
sp_dropserver RUH1ABCB
GO
sp_addserver RUH1ABCDB, local
GO
--====================================