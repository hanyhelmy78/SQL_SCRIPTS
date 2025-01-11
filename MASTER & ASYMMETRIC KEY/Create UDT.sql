USE HISGENX
GO
DROP TYPE dbo.TimeSpanEx
DROP Assembly HisGenXUDT
GO
Use master
GO
DROP LOGIN HisGenXUser
GO
DROP ASYMMETRIC KEY kyHisGenXUDT
GO

--Do not create asymmetric keys in system databases. Use 2048 bit and above to create asymmetric keys

CREATE ASYMMETRIC KEY kyHisGenXUDT AUTHORIZATION dbo
    FROM FILE =  'C:\HisGenXUDT\kyHisGenXUDT.snk' 
    --ENCRYPTION BY PASSWORD = '$^@@@@$,hmc';
    ENCRYPTION BY PASSWORD = 's#64DxB!eS';
GO

ALTER ASYMMETRIC KEY [kyHisGenXUDT] REMOVE PRIVATE KEY

CREATE LOGIN [HisGenXUser] FROM ASYMMETRIC KEY [kyHisGenXUDT]   
GRANT UNSAFE ASSEMBLY TO [HisGenXUser] 

-- THIS IS 2 BE RUN WHEN DR SITE IS THE PRIMARY REPLICA

Use HISGENX
go
CREATE Assembly HisGenXUDT From 'C:\HisGenXUDT\HisGenXUDT.dll' WITH PERMISSION_SET = UNSAFE;

CREATE TYPE dbo.TimeSpanEx EXTERNAL NAME HisGenXUDT.[TimeSpanEx];