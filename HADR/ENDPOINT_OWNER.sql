USE master;
SELECT 
 SUSER_NAME(principal_id) AS endpoint_owner,name AS endpoint_name
FROM sys.database_mirroring_endpoints;

/*  
GRANT CONNECT ON ENDPOINT::Hadr_endpoint TO [Your_Service_Account]
ALTER AUTHORIZATION ON ENDPOINT::Hadr_endpoint TO sa;
*/