<#
.SYNOPSIS
    Quick check of which server each endpoint resolves to and current
    LSN synchronization status.

.PARAMETER Primary
    Current primary replica in SERVER\INSTANCE or SERVER.domain\INSTANCE format.

.PARAMETER Secondary
    Current secondary replica in SERVER\INSTANCE or SERVER.domain\INSTANCE format.

.PARAMETER SqlInstance
    The SQL Server instance to connect to with sqlcmd (-S).  Defaults to
    the Primary value.  Typically the CNAME or listener endpoint.

.EXAMPLE
    .\Check-DagSync.ps1 `
        -Primary "az1tmbdbvwprag\TMB" `
        -Secondary "az3tmbdbvwprag\TMB" `
        -SqlInstance "mb-db.corp.teranet.ca\TMB"

.NOTES
    Author:  Hannah Vernon
    Requires: sqlcmd.exe in PATH
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$Primary,

    [Parameter(Mandatory)]
    [string]$Secondary,

    [Parameter()]
    [string]$SqlInstance
)

$ErrorActionPreference = 'Stop'

if (-not $SqlInstance)
{
    $SqlInstance = $Primary
}

$sqlcmdPath = Get-Command sqlcmd -ErrorAction SilentlyContinue
if (-not $sqlcmdPath)
{
    Write-Error "sqlcmd.exe is not in the PATH.  Install the SQL Server command-line utilities."
    return
}

$endpoints = @(
    @{ Label = $SqlInstance; Server = $SqlInstance }
    @{ Label = $Primary;     Server = $Primary }
    @{ Label = $Secondary;   Server = $Secondary }
)

foreach ($ep in $endpoints)
{
    $label = ($ep.Label + ' is running on:').PadRight(50)
    $query = "SET NOCOUNT ON; PRINT N'$label ' + CONVERT(nvarchar(30), @@SERVERNAME, 0);"
    Write-Debug "sqlcmd -S $($ep.Server) -M -Q `"$query`""
    & sqlcmd -S $ep.Server -M -Q $query
}

$scriptDir = $PSScriptRoot
$stepScript = Join-Path $scriptDir 'distributed_ag_failover_step_04_confirm_committed_lsn.sql'

if (-not (Test-Path $stepScript))
{
    Write-Error "Cannot find $stepScript.  Run this script from the DAG failover toolkit directory."
    return
}

$sqlcmdArgs = @(
    '-M'
    '-S', $Primary
    '-b'
    '-i', $stepScript
    '-v'
    "SyncWaitSeconds=0"
    "Primary=`"$Primary`""
    "Secondary=`"$Secondary`""
)
Write-Debug "sqlcmd $($sqlcmdArgs -join ' ')"

& sqlcmd @sqlcmdArgs

$exitCode = $LASTEXITCODE
if ($exitCode -ne 0)
{
    Write-Host "sqlcmd exited with code $exitCode." -ForegroundColor Red
}
