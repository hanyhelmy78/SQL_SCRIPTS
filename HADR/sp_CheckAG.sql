IF OBJECT_ID('dbo.sp_CheckAG') IS NULL
  EXEC ('CREATE PROCEDURE dbo.sp_CheckAG AS RETURN 0;');
GO
ALTER PROCEDURE dbo.sp_CheckAG
	  @Mode TINYINT = 99
	, @AGName NVARCHAR(128) = NULL
	, @LocalOnly BIT = NULL
	, @Help BIT = 0
	, @VersionCheck BIT = 0
WITH RECOMPILE
AS
SET NOCOUNT ON;

DECLARE 
    @Version VARCHAR(10) = NULL
	, @VersionDate DATETIME = NULL

SELECT
    @Version = '1.1'
    , @VersionDate = '20260112';

/* Version check */
IF @VersionCheck = 1 BEGIN
	SELECT
		@Version AS VersionNumber
		, @VersionDate AS VersionDate
	RETURN;
	END;  

/* @Help = 1 */
IF @Help = 1 BEGIN
	PRINT '
/*
    sp_CheckAG from https://straightpathsql.com/

	Version: ' + @Version + ' updated ' + CONVERT(VARCHAR(10), @VersionDate, 101) + '
    	
    This stored procedure checks your availabilty group(s) for all kinds of issues 
	and  provides a list of findings with action items. It also can be used to 
	provide a comprehensive set of information about your availabilty group(s).
    
    Known limitations of this version:
    - sp_CheckAG only works Microsoft-supported versions of SQL Server, so 
    that means SQL Server 2016 or later.
    - sp_CheckAG might work with some earlier versions of SQL Server, but it 
    will skip a few checks. The results should still be valid and helpful, but you
    should really consider upgrading to a newer supported version.
    
    Parameters:

    @Mode  0 = Show only problematic issues, unfiltered
           1 = Show availability group information only
		   2 = Show availability group history of events 
		   99 = Show availability group information and problematic issues (default)
    @AGName  use to provide info on a specific availability group
		(...because @AvailabilityGroupName would be too long to type)
	@LocalOnly use to reduce results for only local replicas and databases
	@VersionCheck use to check version number and date

For Mode 1 and 99, the following result sets will be displayed
	- Server and instance
	- Cluster
	- Cluster members
	- Endpoint
	- Availability group
	- Listener
	- Availability group replicas
	- Availability group databases
*/';
	RETURN;
	END;  
/*
Let's begin
*/

DECLARE 
	@SQL NVARCHAR(4000)
    , @SQLParameters NVARCHAR(500)
	, @SQLVersion NVARCHAR(128)
	, @SQLVersionMajor DECIMAL(10,2)
	, @SQLVersionMinor DECIMAL(10,2)
	, @ComputerNamePhysicalNetBIOS NVARCHAR(128)
	, @ServerZeroName SYSNAME
	, @InstanceName NVARCHAR(128)

	, @ClusterName NVARCHAR(128)
	, @QuorumType VARCHAR(50)
	, @QuorumState VARCHAR(50)

	, @DatabaseID INT
	, @Edition NVARCHAR(128)
    , @physical_memory_in_MB numeric(18,0)
	, @MinMemoryMB NUMERIC(18,0)
	, @MaxMemoryMB NUMERIC(18,0)
	, @NumberOfDataFiles INT
    , @NumberOfCPUCores INT
    , @NumberOfCPUSockets INT
	, @NumberOfDrivesOtherThanC INT
	, @DefaultDataPath NVARCHAR(4000)
	, @DefaultLogPath NVARCHAR(4000)
	, @DefaultBackupPath NVARCHAR(4000)
	, @PowerPlan VARCHAR(36)
	, @NumberOfErrorLogs INT
	, @UsagePercent TINYINT = 50
	, @AvgReadStallMs INT = 20
	, @AvgWriteStallMs INT = 20;

DECLARE @ServerType NVARCHAR(1000);

DECLARE @ServerTypeText TABLE (
	LogDate DATETIME
	, ProcessInfo NVARCHAR(100)
	, LogText NVARCHAR(1000)
	);

DECLARE @OperatingSystem NVARCHAR(1000)

DECLARE @OperatingSystemText TABLE (
	LogDate DATETIME
	, ProcessInfo NVARCHAR(100)
	, LogText NVARCHAR(1000)
	);

IF OBJECT_ID('tempdb..#Category') IS NOT NULL
	DROP TABLE #Category;

CREATE TABLE #Category (
    CategoryID TINYINT
	, CategoryName VARCHAR(50)
	);

INSERT #Category (CategoryID, CategoryName)
VALUES
    (1, 'Discovery')
    , (2, 'Recoverability')
    , (3, 'Security')
    , (4, 'Availability')
    , (5, 'Integrity')
    , (6, 'Reliability')
    , (7, 'Performance')
    , (8, 'Troubleshooting');

IF OBJECT_ID('tempdb..#Results') IS NOT NULL
	DROP TABLE #Results;

CREATE TABLE #Results (
	CategoryID TINYINT
	, CheckID INT
	, Importance TINYINT
	, CheckName VARCHAR(50)
	, Issue NVARCHAR(1000)
	, DatabaseName NVARCHAR(255)
	, Details NVARCHAR(1000)
	, ActionStep NVARCHAR(1000)
	, ReadMoreURL XML
	);

IF OBJECT_ID('tempdb..#SQLVersions') IS NOT NULL
	DROP TABLE #SQLVersions;

CREATE TABLE #SQLVersions (
	VersionName VARCHAR(10)
	, VersionNumber DECIMAL(10,2)
	);

INSERT #SQLVersions
VALUES
	('2008', 10)
	, ('2008 R2', 10.5)
	, ('2012', 11)
	, ('2014', 12)
	, ('2016', 13)
	, ('2017', 14)
	, ('2019', 15)
	, ('2022', 16);

/* SQL Server version */
SELECT @SQLVersion = CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(128));

SELECT 
	@SQLVersionMajor = SUBSTRING(@SQLVersion, 1,CHARINDEX('.', @SQLVersion) + 1 )
	, @SQLVersionMinor = PARSENAME(CONVERT(varchar(32), @SQLVersion), 2);

