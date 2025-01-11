sp_dropremotelogin 
GO

sp_dropserver [WIN-6QV50K25A58]
GO
sp_addserver , local
GO
--====================================
SELECT @@SERVERNAME AS 'Server Name'
GO
sp_helpserver
