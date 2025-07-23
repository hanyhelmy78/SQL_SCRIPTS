Students need to troubleshoot to identify the issue.

### To solve this issue

You need to start SQL Server with `Single_user` and `Minimal` configuration

```cmd
Net Stop mssqlserver
Net Start mssqlserver /mSQLCMD /f
SqlCmd -S . -E

```

```sql
select name from sys.server_triggers where is_disabled = 0
go
DISABLE TRIGGER [trigger_name] ON ALL SERVER;
go
DISABLE TRIGGER [trigger_name] ON ALL SERVER;
go
```
 
```cmd
Net Stop mssqlserver
Net Start mssqlserver

```
