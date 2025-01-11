USE [master]
GO

/****** Object:  Audit [AuditFailedLogins]    Script Date: 21/08/2016 08:55:28 ******/
CREATE SERVER AUDIT [AuditFailedLogins]
TO FILE 
(	FILEPATH = N'T:\Audit\'
	,MAXSIZE = 5 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = ON
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = CONTINUE
	,AUDIT_GUID = '2c3ed5ee-a732-4a75-bdd4-1da1dceca079'
)
ALTER SERVER AUDIT [AuditFailedLogins] WITH (STATE = ON)
GO