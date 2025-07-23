### Connect to the synchronized node `sqlservervm01`.

```powershell
PS C:\Users\mssql> netstat -ano | findstr "5022"
  TCP    192.168.100.101:5022   0.0.0.0:0              LISTENING       5840
  TCP    192.168.100.101:5022   192.168.100.102:60616  ESTABLISHED     5840
  TCP    192.168.100.101:5022   192.168.100.150:53038  ESTABLISHED     5840


PS C:\Users\mssql> Enter-PSSession -ComputerName sqlservervm02
[sqlservervm02]: PS C:\Users\mssql\Documents> netstat -ano | findstr "5022"
  TCP    0.0.0.0:5022           0.0.0.0:0              LISTENING       2844
  TCP    192.168.100.102:60618  192.168.100.101:5022   ESTABLISHED     2844
  TCP    [::]:5022              [::]:0                 LISTENING       2844


[sqlservervm02]: PS C:\Users\mssql\Documents> exit
PS C:\Users\mssql> Enter-PSSession -ComputerName sqlservervm03
[sqlservervm03]: PS C:\Users\mssql\Documents> netstat -ano | findstr "5022"
  TCP    0.0.0.0:5022           0.0.0.0:0              LISTENING       3144
  TCP    192.168.100.150:53088  192.168.100.101:5022   ESTABLISHED     3144
  TCP    [::]:5022              [::]:0                 LISTENING       3144


[sqlservervm03]: PS C:\Users\mssql\Documents> exit
PS C:\Users\mssql> sqlcmd -S . -E
1> alter endpoint hadr_endpoint state=stopped
2> go
1> alter endpoint hadr_endpoint state=started
2> go
Msg 9692, Level 16, State 1, Server SQLSERVERVM01, Line 1
The Database Mirroring endpoint cannot listen on port 5022 because it is in use by another process.
1> exit
PS C:\Users\mssql> netstat -ano | findstr "5022"
  TCP    192.168.100.101:5022   0.0.0.0:0              LISTENING       5840
  TCP    192.168.100.101:5022   192.168.100.102:60620  ESTABLISHED     5840
  TCP    192.168.100.101:5022   192.168.100.150:53095  ESTABLISHED     5840
PS C:\Users\mssql> tasklist /v /fi "pid eq 5840"

Image Name                     PID Session Name        Session#    Mem Usage Status          User Name                                              CPU Time Window Title         
========================= ======== ================ =========== ============ =============== ================================================== ============ ========================================================================
wsmprovhost.exe               5840 Services                   0     74,076 K Unknown         TLMS\mssql                                              0:00:09 N/A                  
PS C:\Users\mssql> taskkill /pid 5840 /F
SUCCESS: The process with PID 5840 has been terminated.
PS C:\Users\mssql> netstat -ano | findstr "5022"
PS C:\Users\mssql> sqlcmd -S . -E
1> alter endpoint hadr_endpoint state=stopped
2> go
1> alter endpoint hadr_endpoint state=started
2> go
1> exit
PS C:\Users\mssql> netstat -ano | findstr "5022"
  TCP    0.0.0.0:5022           0.0.0.0:0              LISTENING       4168
  TCP    192.168.100.101:5022   192.168.100.102:60630  ESTABLISHED     4168
  TCP    192.168.100.101:5022   192.168.100.150:53108  ESTABLISHED     4168
  TCP    192.168.100.101:56550  192.168.100.150:5022   ESTABLISHED     4168
  TCP    192.168.100.101:56552  192.168.100.102:5022   ESTABLISHED     4168
  TCP    [::]:5022              [::]:0                 LISTENING       4168
PS C:\Users\mssql>
```
