sp_dropremotelogin 
GO

sp_dropserver [WIN-6QV50K25A58]
GO
sp_addserver , local
GO
--====================================
SELECT @@SERVERNAME AS 'Server Name'
sp_helpserver

sp_dropserver 
GO
sp_addserver '-T3', local
GO
--====================================
sp_dropserver 
GO
sp_addserver , local
GO
--====================================
sp_dropserver 
GO
sp_addserver , local
GO
--====================================
