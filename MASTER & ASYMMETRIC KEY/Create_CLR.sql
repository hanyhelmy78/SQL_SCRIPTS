USE MASTER
GO

--Do not create asymmetric keys in system databases. Use 2048 bit and above to create asymmetric keys

CREATE ASYMMETRIC KEY KeyCLRFunc AUTHORIZATION dbo
    FROM FILE =  'C:\HisGenXUDT\CLR_Func.snk' 
    ENCRYPTION BY PASSWORD = 'His123456genx'
GO

CREATE LOGIN [HisGenxCLRFunc] FROM ASYMMETRIC KEY [KeyCLRFunc]   

GRANT EXTERNAL ACCESS ASSEMBLY TO [HisGenxCLRFunc] 

-- THIS IS 2 BE RUN WHEN DR SITE IS THE PRIMARY REPLICA (1st time only)

Use ABP_SFA_BMB
go
-- Create the assemblies from the ones we have built.
create assembly [CLR_FUNC] from 'C:\HisGenXUDT\CLR_FUNC.dll' with permission_set = External_Access 
create assembly [CLR_FUNC.XmlSerializers] from 'C:\HisGenXUDT\CLR_FUNC.XmlSerializers.dll' with permission_set = External_Access
go

-- Create the function that is to be used for getting the weather info.
CREATE FUNCTION [dbo].[fn_CLR_SendSMS](@URL [nvarchar](4000), @username [nvarchar](4000), @password [nvarchar](4000), @TagName [nvarchar](4000), @phoneNo [nvarchar](4000), @message [nvarchar](4000))
RETURNS [nvarchar](4000) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CLR_FUNC].[UserDefinedFunctions].[fn_CLR_SendSMS]
GO

GRANT EXEC ON [fn_CLR_SendSMS] TO HMGDBUSER

--select [dbo].[fn_CLR_SendSMS]('http://10.50.100.191/SMSWebService/SMSWebSErvice.asmx','HisGenX','123456','Dr.Alhabib','966545026800','Test SMS from DB 1')