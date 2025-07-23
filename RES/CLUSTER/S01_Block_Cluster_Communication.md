When cluster nodes face blocking and your SQL Server fails to synchronize

When you access the primary replica and check the database status, it will display as Online and Multi-Access.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/block_cluster_communication_1.png)


However, if you try to access the Primary replica database, you will encounter the following error message.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/block_cluster_communication_2.png)

Additionally, the other replicas are accessible.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/block_cluster_communication_3.png)

If you check the Windows Failover Cluster, you'll see that it went down.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/block_cluster_communication_4.png)

Follow these steps on each replica server.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/block_cluster_communication_5.png)

```powershell

Get-Service -name ClusSvc

net start ClusSvc

# Check the communication port to see if any session is currently using it.

netstat -ano | findstr "3343"

# If a session is utilizing this port, we need to identify it. If it is not related to the cluster, we should terminate it.

tasklist /v /fi "PID eq 3716"

taskkill /pid 3716

taskkill /pid 3716 /F

Get-Service -name ClusSvc
```

If the **database** remains `Not Synchronizing` on all replicas, please follow the above steps on all replicas.



