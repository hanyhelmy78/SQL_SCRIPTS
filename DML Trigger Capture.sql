-- DML Trigger on dbo.SomeTable
USE ABP_SFA_BMB
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER DML_Capture_trgr_Parameter_Assignments
ON Parameter_Assignments
FOR INSERT, UPDATE, DELETE
AS 
BEGIN
SET NOCOUNT ON;
DECLARE
        @EventData XML = EVENTDATA();
    DECLARE 
        @ip VARCHAR(32) =
        (
            SELECT client_net_address
                FROM sys.dm_exec_connections
                WHERE session_id = @@SPID);
  INSERT DMLEvents
    (
        EventType,
        EventDML,
        EventXML,
        DatabaseName,
        SchemaName,
        ObjectName,
        HostName,
        IPAddress,
        ProgramName,
        LoginName
    )
    SELECT -- ALL EventData COULMNS WILL NOT APPEAR AS THIS IS APPLICABLE ONLY 4 DDL EVENTS NOT DML EVENTS!*******************
        @EventData.value('(/EVENT_INSTANCE/EventType)[1]',   'NVARCHAR(100)'), 
        @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)'),
        @EventData,
        DB_NAME(),
        @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]',  'NVARCHAR(255)'), 
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]',  'NVARCHAR(255)'),
        HOST_NAME(),
        @ip,
        PROGRAM_NAME(),
        SUSER_SNAME();
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

USE master
GRANT VIEW SERVER STATE TO [DEV_User],[BMBBE],[BMBINT],[BMBWS],[cicadmin],[EAI_USER],[hpdesk],[pdr],[SEIBINT],[SSO_User]