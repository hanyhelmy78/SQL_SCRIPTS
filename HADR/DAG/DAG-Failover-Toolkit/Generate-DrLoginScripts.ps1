<#
.SYNOPSIS
    Generates ALTER LOGIN DISABLE/ENABLE scripts for DR testing.

.DESCRIPTION
    Queries sys.server_principals and generates DISABLE and ENABLE
    scripts for all user logins, excluding those listed in
    excluded-logins.txt.  Windows groups use REVOKE/GRANT CONNECT SQL
    (they cannot be disabled).  All other application logins use
    ALTER LOGIN DISABLE/ENABLE.

    Output goes to stdout via PRINT so you can copy the block directly
    into a new query window.

.PARAMETER SqlInstance
    The SQL Server instance to query (e.g., "myserver\INST1").

.PARAMETER ExcludedLoginsFile
    Path to the exclusion file.  Defaults to excluded-logins.txt in the
    script directory.  Format: login_name | reason (pipe and reason are
    optional).  Lines starting with # are comments.

.EXAMPLE
    .\Generate-DrLoginScripts.ps1 -SqlInstance "myserver\INST1"

.EXAMPLE
    .\Generate-DrLoginScripts.ps1 -SqlInstance "myserver\INST1" | Out-File "dr-logins.sql"
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
$entries = @();
if (Test-Path $ExcludedLoginsFile)
{
    $rawLines = Get-Content $ExcludedLoginsFile |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -ne '' -and -not $_.StartsWith('#') };

    foreach ($line in $rawLines)
    {
        $parts  = $line -split '\|', 2;
        $login  = $parts[0].Trim();
        $reason = if ($parts.Count -gt 1) { $parts[1].Trim() } else { 'No reason specified' };

        if ($login -notmatch '^[\w\\.\-\$ ]+$')
        {
            Write-Error "Invalid login name in exclusion file: '$login'";
            return;
        }
        if ($reason -notmatch '^[\w\\.\-\$,:;() /]+$')
        {
            Write-Error "Invalid reason text in exclusion file: '$reason'";
            return;
        }

        $entries += [PSCustomObject]@{ Login = $login; Reason = $reason };
    }

    Write-Verbose "Excluding $($entries.Count) login(s) from DR scripts.";
}
else
{
    Write-Verbose "No exclusion file found at '$ExcludedLoginsFile'; no logins excluded.";
}

# Build the query
$queryLines = @(
    "SET NOCOUNT ON;"
    ""
    "CREATE TABLE #exclude"
    "("
    "      [login_name] sysname       NOT NULL PRIMARY KEY"
    "    , [reason]     nvarchar(128) NOT NULL"
    ");"
);

foreach ($entry in $entries)
{
    $safeLogin  = $entry.Login  -replace "'", "''";
    $safeReason = $entry.Reason -replace "'", "''";
    $queryLines += "INSERT INTO #exclude ([login_name], [reason]) VALUES (N'$safeLogin', N'$safeReason');";
}

