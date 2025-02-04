--CREATE THE TRIGGER TO PREVENT THE DROPPING OF SQL SERVER DATABASES
USE Monitor;
go
CREATE TRIGGER ServerDBsMonitor_trigger ON ALL SERVER
FOR DROP_DATABASE
,CREATE_DATABASE
AS

--THE FOLLOWING PREVENTS ALL USERS DROPPING OR CREATING DATABASES
IF
IS_MEMBER ('db_owner') = 0 or IS_MEMBER ('db_owner') = 1
BEGIN
PRINT 'You do not have permission to create or delete databases! Consult your database administrator!'
ROLLBACK TRANSACTION;
END
--POPULATE THE HOLDING TABLE WITH INFORMATION RELATING TO THE PERSON ATTEMPTING
--TO DROP OR CREATE A DATABASE ON THIS SERVER
BEGIN
INSERT INTO Monitor.dbo.ServerDBsMonitor_Log (
NTUserName --Windows LogIn Name
,SQLServerUser --SQL Server LogIn Name
,ServerName --The Workstation from which the command was executed
,EventTime --The time of the event
,TSQLText) --The command that was executed
VALUES (
SUSER_NAME()
,CURRENT_USER
,@@SERVERNAME
,CURRENT_TIMESTAMP
,EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand)[1]','nvarchar(max)')
)
END;
GO