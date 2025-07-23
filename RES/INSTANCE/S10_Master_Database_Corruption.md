If you experience corruption in the master database, you need to rebuild it immediately by any means necessary.

This error message will appear in your error log or event viewer.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MasterCorruption_00.png)

As I mentioned, you need to rebuild the databases first.

Open the `Bootstrap` folder in the local server. You can add the `/QUIET` parameter to avoid seeing the execution messages from the SQL server, and you will not see anything else than the below screenshot.

```cmd
cd "C:\Program Files\Microsoft SQL Server\150\Setup Bootstrap\SQL2019"
setup.exe /QUIET /ACTION=RebuildDatabase /InstanceName=MSSQLSERVER /SQLSysAdminAccounts=TLMS\mssql /SaPWD=P@$$w0rd

```
![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MasterCorruption_01.png)

Look at the rebuild result from the log folder as it shows below.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MasterCorruption_02.png)

Start the SQL Service

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MasterCorruption_03.png)


There are two scenarios to resolve this issue.

First, ensure you have a proper backup of the system database (master, msdb, and model). and you will need to take a backup from the below:
   1. Logins
   2. Jobs
   3. Linked Servers
   4. Server Triggers
   5. Audits
   6. reconfigure your model database
   7. attach all existing database, because after rebuilding master there is no database will be attached all are detached.
   8. recreate all maintenance plans
   9. reconfigure mirroring
   10. reconfigure replication
   11. readding certifications, proxy, operators, alerts, credintials, extended events, and etc..
   12. reconfigure the always on availability group/s

Secondly, you can restore system databases effortlessly.   


