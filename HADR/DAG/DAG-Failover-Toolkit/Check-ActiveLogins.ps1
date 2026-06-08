<#
.SYNOPSIS
    Lists active user sessions with KILL commands, excluding logins
    listed in excluded-logins.txt.

.DESCRIPTION
    Queries sys.dm_exec_sessions and sys.dm_exec_connections for active
    user processes, filtering out NT SERVICE/SYSTEM accounts and any
    logins listed in the excluded-logins.txt file.  Each login name is
    validated against a strict character whitelist before being included
    in the query to prevent SQL injection.

.PARAMETER SqlInstance
    The SQL Server instance to query (e.g., "myserver\INST1").

.PARAMETER ExcludedLoginsFile
    Path to the exclusion file.  Defaults to excluded-logins.txt in the
    script directory.  Format: login_name | reason (pipe and reason are
    optional).  Lines starting with # are comments.

.EXAMPLE
    .\Check-ActiveLogins.ps1 -SqlInstance "myserver\INST1"

.EXAMPLE
    .\Check-ActiveLogins.ps1 -SqlInstance "myserver\INST1" -ExcludedLoginsFile "C:\config\logins.txt"
#>
[CmdletBinding()]
param
(
    [Parameter(Mandatory)]
    [string]$SqlInstance

  , [string]$ExcludedLoginsFile = (Join-Path $PSScriptRoot 'excluded-logins.txt')
)

$scriptDir = $PSScriptRoot;

# Read and validate excluded logins
$excludedLogins = @();
if (Test-Path $ExcludedLoginsFile)
{
    $excludedLogins = Get-Content $ExcludedLoginsFile |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -ne '' -and -not $_.StartsWith('#') } |
        ForEach-Object { ($_ -split '\|')[0].Trim() };

    foreach ($login in $excludedLogins)
    {
        if ($login -notmatch '^[\w\\.\-\$ ]+$')
        {
            Write-Error "Invalid login name in exclusion file: '$login'";
            return;
        }
    }

    Write-Verbose "Excluding $($excludedLogins.Count) login(s) from report.";
}
else
{
    Write-Verbose "No exclusion file found at '$ExcludedLoginsFile'; no logins excluded.";
}

# Build the query
$queryLines = @(
    "SET NOCOUNT ON;"
    ""
    "CREATE TABLE #excluded_logins ([login_name] sysname NOT NULL);"
);

foreach ($login in $excludedLogins)
{
    $safe = $login -replace "'", "''";
    $queryLines += "INSERT INTO #excluded_logins ([login_name]) VALUES (N'$safe');";
}

$queryLines += @(
    ""
    "SELECT"
    "      [des].[login_name]"
    "    , [des].[original_login_name]"
    "    , [des].[program_name]"
    "    , [dec].[client_net_address]"
    "    , [kill_command] = N'KILL ' + CONVERT(nvarchar(11), [des].[session_id])"
    "FROM sys.dm_exec_connections AS [dec]"
    "    INNER JOIN sys.dm_exec_sessions AS [des]"
    "        ON [dec].[session_id] = [des].[session_id]"
    "WHERE"
    "    [des].[is_user_process] = 1"
    "    AND [des].[login_name] NOT LIKE N'NT %|\%' ESCAPE N'|'"
    "    AND NOT EXISTS"
    "    ("
    "        SELECT"
    "            1"
    "        FROM"
    "            #excluded_logins AS [ex]"
    "        WHERE"
    "            [ex].[login_name] = [des].[login_name]"
    "    )"
    "GROUP BY"
    "      [des].[login_name]"
    "    , [des].[original_login_name]"
    "    , [des].[program_name]"
    "    , [dec].[client_net_address]"
    "    , [des].[session_id];"
    ""
    "DROP TABLE #excluded_logins;"
);

$query = $queryLines -join "`r`n";

# Write to temp file and execute via sqlcmd
$tempFile = Join-Path ([System.IO.Path]::GetTempPath()) "check-active-logins-$([System.Guid]::NewGuid().ToString('N').Substring(0,8)).sql";
[System.IO.File]::WriteAllText($tempFile, $query);

try
{
    Write-Debug "sqlcmd -S $SqlInstance -i $tempFile";
    sqlcmd -S $SqlInstance -i $tempFile;
    $exitCode = $LASTEXITCODE;
    if ($exitCode -ne 0)
    {
        Write-Error "sqlcmd exited with code $exitCode.";
    }
}
finally
{
    Remove-Item $tempFile -ErrorAction SilentlyContinue;
}