/* check for unsupported version */	
IF @SQLVersionMajor < 11 BEGIN
	PRINT '
/*
	*** Unsupported SQL Server Version ***

	sp_CheckAG is supported only for execution on SQL Server 2012 and later.

	For more information about the limitations of sp_CheckAG, execute
	using @Help = 1

	*** EXECUTION ABORTED ***
    	   
*/';
	RETURN;
	END; 


/* check for availability groups */	
IF (SELECT COUNT(*) FROM sys.availability_groups) = 0 BEGIN
	PRINT '
/*
	*** No Availability Groups ***

	Nothing to see here. This instance has no availability groups.

	For more information about the limitations of sp_CheckAG, execute
	using @Help = 1

	*** EXECUTION ABORTED ***
    	   
*/';
	RETURN;
	END; 

SELECT 
	@NumberOfCPUCores = cpu_count
	, @NumberOfCPUSockets = (cpu_count/hyperthread_ratio)
FROM sys.dm_os_sys_info;

SELECT
	@ComputerNamePhysicalNetBIOS = CAST(SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS NVARCHAR(128))
	, @InstanceName = CAST(SERVERPROPERTY('InstanceName') AS NVARCHAR(128))
	, @Edition = CAST(SERVERPROPERTY('Edition') AS NVARCHAR(128));

SELECT @ServerZeroName = [name]
FROM sys.servers
WHERE server_id = 0


/* trace flags in use globally */
IF OBJECT_ID('tempdb..#TraceFlag') IS NOT NULL
	DROP TABLE #TraceFlag;

CREATE TABLE #TraceFlag
	(
		TraceFlag VARCHAR(10) ,
		Status BIT ,
		Global BIT ,
		Session BIT
	);

INSERT #TraceFlag
EXEC ('DBCC TRACESTATUS(-1) WITH NO_INFOMSGS');


