```cmd
SqlCmd -S . -E
```

```sql
1> select name from sys.databases;
2> go
name                                                                                                                    
--------------------------------------------------------------------------------------------------------------------------------
master                                                                                                                  
tempdb                                                                                                                  
model                                                                                                                   
msdb                                                                                                                    
Test                                                                                                                    
AdventureWorks2019                                                                                                      
AdventureWorksDW2019                                                                                                    
AdventureWorksLT2019                                                                                                    
AdventureWorksDW2016                                                                                                    
ttt                                                                                                                     
dbRecovery                                                                                                              
distribution                                                                                                            

(12 rows affected)
use AdventureWorks2019
go
Msg 916, Level 14, State 2, Server SQLSERVERVM01, Line 1
The server principal "TLMS\MSSQL" is not able to access the database "AdventureWorks2019" under the current security context.
exit
```
Connect to SQL Server using `DAC`
```cmd
sqlcmd -S . -A
Sqlcmd: Error: Microsoft ODBC Driver 17 for SQL Server : Login failed for user 'TLMS\mssql'..
```

Even if you stop and start SQL Server with /mSQLCMD
```cmd
G:\>net start mssqlserver /msqlcmd
The SQL Server (MSSQLSERVER) service is starting..
The SQL Server (MSSQLSERVER) service was started successfully.


G:\>sqlcmd -S . -E
Sqlcmd: Error: Microsoft ODBC Driver 17 for SQL Server : Login failed for user 'TLMS\MSSQL'. Reason: Server is in single user mode. Only one administrator can connect at this time..

G:\>sqlcmd -S . -A
Sqlcmd: Error: Microsoft ODBC Driver 17 for SQL Server : Login failed for user 'TLMS\MSSQL'. Reason: Server is in single user mode. Only one administrator can connect at this time..
```


### To solve this issue:
When starting SQL Server in single-user mode, all members of the local computer's Administrators group are automatically made members of the sysadmin role.

Run the command below and wait until the text message `Recovery is complete` appears.

```cmd
net stop mssqlserver
cd "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn"
sqlservr.exe -m "SQLCMD" -s MSSQLSERVER -c
```

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/LockoutFromSysadmin_00.png)

Open another cmd session

```cmd
sqlcmd -S . -E
```

```sql
1> alter server role sysadmin add member [tlms\mssql]
2> go
1> 
```

Then go to the first cmd session and press CNTL + C

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/LockoutFromSysadmin_01.png)

Lastly, start the service and add all existing sysadmin logins, and enable the [sa] login.

```cmd
net start mssqlserver
sqlcmd -S . -E

```

```sql
alter server role sysadmin add member [fawzy]
go
alter login [sa] enable
go

```
