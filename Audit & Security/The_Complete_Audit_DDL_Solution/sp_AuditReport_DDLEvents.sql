USE master
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].AuditReport	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @Var_recipients1 AS NVARCHAR(MAX) = '<Emails>';
		DECLARE @Var_Query_Attachment_Filename1 AS VARCHAR(100) = 'AuditReport_' + (CONVERT(VARCHAR(11),GETDATE(),106)) + '.csv';
		DECLARE @Var_Query1_For_Email NVARCHAR(MAX);
		DECLARE @Command NVARCHAR(MAX);
		DECLARE @columnname varchar(400);

		SET @Command = 'DELETE FROM master.[dbo].[DDLEvents]
      WHERE [EventDate] < GETDATE() - 30
	  GO';
	    EXEC SP_EXECUTESQL @Command;

		SET @Var_Query1_For_Email =
'SELECT  [EventDate]
		,[EventType]
		,[EventDDL]
		,[EventXML]
		,[DatabaseName]
		,[SchemaName]
		,[ObjectName]
		,[HostName]
		,[IPAddress]
		,[ProgramName]
		,[LoginName]
  FROM [master].[dbo].[DDLEvents]'

			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'SQLDBA',
			@recipients = @Var_recipients1,
			@subject = 'AuditReport',
			@body='Please check the attached for today`s AuditReport',
			@query = @Var_Query1_For_Email,
			@attach_query_result_as_file = 1,
			@query_attachment_filename = @Var_Query_Attachment_Filename1,
			@query_result_separator=',',
			@query_result_width =32767,
			@query_result_no_padding=1
				
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2047);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END