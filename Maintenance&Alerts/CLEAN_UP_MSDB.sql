USE msdb
GO
DECLARE @varDate DATETIME
-- Set date to 30 days ago
SET @varDate = DATEADD(d,-30,GETDATE());
-- delete from dbm_monitor_data
--DELETE FROM dbm_monitor_data
--WHERE time < @varDate;
-- delete from sysmail_mailitems
DELETE FROM sysmail_mailitems
WHERE Last_mod_date < @varDate;
-- delete from sysmail_attachments
DELETE FROM dbo.sysmail_attachments
WHERE Last_mod_date < @varDate;
-- delete from sysmail_send_retries
DELETE FROM dbo.sysmail_send_retries
WHERE Last_send_attempt_date < @varDate;
-- delete from sysmail_allitems
EXEC Sysmail_delete_mailitems_sp
@Sent_before = @varDate;
-- delete from sysmail_log
EXEC Sysmail_delete_log_sp
@Logged_before = @varDate;
GO