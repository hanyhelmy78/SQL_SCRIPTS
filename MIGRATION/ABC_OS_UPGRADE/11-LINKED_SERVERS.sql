-- RUH1ABCDB
USE [master]
GO
/****** Object:  LinkedServer [PROD]    Script Date: 01/11/2016 10:45:28 ******/
EXEC master.dbo.sp_dropserver @server=N'PROD', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [PROD]    Script Date: 01/11/2016 10:45:28 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'PROD', @srvproduct=N'Oracle', @provider=N'OraOLEDB.Oracle', @datasrc=N'PROD'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'PROD',@useself=N'False',@locallogin=NULL,@rmtuser=N'APPS',@rmtpassword='########'

GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PROD', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
--==================================================================================================================
/****** Object:  LinkedServer [RUH1ABCS]    Script Date: 01/11/2016 10:50:41 ******/
EXEC master.dbo.sp_dropserver @server=N'RUH1ABCS', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [RUH1ABCSTG]    Script Date: 01/11/2016 10:50:41 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'RUH1ABCSTG', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RUH1ABCSTG',@useself=N'False',@locallogin=NULL,@rmtuser=N'sa',@rmtpassword='Pepsi-123'

GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCSTG', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
--=====================================================================================================================
-- RUH1ABCSTG
USE [master]
GO

/****** Object:  LinkedServer [RUH1ABCDB]    Script Date: 01/11/2016 10:55:21 ******/
EXEC master.dbo.sp_dropserver @server=N'RUH1ABCDB', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [RUH1ABCDB]    Script Date: 01/11/2016 10:55:02 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'RUH1ABCDB', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RUH1ABCDB',@useself=N'False',@locallogin=NULL,@rmtuser=N'sa',@rmtpassword='Pepsi-123'

GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'RUH1ABCDB', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO