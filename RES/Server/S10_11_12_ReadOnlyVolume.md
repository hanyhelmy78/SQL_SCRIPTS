Students need to troubleshoot, identify, and resolve the issue.

### To fix the issue:

**Checking**

```Powershell

$DriveLetter = "F"
$DeviceID = (Get-Volume | where {$_.DriveLetter -eq $DriveLetter} | select Path).path
Get-Volume -Path $DeviceID | Get-Partition | Get-Partition | select DriveLetter, IsHidden, IsOffline, Size, IsReadOnly

```

**Fixing**

```Powershell

Get-Volume -Path $DeviceID | Get-Partition | Set-Partition -IsReadOnly $False

```
