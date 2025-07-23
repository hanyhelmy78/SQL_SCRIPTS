A misconfiguration in the spelling of the folder name or its location can cause the SQL Server to stop after restarting the service, as the new location doesn't exist.

### To solve the issue:

1. Start the SQL Server using minimal configuration `/f`.
2. Connect to SQL Server using `SQLCMD`.

   ```bash
   net start mssqlserver /mSQLCMD /f
   sqlcmd -S . -E

   ```   
3. Retrieve the file logical name, and the locations of the `tempdb`.
4. `Modify` the files to the correct locations.

   ```sql
   select name, physical_name from sys.master_files where database_id = 2
   go
   alter database tempdb modify file (name='tempdev',filename='T:\Temp\tempdb.mdf')
   go
   alter database tempdb modify file (name='templog',filename='T:\Temp\templog.ldf')
   go
   alter database tempdb modify file (name='temp2',filename='T:\Temp\tempdb_mssql_2.ndf')
   go
   ```
5. Stop the SQL Server.
6. Start it normally.

   ```bash
   net stop mssqlserver
   net start mssqlserver
   ```
