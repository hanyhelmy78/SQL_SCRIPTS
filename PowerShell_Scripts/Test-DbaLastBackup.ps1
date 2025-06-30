Install-Module Dbatools
Import-Module Dbatools
Set-DbatoolsConfig -FullName sql.connection.trustcert -Value $true -register
Test-DbaLastBackup -SqlInstance . | Out-GridView