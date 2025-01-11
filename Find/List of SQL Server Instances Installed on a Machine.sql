DECLARE @GetInstances TABLE
( Value nvarchar(100),
InstanceNames nvarchar(100),
Data nvarchar(100))
Insert into @GetInstances
EXECUTE xp_regread
@rootkey = 'HKEY_LOCAL_MACHINE',
@key = 'SOFTWARE\Microsoft\Microsoft SQL Server',
@value_name = 'InstalledInstances'
Select InstanceNames from @GetInstances