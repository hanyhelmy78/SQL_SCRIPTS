# How to Automatically Validate SQL Server Backups With Test-DbaLastBackup (Dbatools)
# https://straightpathsql.com/archives/2025/06/how-to-automatically-validate-sql-server-backups-with-test-dbalastbackup-dbatools/
Install-Module Dbatools
Import-Module Dbatools
Set-DbatoolsConfig -FullName sql.connection.trustcert -Value $true -register
Test-DbaLastBackup -SqlInstance . | Out-GridView
