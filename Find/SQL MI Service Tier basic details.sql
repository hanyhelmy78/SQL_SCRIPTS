SELECT @@VERSION Version
/*
How-to ensure that Managed Instance is your engine
*/
IF( SERVERPROPERTY('EngineEdition') = 8 ) 
BEGIN
    PRINT 'This is an Azure SQL Managed Instance.';
END
ELSE
BEGIN
	PRINT 'This is NOT an Azure SQL Managed Instance.';
END
/*
How-to find out the Service Tier of your Managed Instance
*/
SELECT TOP 1 sku as ServiceTier
	FROM [sys].[server_resource_stats]
	ORDER BY end_time DESC;
/*
How-to find out used Hardware Generation
*/
SELECT TOP 1 hardware_generation as HardwareGeneration
	FROM [sys].[server_resource_stats]
	ORDER BY end_time DESC;