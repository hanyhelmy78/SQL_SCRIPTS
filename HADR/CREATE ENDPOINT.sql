USE [master]
GO

ALTER ENDPOINT [DBMirroring] 
	STATE=--STOPPED
	STARTED

--DROP ENDPOINT [DBMirroring] 
CREATE ENDPOINT [DBMirroring] 
	STATE=STARTED
	AS TCP (LISTENER_PORT = 5022, LISTENER_IP = ALL)
	FOR DATA_MIRRORING (ROLE = ALL, AUTHENTICATION = WINDOWS NEGOTIATE
, ENCRYPTION = REQUIRED ALGORITHM AES) 
GO

SELECT name, role_desc, state_desc FROM sys.database_mirroring_endpoints 
-- the login of each host computer account (DomainName\ComputerName$) must be created in master DB on each of the remote server instances and that login must be granted CONNECT permissions on the endpoint.

-- ON THE PRIMARY NODE RUN THIS:
CREATE LOGIN [<Secondary_node>$] FROM WINDOWS;
GRANT CONNECT ON ENDPOINT::Hadr_endpoint TO [<Secondary_node>$];
GRANT CONNECT TO [<Secondary_node>$];
/*
PLUS GRANT CONNECT ON ENDPOINT TO THE SERVICE ACCOUNT --> ON THE SECONDARY NODE ***
*/
GRANT CONNECT ON ENDPOINT::Hadr_endpoint TO [<Service_account>];
GRANT CONNECT TO [<Service_account>];

-- ON THE SECONDARY NODE RUN THIS:
CREATE LOGIN [<Primary_node>$] FROM WINDOWS;
GRANT CONNECT ON ENDPOINT::Hadr_endpoint TO [<Primary_node>$];
GRANT CONNECT TO [<Primary_node>$];