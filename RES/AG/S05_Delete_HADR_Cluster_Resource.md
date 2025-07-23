When someone accidentally deletes the availability group.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/DeleteHADRONClusterResource.png)

### To fix this issue, you need to follow the below steps:

1. Remove the availability group role from the Windows Cluster Manager.
![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/DeleteHADRONClusterResource_0.png)

2. Drop the availability group from the primary node.
```sql
:CONNECT SQLSERVERVM01
use master
GO
SELECT * FROM sys.Availability_Groups;
GO
SELECT * FROM sys.Availability_Groups_Cluster;
GO
DROP AVAILABILITY GROUP [AG];
GO
```

3. Recover the database/s from the primary node.
```sql
:CONNECT SQLSERVERVM01
use master
GO
RESTORE DATABASE [AdventureWorks2019] WITH RECOVERY
GO
```
4. Create new availability group with the same configuration.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/DeleteHADRONClusterResource_1.png)
![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/DeleteHADRONClusterResource_2.png)
![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/DeleteHADRONClusterResource_3.png)
![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/DeleteHADRONClusterResource_4.png)

