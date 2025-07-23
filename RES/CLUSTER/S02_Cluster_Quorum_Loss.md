### To simulate Windows Failover Cluster down
Go to `SQLSERVERVM02` and `SQLSERVERVM03` and close the cluster server (`ClusSvc`)

Then set `DynamicQuorum` = 0
```Powershell

(Get-Cluster).DynamicQuorum=0 # recommended value is 1
```

```Powershell

$quorum = Get-WmiObject -namespace 'root\mscluster' -Query "ASSOCIATORS OF {MSCluster_Cluster.Name='.'} WHERE AssocClass=MSCluster_ClusterToQuorumResource";
(Get-Cluster).SameSubnetDelay = 500 # recommended value is 1500
(Get-Cluster).SameSubnetThreshold = 3 # Minimum value is 3 # recommended value is 50
(Get-ClusterResource -Name "File Share Witness").RestartAction = 0 # recommended value is 2
$quorum.FailResource()
```

### Resource fails behavior:
The `RestartAction` parameter in Windows Failover Cluster settings specifies what action the cluster service should take if a resource fails. The possible values for the `RestartAction` parameter are as follows:

1. **ClusterResourceDontRestart (0)**: Do not restart the resource after a failure.
2. **ClusterResourceRestartNoNotify (1)**: Restart the resource after a failure. If the resource exceeds its restart threshold within its restart period, do not attempt to failover the group to another node in the cluster.
3. **ClusterResourceRestartNotify (2)**: Restart the resource after a failure. If the resource exceeds its restart threshold within its restart period, attempt to failover the group to another node in the cluster. This is the default setting.

### Resource Votes:
```Powershell

(Get-ClusterQuorum)
(Get-ClusterNode -Name "SQLSERVERVM01").NodeWeight = 1
(Get-ClusterNode -Name "SQLSERVERVM02").NodeWeight = 1
(Get-ClusterNode -Name "SQLSERVERVM03").NodeWeight = 1
(Get-ClusterResource -Name "Cluster Disk Witness").NodeWeight = 1
# File Share Witness does't have NodeWeight parameter, its always 1
```

### Number of missing heartbeats before a node on the same subnet is considered unreachable:
The `SameSubnetThreshold` parameter in a Windows Failover Cluster determines the number of missed heartbeats before a node on the same subnet is considered unreachable. 

In a Windows Failover Cluster, heartbeat signals are sent between nodes to monitor their health and availability. If a node misses a certain number of heartbeats consecutively, it is considered to be down or unreachable.

Here’s how it works:
- **Heartbeat Interval**: The time interval between heartbeat signals, controlled by the `SameSubnetDelay` parameter (in milliseconds).
- **SameSubnetThreshold**: The number of consecutive missed heartbeats before a node is considered unreachable.

For example, if the `SameSubnetDelay` is set to 1000 milliseconds (1 second) and the `SameSubnetThreshold` is set to 5, a node must miss 5 consecutive heartbeats (5 seconds) before it is considered unreachable.

You can view and modify these settings using PowerShell:

```powershell
# Check current settings
Get-Cluster | Select-Object SameSubnetDelay, SameSubnetThreshold

# Modify the settings (example values)
(Get-Cluster).SameSubnetThreshold = 5;  # Number of consecutive missed heartbeats
```
By adjusting the `SameSubnetThreshold`, you can fine-tune the cluster's sensitivity to node failures on the same subnet, balancing between responsiveness and tolerance to transient network issues.```

### Cluster Heartbeat Interval:
The cluster heartbeat interval determines how frequently heartbeat signals are sent between nodes. The default interval is 1 second. You can check and adjust this setting using PowerShell:

```powershell
# Check the current settings
Get-Cluster | Select-Object SameSubnetDelay, CrossSubnetDelay

# Modify the settings (example values)
(Get-Cluster).SameSubnetDelay = 1000  # 1 second, Minimum value is 500 ms and the Maximum value is 2000 ms
(Get-Cluster).CrossSubnetDelay = 2000  # 2 seconds
```


