$service = "mssqlserver"

$account = (Get-WmiObject Win32_Service -Filter "Name='$service'").StartName
$ver = (get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$service
$logPth = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\"+$ver+"\CPE"

$SQLAgentLogPath = (Get-ItemProperty -path $logPth).ErrorDumpDir
$SQLAGENT = $SQLAgentLogPath + "\SQLAGENT.OUT"

Get-ACL -Path $SQLAgentLogPath | Format-Table -Wrap 
Get-ACL -Path $SQLAGENT | Format-Table -Wrap 
