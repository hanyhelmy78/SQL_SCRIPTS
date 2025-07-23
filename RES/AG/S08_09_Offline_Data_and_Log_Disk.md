
![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/OfflineDataDisk.png)

### To fix the issue:

**Checking**
If you can't see the disk properties, the disk is in an offline state.

```Powershell

$DriveLetter = "F"
$DeviceID = (Get-Volume | where {$_.DriveLetter -eq $DriveLetter} | select Path).path
Get-Volume -Path $DeviceID | Get-Partition | Get-Partition | select DriveLetter, IsHidden, IsOffline, Size, IsReadOnly

```

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/OfflineDataDisk_1.png)

#### Bring the disk `online`, however, you may need to `restart the SQL Server` to completely fix the issue.
