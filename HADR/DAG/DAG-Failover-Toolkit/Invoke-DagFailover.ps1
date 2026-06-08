<#
.SYNOPSIS
    Performs a Distributed Availability Group failover using sqlcmd.

.DESCRIPTION
    Wrapper for the distributed_ag_failover_main.sql script that replaces
    the legacy .cmd failover files with a single parameterized PowerShell
    script.  Supports both failover and failback via the Action parameter.

    Prompts for confirmation before executing unless -Confirm:$false or
    -Force is specified.

.PARAMETER DistributedAGName
    Name of the Distributed Availability Group to fail over.

.PARAMETER Primary
    Current primary replica in SERVER\INSTANCE or SERVER,PORT format.

.PARAMETER Secondary
    Current secondary replica (failover target) in SERVER\INSTANCE or
    SERVER,PORT format.

.PARAMETER SqlInstance
    The SQL Server instance to connect to with sqlcmd (-S).  Defaults to
    the Primary value.  Typically the CNAME or listener endpoint.

.PARAMETER DNSServer
    Hostname of the DNS server for CNAME updates.

.PARAMETER CName
    DNS CNAME alias to update after failover.

.PARAMETER DNSZone
    DNS zone containing the CNAME record.

.PARAMETER TTL
    DNS record TTL in seconds.  Default: 30.

.PARAMETER SyncWaitSeconds
    Seconds to wait for LSN hardening after switching to synchronous
    commit.  Default: 15.

.PARAMETER StopAtStep
    Stop execution after this step number.  Use 0 to stop immediately
    (validation only), 10 to run all steps.  Default: 10.

.PARAMETER Action
    Failover direction.  'Failover' completes the failover to the secondary.
    'Failback' returns to the original primary.

.PARAMETER EnableXPCmdShell
    When specified, automatically enables xp_cmdshell on the primary if
    it is not already enabled.  Required for automated DNS CNAME updates.

.PARAMETER SetToAsyncCommitAfterFailover
    When specified, resets both replicas to asynchronous commit after the
    failover completes.

.PARAMETER Force
    Suppresses the confirmation prompt.

.EXAMPLE
    .\Invoke-DagFailover.ps1 `
        -DistributedAGName "mb-db-in-azure" `
        -Primary "az1tmbdbvwprag\TMB" `
        -Secondary "az3tmbdbvwprag\TMB" `
        -SqlInstance "mb-db.corp.teranet.ca\TMB" `
        -DNSServer "stdns1.teranet.ca" `
        -CName "mb-db" `
        -DNSZone "corp.teranet.ca" `
        -Action Failover `
        -EnableXPCmdShell `
        -SetToAsyncCommitAfterFailover

    Fails over the mb-db-in-azure DAG from az1tmbdbvwprag to az3tmbdbvwprag.

.EXAMPLE
    .\Invoke-DagFailover.ps1 `
        -DistributedAGName "mb-db-in-azure" `
        -Primary "az3tmbdbvwprag\TMB" `
        -Secondary "az1tmbdbvwprag\TMB" `
        -SqlInstance "mb-db.corp.teranet.ca\TMB" `
        -DNSServer "stdns1.teranet.ca" `
        -CName "mb-db" `
        -DNSZone "corp.teranet.ca" `
        -Action Failover `
        -EnableXPCmdShell `
        -SetToAsyncCommitAfterFailover

    Fails over the mb-db-in-azure DAG from az3tmbdbvwprag back to
    az1tmbdbvwprag (reverse direction).

.NOTES
    Author:  Hannah Vernon
    Created: 2026-05-29
    Requires: sqlcmd.exe in PATH, PowerShell 7+
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (
    [Parameter(Mandatory)]
    [string]$DistributedAGName,

    [Parameter(Mandatory)]
    [string]$Primary,

    [Parameter(Mandatory)]
    [string]$Secondary,

    [Parameter()]
    [string]$SqlInstance,

    [Parameter(Mandatory)]
    [string]$DNSServer,

    [Parameter(Mandatory)]
    [string]$CName,

    [Parameter(Mandatory)]
    [string]$DNSZone,

    [Parameter()]
    [int]$TTL = 30,

    [Parameter()]
    [int]$SyncWaitSeconds = 15,

    [Parameter()]
    [ValidateRange(0, 10)]
    [int]$StopAtStep = 10,

    [Parameter(Mandatory)]
    [ValidateSet('Failover', 'Failback')]
    [string]$Action,

    [Parameter()]
    [switch]$EnableXPCmdShell,

    [Parameter()]
    [switch]$SetToAsyncCommitAfterFailover,

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

if (-not $SqlInstance)
{
    $SqlInstance = $Primary
}

$scriptDir = $PSScriptRoot
$mainScript = Join-Path $scriptDir 'distributed_ag_failover_main.sql'

if (-not (Test-Path $mainScript))
{
    Write-Error "Cannot find $mainScript.  Run this script from the DAG failover toolkit directory."
    return
}

$sqlcmdPath = Get-Command sqlcmd -ErrorAction SilentlyContinue
if (-not $sqlcmdPath)
{
    Write-Error "sqlcmd.exe is not in the PATH.  Install the SQL Server command-line utilities."
    return
}

$enableXpValue    = if ($EnableXPCmdShell)              { 'YES' } else { 'NO' }
$asyncCommitValue = if ($SetToAsyncCommitAfterFailover) { 'Yes' } else { 'No' }

$confirmMessage = @(
    "Distributed AG failover: $DistributedAGName"
    "  Direction:  $Primary -> $Secondary"
    "  Action:     $Action"
    "  SQL Instance: $SqlInstance"
    "  Stop at step: $StopAtStep"
) -join "`n"

if ($Force)
{
    $ConfirmPreference = 'None'
}

if (-not $PSCmdlet.ShouldProcess($confirmMessage, "Execute DAG $Action"))
{
    Write-Host 'Operation cancelled.' -ForegroundColor Yellow
    return
}

Write-Host ''
Write-Host "Starting DAG $Action for [$DistributedAGName]" -ForegroundColor Cyan
Write-Host "  Primary:   $Primary"
Write-Host "  Secondary: $Secondary"
Write-Host "  Instance:  $SqlInstance"
Write-Host ''

$sqlcmdArgs = @(
    '-i', $mainScript
    '-M'
    '-S', $SqlInstance
    '-v'
    "DistributedAGName=`"$DistributedAGName`""
    "Primary=`"$Primary`""
    "Secondary=`"$Secondary`""
    "DNSServer=`"$DNSServer`""
    "TTL=`"$TTL`""
    "CName=`"$CName`""
    "DNSZone=`"$DNSZone`""
    "EnableXPCmdShellIfRequired=`"$enableXpValue`""
    "StopAtStep=$StopAtStep"
    "SyncWaitSeconds=$SyncWaitSeconds"
    "SetToAsyncCommitAfterFailover=`"$asyncCommitValue`""
    "TestMode=$Action"
)

& sqlcmd @sqlcmdArgs
$exitCode = $LASTEXITCODE

Write-Host ''
if ($exitCode -eq 0)
{
    Write-Host 'sqlcmd completed successfully.' -ForegroundColor Green
}
else
{
    Write-Host "sqlcmd exited with code $exitCode." -ForegroundColor Red
}

Write-Host ''
$targetHost = if ($Action -eq 'Failover') { $Secondary } else { $Primary }
Write-Host "Verify that $CName.$DNSZone CNAME points at $targetHost." -ForegroundColor Yellow
Write-Host "If the automated DNS update did not run, ask the NOC to update it manually." -ForegroundColor Yellow
Write-Host ''
