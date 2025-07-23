There is no communication between cluster nodes, and the Cluster service is down on all nodes.

```powershell

PS C:\Users\mssql> netstat -ano | findstr "3343"
PS C:\Users\mssql> get-service ClusSvc

Status   Name               DisplayName
------   ----               -----------
Stopped  ClusSvc            Cluster Service


PS C:\Users\mssql> start-service ClusSvc
PS C:\Users\mssql> get-service ClusSvc

Status   Name               DisplayName
------   ----               -----------
Running  ClusSvc            Cluster Service


PS C:\Users\mssql> netstat -ano | findstr "3343"
  TCP    0.0.0.0:3343           0.0.0.0:0              LISTENING       4616
  TCP    192.168.100.101:56655  192.168.100.102:3343   SYN_SENT        4616
  TCP    192.168.100.101:56657  192.168.100.102:3343   SYN_SENT        4616
  TCP    [::]:3343              [::]:0                 LISTENING       4616

PS C:\Users\mssql> Enter-PSSession -ComputerName sqlservervm02
[sqlservervm02]: PS C:\Users\mssql\Documents> get-service ClusSvc

Status   Name               DisplayName
------   ----               -----------
Stopped  ClusSvc            Cluster Service


[sqlservervm02]: PS C:\Users\mssql\Documents> start-service ClusSvc
WARNING: Waiting for service 'Cluster Service (ClusSvc)' to start...
[sqlservervm02]: PS C:\Users\mssql\Documents> netstat -ano | findstr "3343"
  TCP    0.0.0.0:3343           0.0.0.0:0              LISTENING       2428
  TCP    192.168.100.102:60658  192.168.100.101:3343   CLOSE_WAIT      2428
  TCP    [::]:3343              [::]:0                 LISTENING       2428
  TCP    [fe80::f92e:7d46:5188:3a89%7]:3343  [fe80::b82c:ee7:7338:3fae%7]:56783  ESTABLISHED     2428
  UDP    192.168.100.102:3343   *:*                                    4
[sqlservervm02]: PS C:\Users\mssql\Documents> exit

PS C:\Users\mssql> Enter-PSSession -ComputerName sqlservervm03
[sqlservervm03]: PS C:\Users\mssql\Documents> get-service ClusSvc

Status   Name               DisplayName
------   ----               -----------
Stopped  ClusSvc            Cluster Service


[sqlservervm03]: PS C:\Users\mssql\Documents> start-service ClusSvc
WARNING: Waiting for service 'Cluster Service (ClusSvc)' to start...
[sqlservervm03]: PS C:\Users\mssql\Documents> netstat -ano | findstr "3343"
  TCP    0.0.0.0:3343           0.0.0.0:0              LISTENING       2272
  TCP    192.168.100.150:53223  192.168.100.101:3343   CLOSE_WAIT      2272
  TCP    192.168.100.150:53224  192.168.100.102:3343   CLOSE_WAIT      2272
  TCP    [::]:3343              [::]:0                 LISTENING       2272
  TCP    [fe80::c0b3:625e:9f06:1886%5]:3343  [fe80::b82c:ee7:7338:3fae%5]:56797  ESTABLISHED     2272
  TCP    [fe80::c0b3:625e:9f06:1886%5]:3343  [fe80::f92e:7d46:5188:3a89%5]:60678  ESTABLISHED     2272
  UDP    192.168.100.150:3343   *:*                                    4
[sqlservervm03]: PS C:\Users\mssql\Documents> exit

PS C:\Users\mssql>

```
