/*
https://learn.microsoft.com/en-us/sql/relational-databases/triggers/ddl-event-groups?view=sql-server-ver17
*/
USE master
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER [Audit_DDL_Events]
    ON ALL SERVER
FOR DDL_EVENTS
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
    INSERT <User_DB_name>.dbo.DDLEvents
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
        @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]','NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]',  'NVARCHAR(255)'), 
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]',  'NVARCHAR(255)'),
        HOST_NAME(),
        @ip,
        PROGRAM_NAME(),
        SUSER_SNAME()
-- WHERE @EventData.value('(/EVENT_INSTANCE/EventType)[1]','NVARCHAR(100) NOT IN ('UPDATE_STATISTICS', 'ALTER_INDEX')';
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ENABLE TRIGGER [Audit_DDL_Events] ON ALL SERVER
GO
