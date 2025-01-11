USE master
GO
CREATE OR ALTER TRIGGER [PREVENT_APP_LOGIN]
ON ALL SERVER
FOR LOGON
AS
BEGIN
	DECLARE @program_name nvarchar(128)
	DECLARE @host_name nvarchar(128)
	SELECT  @program_name = program_name,
			@host_name = host_name
	FROM	sys.dm_exec_sessions AS c
	WHERE	c.session_id = @@spid
		IF	ORIGINAL_LOGIN() IN ('svc_Appdy_QA','svc_Appdynpre','svc_BillingCore_QA','svc_dvscorepre','SVC_KeyCloak_PRE')
	AND (@program_name LIKE '%Management%Studio%'
	OR   @program_name LIKE '%SSMS%'
	OR   @program_name LIKE '%Razor%'
	OR   @program_name LIKE '%Toad%'
	OR   @program_name LIKE '%Studio%')
	BEGIN
		RAISERROR('This login is for application use only!',16,1)
		ROLLBACK;
	END
END;

-- DISABLE TRIGGER [PREVENT_APP_LOGIN] ON ALL SERVER