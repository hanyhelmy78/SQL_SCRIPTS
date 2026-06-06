Create a folder on your **jump server** and put the three PowerShell files in it.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/AlwaysOn/Failover/Distributed/media/Placing_files.png)


Add any replica from each cluster into `$HostsList = @("SQLCRMVM02","SQLITSMVM05","SQLERPVM01","SQLSharePointM01")`.

Then, execute the following scripts from your **jump server**:

1. Execute the **Sanity_Check_before_Failover.ps1**

```powershell
if (Test-Path variable:HostsList) {rv HostsList}
$scriptContent = Get-Content "C:\FailoverScripts\Sanity_Check_before_Failover.ps1" -Raw
$scriptBlock   = [ScriptBlock]::Create($scriptContent)
$HostsList = [System.Collections.ArrayList]@()
$HostsList = @( "SQLCRMVM02","SQLITSMVM05","SQLERPVM01","SQLSharePointM01")
for ($h = 0; $h -lt $HostsList.count; $h++)
    {
        $computerName = $HostsList[$h]
        Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock
    }

```

2. Execute the **ChangeSyncCommitMode.ps1**

```powershell
if (Test-Path variable:HostsList) {rv HostsList}
$scriptContent = Get-Content "C:\FailoverScripts\ChangeSyncCommitMode.ps1" -Raw
$scriptBlock   = [ScriptBlock]::Create($scriptContent)
$HostsList = [System.Collections.ArrayList]@()
$HostsList = @( "SQLCRMVM02","SQLITSMVM05","SQLERPVM01","SQLSharePointM01")
for ($h = 0; $h -lt $HostsList.count; $h++)
    {
        $computerName = $HostsList[$h]
        Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock
    }

```

3. Execute the **FailoverAndRevertRoleAsync.ps1**

```powershell
if (Test-Path variable:HostsList) {rv HostsList}
$scriptContent = Get-Content "C:\FailoverScripts\FailoverAndRevertRoleAsync.ps1" -Raw
$scriptBlock   = [ScriptBlock]::Create($scriptContent)
$HostsList = [System.Collections.ArrayList]@()
$HostsList = @( "SQLCRMVM02","SQLITSMVM05","SQLERPVM01","SQLSharePointM01")
for ($h = 0; $h -lt $HostsList.count; $h++)
    {
        $computerName = $HostsList[$h]
        Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock
    }

```