$queryLines += @(
    ""
    "DECLARE @statement nvarchar(512);"
    "DECLARE @rows      int;"
    "DECLARE @cur       CURSOR;"
    ""
    "/* Print excluded logins as a comment block */"
    "DECLARE @print_excluded_logins CURSOR;"
    ""
    "SET @print_excluded_logins = CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR"
    "    SELECT"
    "        N'/* EXCLUDED: ' + QUOTENAME([ex].[login_name])"
    "        + N' - ' + [ex].[reason] + N' */'"
    "    FROM"
    "        #exclude AS [ex]"
    "    ORDER BY"
    "        [ex].[login_name];"
    ""
    "/* ===== DISABLE LOGINS ===== */"
    ""
    "PRINT N'/* ============================================= */';"
    "PRINT N'/* DISABLE LOGINS - Run before DR test           */';"
    "PRINT N'/* ============================================= */';"
    "PRINT N'';"
    "PRINT N'/* The following logins are intentionally excluded: */';"
    ""
    "OPEN @print_excluded_logins;"
    "SET @rows = @@CURSOR_ROWS;"
    ""
    "WHILE @rows > 0"
    "BEGIN"
    "    FETCH NEXT FROM @print_excluded_logins INTO @statement;"
    "    PRINT @statement;"
    "    SET @rows = @rows - 1;"
    "END;"
    ""
    "CLOSE @print_excluded_logins;"
    ""
    "PRINT N'';"
    ""
    "SET @cur = CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR"
    "    SELECT"
    "        CASE"
    "            WHEN [sp].[type_desc] = N'WINDOWS_GROUP'"
    "            THEN N'REVOKE CONNECT SQL FROM ' + QUOTENAME([sp].[name]) + N';'"
    "            ELSE N'ALTER LOGIN ' + QUOTENAME([sp].[name]) + N' DISABLE;'"
    "        END"
    "    FROM"
    "        [sys].[server_principals] AS [sp]"
    "    WHERE"
    "        [sp].[type] IN (N'S', N'U', N'G')"
    "        AND [sp].[is_disabled] = 0"
    "        AND [sp].[name] NOT LIKE N'##%'"
    "        AND [sp].[name] NOT LIKE N'NT AUTHORITY\%'"
    "        AND [sp].[name] NOT LIKE N'NT SERVICE\%'"
    "        AND NOT EXISTS"
    "        ("
    "            SELECT"
    "                1"
    "            FROM"
    "                #exclude AS [ex]"
    "            WHERE"
    "                [ex].[login_name] = [sp].[name]"
    "        )"
    "        AND [sp].[principal_id] > 1"
    "    ORDER BY"
    "        [sp].[name];"
    ""
    "OPEN @cur;"
    "SET @rows = @@CURSOR_ROWS;"
    ""
    "WHILE @rows > 0"
    "BEGIN"
    "    FETCH NEXT FROM @cur INTO @statement;"
    "    PRINT @statement;"
    "    SET @rows = @rows - 1;"
    "END;"
    ""
    "CLOSE @cur;"
    "DEALLOCATE @cur;"
    ""
    "PRINT N'';"
    "PRINT N'';"
    ""
    "/* ===== ENABLE LOGINS ===== */"
    ""
    "PRINT N'/* ============================================= */';"
    "PRINT N'/* ENABLE LOGINS - Run after DR test              */';"
    "PRINT N'/* ============================================= */';"
    "PRINT N'';"
    "PRINT N'/* The following logins are intentionally excluded: */';"
    ""
    "OPEN @print_excluded_logins;"
    "SET @rows = @@CURSOR_ROWS;"
    ""
    "WHILE @rows > 0"
    "BEGIN"
    "    FETCH NEXT FROM @print_excluded_logins INTO @statement;"
    "    PRINT @statement;"
    "    SET @rows = @rows - 1;"
    "END;"
    ""
    "CLOSE @print_excluded_logins;"
    "DEALLOCATE @print_excluded_logins;"
    ""
    "PRINT N'';"
    ""
    "SET @cur = CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR"
    "    SELECT"
    "        CASE"
    "            WHEN [sp].[type_desc] = N'WINDOWS_GROUP'"
    "            THEN N'GRANT CONNECT SQL TO ' + QUOTENAME([sp].[name]) + N';'"
    "            ELSE N'ALTER LOGIN ' + QUOTENAME([sp].[name]) + N' ENABLE;'"
    "        END"
    "    FROM"
    "        [sys].[server_principals] AS [sp]"
    "    WHERE"
    "        [sp].[type] IN (N'S', N'U', N'G')"
    "        AND [sp].[is_disabled] = 0"
    "        AND [sp].[name] NOT LIKE N'##%'"
    "        AND [sp].[name] NOT LIKE N'NT AUTHORITY\%'"
    "        AND [sp].[name] NOT LIKE N'NT SERVICE\%'"
    "        AND NOT EXISTS"
    "        ("
    "            SELECT"
    "                1"
    "            FROM"
    "                #exclude AS [ex]"
    "            WHERE"
    "                [ex].[login_name] = [sp].[name]"
    "        )"
    "        AND [sp].[principal_id] > 1"
    "    ORDER BY"
    "        [sp].[name];"
    ""
    "OPEN @cur;"
    "SET @rows = @@CURSOR_ROWS;"
    ""
    "WHILE @rows > 0"
    "BEGIN"
    "    FETCH NEXT FROM @cur INTO @statement;"
    "    PRINT @statement;"
    "    SET @rows = @rows - 1;"
    "END;"
    ""
    "CLOSE @cur;"
    "DEALLOCATE @cur;"
    ""
    "DROP TABLE #exclude;"
);

$query = $queryLines -join "`r`n";

# Write to temp file and execute via sqlcmd
$tempFile = Join-Path ([System.IO.Path]::GetTempPath()) "generate-dr-logins-$([System.Guid]::NewGuid().ToString('N').Substring(0,8)).sql";
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
