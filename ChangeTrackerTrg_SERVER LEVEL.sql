USE master
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [ChangeTracker]
    ON ALL SERVER
FOR CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE, CREATE_TABLE, ALTER_TABLE, DROP_TABLE, CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION, CREATE_TRIGGER, ALTER_TRIGGER, DROP_TRIGGER, CREATE_VIEW, ALTER_VIEW, DROP_VIEW, ALTER_INDEX, DROP_INDEX, CREATE_INDEX, ALTER_DATABASE, CREATE_DATABASE, DROP_DATABASE
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
    INSERT ABP_SFA_BMB.dbo.DDLEvents
    (
        EventType,
        EventDDL,
        EventXML,
        DatabaseName,
        SchemaName,
        ObjectName,
        HostName,
        IPAddress,
        ProgramName,
        LoginName
    )
    SELECT
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

ENABLE TRIGGER [ChangeTracker] ON ALL SERVER
GO