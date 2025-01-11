--alter database Saturn set recovery full;
backup database Saturn to disk = N'c:\Saturn.bak' with format;
-- because there is no log backup we cannot restore using "with norecovery" option
restore database Saturn from disk = N'c:\Saturn.bak' with replace
-- perform transaction log backup (as the db in full recovery model)
backup log Saturn to disk = N'c:\Saturn.trn';
restore database Saturn from disk = N'c:\Saturn.bak' with norecovery;
-- restore log
restore log Saturn from disk = N'c:\Saturn.trn'
with file = 1, norecovery;
-- restore the log and back online.
restore log Saturn from disk = N'c:\Saturn.trn'
with recovery;