/*
Server and Instance info
*/
	/* server name */
	INSERT #Results
	SELECT 
		1
		, 101
		, 0
		, 'Server Name'
		, 'Server Name'
		, NULL
		, COALESCE(@ComputerNamePhysicalNetBIOS,'')
		, NULL
		, '';

	/* instance name */
	INSERT #Results
	SELECT
		 1
		, 102
		, 0
		, 'Instance Name'
		, 'Instance Name'
		, NULL
		, COALESCE(@InstanceName, '(default instance)')
		, NULL
		, '';

	/* instance version */
	INSERT #Results
	SELECT 
		 1
		, 103
		, 0
		, 'Instance Version'
		, 'Instance Version'
		, NULL
		, 'SQL Server ' + VersionName
		, NULL
		, ''
	FROM #SQLVersions
	WHERE VersionNumber = @SQLVersionMajor;

	/* instance edition */
	INSERT #Results
	SELECT 
		 1
		, 104
		, 0
		, 'Instance Edition'
		, 'Instance Edition'
		, NULL
		, @Edition
		, NULL
		, '';

	/* instance build */
	INSERT #Results
	SELECT 
		 1
		, 105
		, 0
		, 'Instance Build'
		, 'Instance Build'
		, NULL
		, @SQLVersion
		, NULL
		, '';


	INSERT #Results
	SELECT 
		 1
		, 110
		, 0
		, 'Trace Flag In Use'
		, 'Trace Flag ' + TraceFlag ' is enabled globally'
		, NULL
		, CASE TraceFlag
			WHEN '1117' THEN '1117 enables all files in a filegroup to grow at the same time.'
			WHEN '1118' THEN '1118 avoids the use of mixed extents so each object has its own 64 KB data space.'
			WHEN '2371' THEN '2371 lowers the auto update statistics threshold for large tables.'
			WHEN '3226' THEN '3226 suppresses successful backup messages from the error log.'
			WHEN '7745' THEN '7745 prevents Query Store data from being written to disk during failover or shutdown.'
			WHEN '7752' THEN '7752 enables asynchronous loading of Query Store data.'
			ELSE 'Look up this trace flag.'
			END
		, NULL
		, ''
	FROM #TraceFlag;

	/* communication protocol */
	INSERT #Results
	SELECT 
		 1
		, 111
		, 0
		, 'Communication Protocol'
		, 'Communication Protocol'
		, NULL
		, CONVERT(VARCHAR(20),CONNECTIONPROPERTY('net_transport')) + CASE
			WHEN CONVERT(VARCHAR(10),CONNECTIONPROPERTY('net_transport')) = 'TCP' THEN ' on port ' + CONVERT(VARCHAR(10),CONNECTIONPROPERTY('local_tcp_port')) 
			ELSE '' END
		, NULL
		, '';

	/* CPU configuration */
	INSERT #Results
	SELECT 
		 1
		, 113
		, 0
		, 'CPU Configuration'
		, 'CPU Configuration'
		, NULL
		, CONVERT(VARCHAR(4), cpu_count) + ' core(s) across ' + CONVERT(VARCHAR(4), (cpu_count/hyperthread_ratio)) + ' NUMA node(s)'
		, NULL
		, ''
	 FROM sys.dm_os_sys_info;
 
	/* server memory */
	IF @SQLVersionMajor < 11.0 BEGIN
		SET @SQL = 'SELECT @physical_memory_in_MB_out = (SELECT physical_memory_in_bytes/(1024 * 1024) FROM sys.dm_os_sys_info)';

		SET @SQLParameters = '@physical_memory_in_MB_out NUMERIC(18,0) OUTPUT'
	
		EXEC sp_executesql @SQL, @SQLParameters, @physical_memory_in_MB_out = @physical_memory_in_MB OUTPUT

		END

	IF @SQLVersionMajor >= 11.0 BEGIN
		SET @SQL = 'SELECT @physical_memory_in_MB_out = (SELECT physical_memory_kb/1024 FROM sys.dm_os_sys_info)';

		SET @SQLParameters = '@physical_memory_in_MB_out NUMERIC(18,0) OUTPUT'
	
		EXEC sp_executesql @SQL, @SQLParameters, @physical_memory_in_MB_out = @physical_memory_in_MB OUTPUT

		END

	INSERT #Results
	SELECT 
		 1
		, 114
		, 0
		, 'Server Memory in MB'
		, 'Server Memory in MB'
		, NULL
		, @physical_memory_in_MB
		, NULL
		, '';

	/* operating system */
	INSERT @OperatingSystemText
	EXEC sp_readerrorlog 0, 1, 'Copyright';

	SELECT @OperatingSystem = SUBSTRING (LogText, CHARINDEX ('Windows', LogText), LEN(LogText))
	FROM @OperatingSystemText

	INSERT #Results
	SELECT 
		 1
		, 115
		, 0
		, 'Operating System'
		, 'Operating System'
		, NULL
		, @OperatingSystem
		, NULL
		, ''

	/* SQL Server service account */
	INSERT #Results
	SELECT 
		 1
		, 116
		, 0
		, 'SQL Server Service Account'
		, 'SQL Server Service Account'
		, NULL
		, service_account
		, NULL
		, ''
	FROM sys.dm_server_services 
	WHERE servicename like 'SQL Server (%';
	/* IP address */
	INSERT #Results
	SELECT 
		1
		, 119
		, 0
		, 'IP address'
		, 'IP address'
		, NULL
		, COALESCE(CONVERT(VARCHAR(15), CONNECTIONPROPERTY('local_net_address')), 'UNKNOWN')
		, ''
		, '';

	/* server info */
	INSERT @ServerTypeText
	EXEC sp_readerrorlog 0, 1, 'System Manufacturer:';

	SELECT @ServerType = REPLACE(REPLACE(REPLACE(LogText, 'System Manufacturer: ''', ''), ''', System Model: ''',': '), '''.', '')
	FROM @ServerTypeText

	INSERT #Results
	SELECT 
		 1
		, 120
		, 0
		, 'Server Type'
		, 'Server Type'
		, NULL
		, @ServerType
		, NULL
		, ''

		--END;


	/*
	Is service account in sysadmin role
	*/
	INSERT #Results
	SELECT 
		1
		, 199
		, 0
		, 'Is sysadmin'
		, 'Is sysadmin'
		, NULL
		, CASE IS_SRVROLEMEMBER ('sysadmin',service_account)
			WHEN 1 THEN 'Yes'
			ELSE 'NO' END
		, NULL
		, ''
	FROM sys.dm_server_services 
	WHERE servicename like 'SQL Server (%';

/*
Cluster info
*/
SELECT 
	@ClusterName = cluster_name 
	, @QuorumType = REPLACE(quorum_type_desc, '_',' ')
	, @QuorumState = REPLACE(quorum_state_desc, '_',' ')
FROM master.sys.dm_hadr_cluster;

/*
Cluster members
*/
IF OBJECT_ID('tempdb..#ClusterMembers') IS NOT NULL
	DROP TABLE #ClusterMembers;

CREATE TABLE #ClusterMembers (
	MemberName NVARCHAR(128)
	, MemberType NVARCHAR(50)
	, MemberState NVARCHAR(60)
	, NumberOfQuorumVotes TINYINT
	);

INSERT #ClusterMembers
SELECT
	member_name
	, REPLACE(member_type_desc, '_',' ')
	, REPLACE(member_state_desc, '_',' ')
	, number_of_quorum_votes
FROM sys.dm_hadr_cluster_members;


/*
Endpoints
*/

IF OBJECT_ID('tempdb..#Endpoints') IS NOT NULL
	DROP TABLE #Endpoints;

CREATE TABLE #Endpoints (
	EndpointName NVARCHAR(128)
	, EndpointOwner NVARCHAR(128)
	, EndpointState NVARCHAR(60)
	, AuthenticationType NVARCHAR(60)
	, CertificateName NVARCHAR(128)
	, CertificateExpiration DATETIME
	);

INSERT #Endpoints
SELECT
	e.[name] -- as EndpointName,
	, sp.[name] -- AS EndpointOwner,
	, REPLACE(e.state_desc, '_',' ')
	, dme.connection_auth_desc
	, COALESCE(c.name, '(Windows Authentication)')
	, c.expiry_date
FROM master.sys.endpoints e
INNER JOIN sys.server_principals sp
	ON e.principal_id = sp.principal_id
INNER JOIN sys.database_mirroring_endpoints dme
	ON e.endpoint_id = dme.endpoint_id
LEFT JOIN sys.certificates c
	ON dme.certificate_id = c.certificate_id
WHERE e.[type] = 4; /*Database Mirroring*/


/*
Availability Group info
*/

--select * FROM sys.availability_groups
--select * FROM sys.availability_replicas
--select * FROM sys.dm_hadr_availability_replica_cluster_states
--select * FROM sys.dm_hadr_availability_replica_states

IF OBJECT_ID('tempdb..#AvailabilityGroups') IS NOT NULL
	DROP TABLE #AvailabilityGroups;

CREATE TABLE #AvailabilityGroups (
	AGGroupID UNIQUEIDENTIFIER
	, AGName NVARCHAR(128)
	, CurrentRole NVARCHAR(128)
	, AGOwner NVARCHAR(128)
	, BackupPreference NVARCHAR(60)
	, ClusterType NVARCHAR(60)
	, IsContained VARCHAR(3)
	, DatabaseLevelHealthDetection VARCHAR(3)
	, DTCSupport VARCHAR(3)
	, ReadOnlyRoutingEnabled VARCHAR(3)
	, HealthCheckTimeout INT
	);

INSERT #AvailabilityGroups
SELECT
	ag.group_id
	, ag.[name] AS AGName
	, ars.role_desc AS CurrentRole
	, p.[name] AS AGOwner
	, UPPER(ag.automated_backup_preference_desc) AS BackupPreference
	, 'WSFC' AS ClusterType
	, 'No' AS IsContained
	, 'No' AS DatabaseLevelHealthDetection
	, 'No' AS DTCSupport
	, CASE 
		WHEN r.read_only_routing_url IS NULL THEN 'No'
		ELSE 'Yes' END AS ReadOnlyRoutingEnabled
	, ag.health_check_timeout
FROM sys.availability_groups ag 
INNER JOIN sys.availability_replicas r
	ON ag.group_id = r.group_id
INNER JOIN sys.server_principals p
	ON r.owner_sid = p.[sid]
INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS rcs
   ON ag.group_id = rcs.group_id
INNER JOIN sys.dm_hadr_availability_replica_states AS ars
   ON rcs.replica_id = ars.replica_id
   AND ars.is_local = 1
WHERE ag.[name] = COALESCE(@AGName, ag.[name]);

IF @SQLVersionMajor >= 14 BEGIN
	UPDATE agx
	SET agx.ClusterType = 'External'
	FROM #AvailabilityGroups agx
	INNER JOIN sys.availability_groups ag
		ON agx.AGGroupID = group_id
		AND ag.cluster_type = 2;

	UPDATE agx
	SET agx.DTCSupport = 'Yes'
	FROM #AvailabilityGroups agx
	INNER JOIN sys.availability_groups ag
		ON agx.AGGroupID = group_id
		AND ag.dtc_support = 1;
	END;

IF @SQLVersionMajor >= 15
	UPDATE agx
	SET agx.IsContained = 'Yes'
	FROM #AvailabilityGroups agx
	INNER JOIN sys.availability_groups ag
		ON agx.AGGroupID = group_id
		AND ag.is_contained = 1;
		
/*
Listener info
*/
/*
select * from sys.availability_group_listeners
select * from sys.availability_group_listener_ip_addresses
*/

IF OBJECT_ID('tempdb..#Listeners') IS NOT NULL
	DROP TABLE #Listeners;

CREATE TABLE #Listeners (
	GroupID UNIQUEIDENTIFIER
	, ListenerID UNIQUEIDENTIFIER
	, ListenerNameDNS NVARCHAR(63)
	, ListenerPort INT
	, ListenerIP NVARCHAR(48)
	, ListenerSubnetIP NVARCHAR(20)
	, ListenerIPState NVARCHAR(60)
	, AGName NVARCHAR(128)
	);

INSERT #Listeners
SELECT
	agl.group_id
	, agl.listener_id
	, agl.dns_name AS ListenerNameDNS
	, agl.port AS ListenerPort
	, lip.ip_address AS ListenerIP
	, CAST(lip.network_subnet_ip AS VARCHAR(15)) + '/' + CAST (lip.network_subnet_prefix_length AS VARCHAR(5)) AS ListenerSubnetIP
	, lip.state_desc AS ListenerIPState
	, ag.[name] AS AGName
FROM sys.availability_groups ag
INNER JOIN sys.availability_group_listeners agl
	ON ag.group_id = agl.group_id
INNER JOIN sys.availability_group_listener_ip_addresses lip
	ON agl.listener_id = lip.listener_id
WHERE ag.[name] = COALESCE(@AGName, ag.[name])
ORDER BY
	AGName
	, ListenerNameDNS
	, ListenerIP;


/*
Replica info
*/
/*
select * FROM sys.availability_groups
select * FROM sys.availability_replicas
select * FROM sys.dm_hadr_availability_replica_cluster_states
select * FROM sys.dm_hadr_availability_replica_states
*/

IF OBJECT_ID('tempdb..#Replicas') IS NOT NULL
	DROP TABLE #Replicas;

CREATE TABLE #Replicas (
	GroupID UNIQUEIDENTIFIER
	, ReplicaID UNIQUEIDENTIFIER
	, AGName NVARCHAR(128)
	, ServerInstance NVARCHAR(256)
	, CurrentRole NVARCHAR(60)
	, AvailabilityMode NVARCHAR(60)
	, FailoverMode NVARCHAR(60)
	, PrimaryAllowConnections NVARCHAR(60)
	, SecondaryAllowConnections NVARCHAR(60)
	, SeedingMode NVARCHAR(60)
	, SessionTimeout INT
	, EndPointURL NVARCHAR(128)
	);

INSERT #Replicas
SELECT
	ar.group_id
	, ar.replica_id
	, ag.[Name]
	, ar.replica_server_name AS ServerInstance
	, ars.role_desc AS CurrentRole
	, REPLACE(ar.availability_mode_desc, '_',' ') AS AvailabilityMode
	, ar.failover_mode_desc
	, ar.primary_role_allow_connections_desc AS PrimaryAllowConnections
	, ar.secondary_role_allow_connections_desc AS SecondaryAllowConnections
	--, r.seeding_mode_desc AS SeedingMode
	, 'MANUAL' AS SeedingMode
	, ar.[session_timeout] AS SessionTimeout
	, ar.[endpoint_url] AS EndPointURL
FROM sys.availability_groups ag 
INNER JOIN sys.availability_replicas ar
	ON ag.group_id = ar.group_id
INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS arcs
   ON ag.group_id = arcs.group_id
   AND ar.replica_id = arcs.replica_id
INNER JOIN sys.dm_hadr_availability_replica_states AS ars
   ON arcs.replica_id = ars.replica_id
   AND ars.is_local = COALESCE(@LocalOnly, ars.is_local)
WHERE ag.[name] = COALESCE(@AGName, ag.[name]);

IF @SQLVersionMajor >= 13
	UPDATE rx
	SET rx.SeedingMode = 'AUTOMATIC'
	FROM #Replicas rx
	INNER JOIN sys.availability_replicas r
		ON rx.ReplicaID = r.replica_id
		AND r.seeding_mode = 0;

/*
Database info
*/

IF OBJECT_ID('tempdb..#Databases') IS NOT NULL
	DROP TABLE #Databases;

CREATE TABLE #Databases (
	GroupID UNIQUEIDENTIFIER
	, ReplicaID UNIQUEIDENTIFIER
	, DatabaseName NVARCHAR(256)
	, DatabaseState NVARCHAR(60)
	, AGName NVARCHAR(128)
	, ServerInstance NVARCHAR(256)
	, SynchronizationState NVARCHAR(60)
	, CurrentRole NVARCHAR(60)
	, IsLocal NVARCHAR(3)
	, IsJoined NVARCHAR(3)
	, IsSuspended NVARCHAR(3)
	, IsFailoverReady NVARCHAR(3)
	, DatabaseOwner NVARCHAR(256)
	, SecondaryLagInSeconds BIGINT
	);

INSERT #Databases
SELECT
	ag.group_id
	, ar.replica_id
	, dbcs.[database_name] AS DatabaseName
	--ISNULL(agstates.primary_replica, '') AS [PrimaryReplicaServerName],
	--ISNULL(arstates.role, 3) AS [LocalReplicaRole],
	, ISNULL(dbrs.database_state_desc, 'UNKNOWN') AS DatabaseState
	, ag.name AS AGName
	, ar.replica_server_name
	, ISNULL(dbrs.synchronization_state_desc, 'NOT SYNCHRONIZING') AS SynchronizationState
	, CASE dbrs.is_primary_replica
		WHEN 1 THEN 'PRIMARY'
		ELSE 'SECONDARY' END AS CurrentRole
	, CASE ars.is_local
		WHEN 1 THEN 'Yes'
		ELSE 'No' END AS IsLocal
	, CASE dbcs.is_database_joined
		WHEN 1 THEN 'Yes'
		ELSE 'No' END AS IsJoined
	, CASE dbrs.is_suspended
		WHEN 1 THEN 'Yes'
		ELSE 'No' END AS IsSuspended
	, CASE dbcs.is_failover_ready
		WHEN 1 THEN 'Yes'
		ELSE 'No' END AS IsFailoverReady
	, SUSER_SNAME(owner_sid) AS DatabaseOwner
	, NULL 
FROM master.sys.availability_groups AS ag
LEFT OUTER JOIN master.sys.dm_hadr_availability_group_states as ags
	ON ag.group_id = ags.group_id
INNER JOIN master.sys.availability_replicas AS ar
	ON ag.group_id = ar.group_id
INNER JOIN master.sys.dm_hadr_availability_replica_states AS ars
	ON ar.replica_id = ars.replica_id 
   AND ars.is_local = COALESCE(@LocalOnly, ars.is_local)
INNER JOIN master.sys.dm_hadr_database_replica_cluster_states AS dbcs
	ON ars.replica_id = dbcs.replica_id
LEFT JOIN master.sys.dm_hadr_database_replica_states AS dbrs
	ON dbcs.replica_id = dbrs.replica_id AND dbcs.group_database_id = dbrs.group_database_id
WHERE ag.[name] = COALESCE(@AGName, ag.[name]);


IF @SQLVersionMajor >= 13
	UPDATE dx
	SET dx.SecondaryLagInSeconds = dbrs.secondary_lag_seconds
	FROM #Databases dx
	INNER JOIN master.sys.dm_hadr_database_replica_cluster_states AS dbcs
		ON dx.ReplicaID = dbcs.replica_id
	LEFT JOIN master.sys.dm_hadr_database_replica_states AS dbrs
		ON dbcs.replica_id = dbrs.replica_id AND dbcs.group_database_id = dbrs.group_database_id;

/* 
Trace flags in use globally 
*/
IF OBJECT_ID('tempdb..#TraceFlags') IS NOT NULL
	DROP TABLE #TraceFlags;

CREATE TABLE #TraceFlags
	(
		TraceFlag VARCHAR(10) ,
		Status BIT ,
		Global BIT ,
		Session BIT
	);

INSERT #TraceFlags
EXEC ('DBCC TRACESTATUS(-1) WITH NO_INFOMSGS');

----------------------------------------

IF @Mode IN (1, 99) BEGIN
	/*
	Server and instance info
	*/
	SELECT * FROM (
		SELECT
			r.CheckName
			, r.Details
		FROM #Results r
		WHERE r.CategoryID = 1
			AND r.CheckID NOT IN (110)
		) r1
	PIVOT (
		MIN (Details)
		FOR CheckName IN (
		[Server Name]
		, [Instance Name]
		, [Instance Version]
		, [Instance Edition]
		, [Instance Build]
		, [Communication Protocol]
		, [Operating System]
		, [Server Type]
		, [SQL Server Service Account]
		, [Is sysadmin]
		, [IP Address]
		)
	) AS PivotTable;


	/*
	Cluster info
	*/

	SELECT
		@ClusterName AS ClusterName
		, @QuorumType AS QuorumType
		, @QuorumState AS QuorumState;


	/*
	Cluster members
	*/

	SELECT
		MemberName AS ClusterMemberName
		, MemberType AS ClusterMemberType
		, MemberState AS ClusterMemberState
		, NumberOfQuorumVotes
	FROM #ClusterMembers
	ORDER BY
		MemberType
		, MemberName;

	/*
	Endpoints
	*/

	SELECT
		EndpointName
		, EndpointOwner
		, EndpointState
		, AuthenticationType
		, CertificateName
		, CertificateExpiration
	FROM #Endpoints
	ORDER BY EndpointName;


	/*
	Availability Group info
	*/

	SELECT
		AGName
		, CurrentRole
		, AGOwner
		, BackupPreference
		, ClusterType
		, IsContained
		, DatabaseLevelHealthDetection
		, DTCSupport
		, ReadOnlyRoutingEnabled
		, HealthCheckTimeout
	FROM #AvailabilityGroups
	ORDER BY AGName;


	/*
	Listener info
	*/
	
	SELECT
		ListenerNameDNS
		, ListenerPort
		, ListenerIP
		, ListenerSubnetIP
		, ListenerIPState
		, AGName
	FROM #Listeners
	ORDER BY
		AGName
		, ListenerNameDNS
		, ListenerIP;

	/*
	Replica info
	*/

	SELECT
		AGName
		, ServerInstance
		, CurrentRole
		, AvailabilityMode
		, FailoverMode
		, PrimaryAllowConnections
		, SecondaryAllowConnections
		, SeedingMode
		, SessionTimeout
		, EndPointURL
	FROM #Replicas
	ORDER BY 
		AGName
		, ServerInstance;

	/*
	Database info
	*/
	SELECT
		DatabaseName
		, DatabaseState
		, AGName
		, ServerInstance
		, CurrentRole
		, SynchronizationState
		, IsLocal
		, IsJoined
		, IsSuspended
		, IsFailoverReady
		, COALESCE(DatabaseOwner, 'UNKNOWN') AS DatabaseOwner
		, SecondaryLagInSeconds
	FROM #Databases
	ORDER BY
		AGName
		, DatabaseName
		, ServerInstance

	END;


-------------------------------------
IF @Mode IN (0, 99) BEGIN

	/* Endpoint not owned by sa */
	INSERT #Results
	SELECT
		4
		, 406
		, 1
		, 'Endpoint owner'
		, 'The endpoint [' + EndpointName + '] is owned by the login [' + EndpointOwner + '].'
		, NULL
		, 'If this login becomes inaccessible or unable to be verified, the endpoint could cease to work.'
		, 'We recommend setting endpoint ownership to ''sa'' to avoid connection issues.'
		, 'https://straightpathsql.com/ca/endpoint-ownership'
	FROM #Endpoints
	WHERE EndpointOwner <> 'sa';

	/* AG not owned by sa */
	INSERT #Results
	SELECT
		4
		, 407
		, 1
		, 'Availability Group owner'
		, 'The availability group [' + AGName + '] is owned by the login [' + AGOwner + ']'
		, NULL
		, 'If this login becomes inaccessible or unable to be verified, the availability group could cease to work.'
		, 'We recommend setting availability group ownership to ''sa'' to avoid connection issues.'
		, 'https://straightpathsql.com/ca/availability-group-ownership'
	FROM #AvailabilityGroups
	WHERE AGOwner <> 'sa';

	/* Less than 3 quorum members online */
	IF (SELECT COUNT(MemberName) FROM #ClusterMembers WHERE MemberState = 'UP' AND NumberOfQuorumVotes > 0) < 3
		INSERT #Results	
		SELECT
			4
			, 408
			, 1
			, 'Less than 3 quorum members online'
			, 'The cluster [' + @ClusterName + '] has less than 3 members online'
			, NULL
			, 'If any currenly online quorum member of this cluster goes offline, the cluster may go offline as well.'
			, 'We recommend having at least 3 online quorum members online to reduce downtime or other cluster issues.'
			, 'https://straightpathsql.com/ca/cluster-quorum-members';

	/* Less than 3 quorum votes among members */
	IF (SELECT SUM(NumberOfQuorumVotes) FROM #ClusterMembers) < 3
		INSERT #Results	
			SELECT
			4
			, 409
			, 1
			, 'Less than 3 quorum votes among members'
			, 'The cluster [' + @ClusterName + '] has less than 3 quorum votes'
			, NULL
			, 'If any currenly online quorum member of this cluster goes offline, the cluster may go offline as well.'
			, 'We recommend having at least 3 members with votes to form a quorum to reduce downtime or other cluster issues.'
			, 'https://straightpathsql.com/ca/cluster-quorum-members';

	/* Offline cluster member */
	INSERT #Results
	SELECT
		4
		, 410
		, 1
		, 'Offline cluster member'
		, 'The cluster member [' + MemberName + '] is not currently UP'
		, NULL
		, 'If you get too many offline cluster members than the cluster will go offline.'
		, 'Find out why this cluster member is offline, and do it quickly.'
		, 'https://straightpathsql.com/ca/cluster-quorum-members'
	FROM #ClusterMembers
	WHERE MemberState <> 'UP';

	/* endpoint not started */
	INSERT #Results
	SELECT
		4
		, 411
		, 1
		, 'Endpoint not started'
		, 'The endpoint [' + EndpointName + '] is not currently STARTED'
		, NULL
		, 'Stopped endpoints lead to connection failures that result in the AG entering a RESOLVING state.'
		, 'Find out why this endpoint is offline, and do it quickly.'
		, 'https://straightpathsql.com/ca/endpoint-not-started'
	FROM #Endpoints
	WHERE EndpointState <> 'STARTED';

	/* seeding mode different among members */
	IF EXISTS (SELECT AGName FROM #Replicas GROUP BY AGName HAVING COUNT(DISTINCT(SeedingMode)) > 1)
		INSERT #Results	
		SELECT
			4
			, 412
			, 2
			, 'Seeding mode different among members'
			, 'The availability group [' + AGName + '] has replicas with different seeding modes.'
			, NULL
			, 'With different seeding modes, secondary replicas may not be synchronizing as expected.'
			, 'Review the seeding modes for the replicas and determine if this was intentional.'
			, 'https://straightpathsql.com/ca/availability-group-seeding-mode'
		FROM #AvailabilityGroups
		WHERE AGName IN (SELECT AGName FROM #Replicas GROUP BY AGName HAVING COUNT(DISTINCT(SeedingMode)) > 1);

	/* database not joined */
	INSERT #Results	
	SELECT
		4
		, 413
		, 1
		, 'Replica not joined'
		, 'The database [' + DatabaseName + '] on this replica is currently not joined to the availability group [' + AGName + '].'
		, NULL
		, 'Any secondary replica of this database will not be updated while it is not joined.'
		, 'Review the the configuration of the database to see why it is not joined.'
		, 'https://straightpathsql.com/ca/replica-not-joined'
	FROM #Databases
	WHERE IsJoined = 'No';

	/* database data movement suspended */
	INSERT #Results	
	SELECT
		4
		, 414
		, 1
		, 'Data movement suspended'
		, 'Data movement for the database [' + DatabaseName + '] is currently suspended in the availability group [' + AGName + '].'
		, NULL
		, 'Any secondary replica of this database will not be updated while data movement is suspended.'
		, 'Try to resume data movement to update secondary replicas of the database.'
		, 'https://straightpathsql.com/ca/availability-group-data-movement'
	FROM #Databases
	WHERE IsSuspended = 'Yes';

	/* session timeout at default */
	INSERT #Results	
	SELECT
		4
		, 415
		, 2
		, 'Session timeout at default'
		, 'The session tiemout value for [' + ServerInstance + '] in the AG [' + AGName + '] is currently at the default of 10.'
		, NULL
		, 'A value of 10 if often too low, and can lead to unexpected AG events during brief network events that last 10 seconds.'
		, 'We recommend raising the value to 15 or higher to improve AG stability.'
		, 'https://straightpathsql.com/ca/availability-group-session-timeout'
	FROM #Replicas 
	WHERE SessionTimeout <= 10;

	/* backup preference not primary */
	INSERT #Results	
	SELECT
		4
		, 416
		, 2
		, 'Backup preference not Primary'
		, 'The backup preference for the AG [' + AGName + '] is currently [' + BackupPreference + '].'
		, NULL
		, 'Backups may not be up to date if one or more of the secondary replicas becomes unavailable.'
		, 'We recommend backing up at the PRIMARY for the most consistent and up to date backups.'
		, 'https://straightpathsql.com/ca/availability-group-backup-preference'
	FROM #AvailabilityGroups 
	WHERE BackupPreference <> 'PRIMARY';

	/* listener offline */
	IF EXISTS (SELECT ListenerNameDNS FROM #Listeners WHERE ListenerIPState <> 'ONLINE')
		INSERT #Results	
		SELECT
			4
			, 417
			, 1
			, 'Listener offline'
			, 'The Listener [' + ListenerNameDNS + '] appears to be offline.'
			, NULL
			, 'If the listener is offline then connection attempts to the AG can be unsuccessful.'
			, 'Investigate and see if the listener can be brought online.'
			, 'https://straightpathsql.com/ca/offline-listener'
		FROM #Listeners
		WHERE ListenerNameDNS NOT IN (
			SELECT ListenerNameDNS
			FROM #Listeners
			WHERE ListenerIPState = 'ONLINE'
			);

	/* seeding mode set to AUTOMATIC */
	INSERT #Results	
	SELECT
		4
		, 418
		, 2
		, 'Seeding mode set to AUTOMATIC'
		, 'The seeding mode for [' + ServerInstance + '] in the AG [' + AGName + '] is currently set to AUTOMATIC.'
		, NULL
		, 'This setting can lead to unnecessary checks and annoying disconnects after a database has been seeded.'
		, 'We recommend setting the seeding mode to MANUAL to improve AG stability.'
		, 'https://straightpathsql.com/ca/availability-group-seeding-mode'
	FROM #Replicas 
	WHERE SeedingMode = 'AUTOMATIC';

	/* trace flag 9567 */
	INSERT #Results	
	SELECT
		4
		, 419
		, 3
		, 'Trace flag 9567 enabled'
		, 'Trace flag 9567 is enabled globally on this server.'
		, NULL
		, 'This trace flag enables compression of the data stream for availability groups during automatic seeding.'
		, 'During automatic seeding this compression can significantly reduce the transfer time, but also increase the load on the processor.'
		, 'https://straightpathsql.com/ca/trace-flag-9567'
	FROM #TraceFlags 
	WHERE TraceFlag = 9567;

	/* endpoint using expiring certificate */
	INSERT #Results	
	SELECT
		4
		, 420
		, 2
		, 'Endpoint using expiring certificate'
		, 'The certificate [' + CertificateName + '] used for endpoint [' + EndpointName + '] expires on ' + CONVERT(VARCHAR(20), CertificateExpiration) + '.'
		, NULL
		, 'When the certificate expires, the endpoint could stop working.'
		, 'Make a note of the expiration date and update the certificate used for this endpoint if necessary.'
		, 'https://straightpathsql.com/ca/endpoint-using-expiring-certificate'
	FROM #Endpoints
	WHERE CertificateExpiration IS NOT NULL;

	/* replica is not failover ready */
	INSERT #Results	
	SELECT
		4
		, 421
		, 1
		, 'Replica is not failover ready'
		, 'The database [' + d.DatabaseName + '] in [' + d.AGName + '] is not ready for failover.'
		, NULL
		, 'If the primary replica is configured for automatic failover, you may not get the desired failover.'
		, 'Check to see if any other secondary replicas are available for failover, and that they are SYNCHRONIZED.'
		, 'https://straightpathsql.com/ca/replica-not-failover-ready'
	FROM #Databases d
	INNER JOIN #Replicas r
		ON d.ReplicaID = r.ReplicaID
	WHERE d.IsFailoverReady <> 'Yes'
		AND r.FailoverMode = 'AUTOMATIC';

	/* high HADR_SYNC_COMMIT waits */
	INSERT #Results	
	SELECT
		4
		, 422
		, 2
		, 'High HADR_SYNC_COMMIT waits'
		, 'The average HADR_SYNC_COMMIT wait is [' + CONVERT(VARCHAR(20), (([wait_time_ms] * 1.0)/([waiting_tasks_count] + 1)), 108) + '] ms.'
		, NULL
		, 'Latency over 5 ms can negatively affect the performance of OLTP workloads.'
		, 'Check the secondary replica servers to see if there are slow writes, CPU pressure, or any kind of network latency issues.'
		, 'https://straightpathsql.com/ca/hadr_sync_commit'		
	FROM sys.dm_os_wait_stats   
	WHERE wait_type IN ('HADR_SYNC_COMMIT')
	AND (([wait_time_ms] * 1.0)/([waiting_tasks_count] + 1)) > 5.00 /* more than 5ms */

	/* high secondary lag */
	INSERT #Results	
	SELECT
		4
		, 423
		, 2
		, 'High secondary lag'
		, 'The database [' + d.DatabaseName + '] in [' + d.AGName + '] has a secondary lag of [' + CONVERT (VARCHAR(10), d.SecondaryLagInSeconds) + '] seconds to [' + r.ServerInstance + '].'
		, NULL
		, 'A lag over 5 seconds indicates a performance issue for OLTP workloads.'
		, 'Check for open transactions or any kind of network latency issues.'
		, 'https://straightpathsql.com/ca/secondary-lag'		
	FROM #Databases d
	INNER JOIN #Replicas r
		ON d.ReplicaID = r.ReplicaID
		AND d.GroupID = r.GroupID
	WHERE COALESCE(d.SecondaryLagInSeconds, -1) > 5; /* more than 5s */

	/* Health Check Timeout at default value or lower */
	INSERT #Results
	SELECT
		4
		, 424
		, 2
		, 'Health Check Timeout at default value'
		, 'Health Check Timeout value for the cluster supporting [' + AGName + '] is at the default value.'
		, NULL
		, 'This value can be overly aggressive in some environments, leading to unexpected cluster issues or failovers.'
		, 'We recommend setting this value higher - such as 45000 - to reduce the possibility of unexpected issues.'
		, 'https://straightpathsql.com/ca/health-check-timeout'
	FROM #AvailabilityGroups
	WHERE HealthCheckTimeout = 30000;

	INSERT #Results
	SELECT
		4
		, 424
		, 2
		, 'Health Check Timeout less than default value'
		, 'Health Check Timeout value for the cluster supporting [' + AGName + '] is [' + CONVERT(VARCHAR(5), HealthCheckTimeout) + '] ms.'
		, NULL
		, 'Microsoft does not recommend setting this value below the default of 30000, since this can lead to unexpected cluster issues or failovers.'
		, 'We recommend setting this value higher - such as 45000 - to reduce the possibility of unexpected issues.'
		, 'https://straightpathsql.com/ca/health-check-timeout'
	FROM #AvailabilityGroups
	WHERE HealthCheckTimeout < 30000;
	
	/* trace flag 1800 */
	INSERT #Results	
	SELECT
		4
		, 425
		, 3
		, 'Trace flag 1800 enabled'
		, 'Trace flag 1800 is enabled globally on this server.'
		, NULL
		, 'Trace flag 1800 enables SQL Server optimization when disks of different sector sizes are used for primary and secondary replica log files.'
		, 'This trace flag is only required to be enabled on SQL Server instances with transaction log file residing on disk with sector size of 512 bytes, so verify it is needed.'
		, 'https://straightpathsql.com/ca/trace-flag-1800'
	FROM #TraceFlags 
	WHERE TraceFlag = 1800;

	/* different failover modes used for same AG or instance */
	INSERT #Results	
	SELECT
		4
		, 427
		, 2
		, 'Different failover modes - same AG'
		, 'There are different failover modes used for the replicas in the availability group [' + ag.AGName + '].'
		, NULL
		, 'Different failover modes will produce different failover behaviors.'
		, 'Review the failover modes for the replicas in this availability group to confirm these are the intended values.'
		, 'https://straightpathsql.com/ca/availability-group-failover-mode'
	FROM #AvailabilityGroups ag 
	INNER JOIN (
		SELECT 
			AGName
			, COUNT(DISTINCT FailoverMode) AS FailoverMode
		FROM #Replicas
		GROUP BY AGName
		HAVING COUNT(DISTINCT FailoverMode) > 1) x
		ON ag.AGName = x.AGName;

	INSERT #Results	
	SELECT
		4
		, 428
		, 2
		, 'Different failover modes - same instance'
		, 'There are different failover modes used for the availability groups on [' + cm.MemberName + '].'
		, NULL
		, 'Different failover modes will produce different failover behaviors.'
		, 'Review the failover modes for the availability groups on this instance to confirm these are the intended values.'
		, 'https://straightpathsql.com/ca/availability-group-failover-mode'
	FROM #ClusterMembers cm 
	INNER JOIN (
		SELECT 
			ServerInstance
			, COUNT(DISTINCT FailoverMode) AS FailoverMode
		FROM #Replicas
		GROUP BY ServerInstance
		HAVING COUNT(DISTINCT FailoverMode) > 1) x
		ON cm.MemberName = x.ServerInstance;

	END;

IF @Mode IN (0, 2, 99) BEGIN
	/* recent state change */
	IF OBJECT_ID('tempdb..#StateChanges') IS NOT NULL
		DROP TABLE #StateChanges;

	CREATE TABLE #StateChanges (
		ObjectName VARCHAR(50)
		, EventTimeStamp DATETIME2
		, AGName NVARCHAR(128)
		, PreviousState NVARCHAR(60)
		, CurrentState NVARCHAR(60)
		);

	DECLARE @xel_path VARCHAR(1024);
	DECLARE @utc_adjustment INT = datediff(hour, getutcdate(), getdate());
 
	-- target event_file path retrieval --
	;WITH target_data_cte AS
	(
		SELECT  
			target_data = CONVERT(XML, target_data)
		FROM sys.dm_xe_sessions s
		INNER JOIN sys.dm_xe_session_targets st
			ON s.address = st.event_session_address
		WHERE s.name = 'AlwaysOn_health'
			AND st.target_name = 'event_file'
	),
	full_path_cte AS
	(
		SELECT
			full_path = target_data.value('(EventFileTarget/File/@name)[1]', 'varchar(1024)')
		FROM target_data_cte
	)
	SELECT
		@xel_path = 
			left(full_path, len(full_path) - charindex('\', reverse(full_path))) + 
			'\AlwaysOn_health*.xel'
	FROM full_path_cte;
 
	-- replica state change events --
 
	;WITH state_change_data AS
	(
		SELECT
			object_name
			, event_data = CONVERT(XML, event_data)
		FROM sys.fn_xe_file_target_read_file(@xel_path, null, null, null)
	)
	INSERT #StateChanges
	SELECT
		--@@servername "host name"
		object_name
		, event_timestamp = dateadd(hour, @utc_adjustment, event_data.value('(event/@timestamp)[1]', 'datetime'))
		, ag_name = event_data.value('(event/data[@name = "availability_group_name"]/value)[1]', 'varchar(64)')
		, previous_state = event_data.value('(event/data[@name = "previous_state"]/text)[1]', 'varchar(64)')
		, current_state = event_data.value('(event/data[@name = "current_state"]/text)[1]', 'varchar(64)')
	FROM state_change_data
	WHERE object_name = 'availability_replica_state_change';

	INSERT #Results
	SELECT
		4
		, 426
		, 2
		, 'Recent state change'
		, 'There has been a state change for [' + AGName + '] on this replica in the last 24 hours.'
		, NULL
		, 'If there were no scheduled failovers, this could indicate network instability among replicas.'
		, 'Use sp_CheckAG with @Mode = 2 to view all the recent state changes.'
		, 'https://straightpathsql.com/ca/availability-group-state-change'
	FROM (
		SELECT
			AGName
			, MAX(EventTimeStamp) AS EventTimeStamp
		FROM #StateChanges
		GROUP BY AGName) sc
	WHERE sc.EventTimeStamp > DATEADD (hh, -24, CURRENT_TIMESTAMP); /* in last 24 hours */

	END;

IF @Mode IN (0, 99) BEGIN
	/* issue results */
	SELECT
		r.Importance
		, r.CheckName
		, r.Issue
		, r.DatabaseName
		, r.Details
		, r.ActionStep    
		, r.ReadMoreURL
		, r.CheckID
	FROM #Results r
	INNER JOIN #Category c
		ON r.CategoryID = c.CategoryID
	WHERE r.CategoryID > 1
	ORDER BY
		r.Importance
		, c.CategoryID
		, r.CheckID
		, r.Issue
		, r.DatabaseName;

	END;

IF @Mode IN (2) BEGIN

	SELECT
		@@SERVERNAME AS InstanceName
		, ObjectName
		, EventTimeStamp
		, AGName
		, PreviousState
		, CurrentState
	FROM #StateChanges
	WHERE AGName = COALESCE(@AGName, AGName)
	ORDER BY EventTimeStamp DESC;
	END;

	GO