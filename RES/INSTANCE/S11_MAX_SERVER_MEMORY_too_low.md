### You may encounter the below error if someone has configured the memory with very low value.

```bash
Error: 17300, Severity: 16, State: 1. (Params:). The error is printed in terse mode because there was error during formatting. Tracing, ETW, notifications etc are skipped.

```

The error message you're encountering, `Error: 17300, Severity: 16, State: 1`, typically indicates that SQL Server is unable to run a new system task due to insufficient memory or because the number of configured sessions exceeds the maximum allowed on the server. Here are some steps you can take to resolve this issue:

1. **Verify Memory Availability**: Ensure that your server has adequate memory. You can check the current memory usage and availability using performance monitoring tools.

2. **Check Maximum User Connections**: Verify the maximum number of user connections allowed on the server. You can use the following command to check and configure the maximum user connections:
   ```sql
   EXEC sp_configure 'show advanced options', 1;
   RECONFIGURE;
   EXEC sp_configure 'user connections';
   ```

3. **Terminate Unnecessary Sessions**: If the number of active sessions is too high, you may need to terminate some sessions to free up resources. You can use the following command to check the current number of sessions:
   ```sql
   SELECT session_id, login_name, status
   FROM sys.dm_exec_sessions;
   ```

4. **Increase Server Memory**: If the server is running low on memory, consider adding more memory to the server or adjusting the maximum server memory setting. You can use the following command to adjust the maximum server memory:
   ```sql
   EXEC sp_configure 'max server memory', <desired_memory_in_MB>;
   RECONFIGURE;
   ```

5. **Restart SQL Server in Minimal Configuration Mode**: If you are unable to start SQL Server due to this error, you can start SQL Server in minimal configuration mode and then adjust the memory settings. Use the following command to start SQL Server in minimal configuration mode:
   ```cmd
   net start MSSQLServer /f
   ```
### To resolve it, you have two solutions:
1. Connect to SQL locally using a `DAC`.

      ```bash
      sqlcmd -S . -A
      ```
      ```sql
      EXEC sp_configure 'max server memory (MB)',2147483647
      go
      Reconfigure with override
      go
      ```
2. Start the SQL Server with `-f` for minimal configuration.
      ```bash
      #CMD SESSION 1
      <SQL Server Binn directory>\sqlservr.exe -f -m ”SQLCMD” -s "MSSQLSERVER" -c
      #or
      net stop mssqlserver
      net start mssqlserver /mSQLCMD /f
      
      #CMD SESSION 2
      SqlCmd -S . -E
      ```
      **Then**
      ```sql
      EXEC sp_configure 'max server memory (MB)',2147483647
      go
      Reconfigure with override
      go
      ```
      



