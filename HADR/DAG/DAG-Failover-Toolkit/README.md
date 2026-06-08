# Hannah Vernon's Distributed Availability Group Failover Toolkit

Automated failover scripts for SQL Server Distributed Availability Groups (DAGs), designed for planned DR testing and production failover scenarios.

## Overview

This toolkit provides a step-by-step, parameterized failover process driven entirely through `sqlcmd`.  Each step is isolated into its own `.sql` file and orchestrated by `distributed_ag_failover_main.sql`, which uses sqlcmd's `:r` include directive to chain them together.

The process:

1. Validates the current primary node
2. Switches the DAG to synchronous commit (both replicas)
3. Confirms synchronous commit is active
4. Waits for LSN hardening, then verifies LSN parity across replicas
5. Disables client access by demoting the primary to SECONDARY role
6. Fails back to the original primary (if `TestMode = Failback`)
7. Fails over to the secondary (if `TestMode = Failover`)
8. Resets to asynchronous commit (optional)
9. Verifies post-failover LSN state and updates DNS CNAME

## Prerequisites

- **SQL Server** with a configured Distributed Availability Group
- **sqlcmd.exe** on the machine running the scripts (SSMS sqlcmd mode is not supported)
- **xp_cmdshell** access on the primary for DNS CNAME updates (the script can enable it automatically via the `EnableXPCmdShellIfRequired` parameter)
- **DnsServer PowerShell module** (optional) for automated DNS CNAME updates.  If not installed, the script prints the manual command instead.

## Files

File | Purpose
-----|--------
`distributed_ag_failover_main.sql` | Orchestrator.  Chains all steps via `:r` includes.  Accepts sqlcmd variables.
`distributed_ag_failover_step_01.sql` | Validates the specified primary is the actual DAG primary
`distributed_ag_failover_step_02_synchronous_commit.sql` | Sets both replicas to SYNCHRONOUS_COMMIT
`distributed_ag_failover_step_03_confirm_synchronous_commit.sql` | Confirms synchronous commit is active on both replicas
`distributed_ag_failover_step_04_confirm_committed_lsn.sql` | Waits for LSN hardening, generates LSN comparison files
`distributed_ag_failover_step_04a_confirm_committed_lsn.sql` | Compares LSN values across replicas and reports status
`distributed_ag_failover_step_05_disable_access_to_distributed_ag.sql` | Demotes the primary to SECONDARY, disabling client access
`distributed_ag_failover_step_06_failback_if_needed.sql` | Fails back to the original primary (TestMode = Failback only)
`distributed_ag_failover_step_07_failover.sql` | Completes failover to the secondary (TestMode = Failover only)
`distributed_ag_failover_step_08_reset_to_async_commit.sql` | Resets both replicas to ASYNCHRONOUS_COMMIT (optional)
`distributed_ag_failover_step_09_finished.sql` | Re-verifies LSN state and updates the DNS CNAME
`parse_server_names.sql` | Shared include: extracts bare hostnames from `$(Primary)` and `$(Secondary)` sqlcmd variables
`is_xp_cmdshell_enabled.sql` | Checks and optionally enables xp_cmdshell
`Check-ActiveLogins.ps1` | Lists active user sessions with KILL commands, excluding logins from `excluded-logins.txt`
`excluded-logins.sample.txt` | Sample exclusion list (pipe-delimited: `login | reason`).  Copy to `excluded-logins.txt` for your environment
`excluded-logins.txt` | Your site-specific exclusion list.  Git-ignored so real login names are never committed
`Generate-DrLoginScripts.ps1` | Generates DISABLE/ENABLE login scripts for DR testing, excluding logins from `excluded-logins.txt`
`Check-DagSync.ps1` | Quick check of which server each endpoint resolves to and current LSN status (replaces `check-sync.cmd`)
`failover_from_primary_to_secondary.cmd` | Legacy wrapper to fail over from the primary to the secondary
`failover_from_secondary_to_primary.cmd` | Legacy wrapper to fail over from the secondary back to the primary
`Invoke-DagFailover.ps1` | PowerShell 7 replacement for both .cmd files.  Parameterized, with confirmation prompt and tab completion.
`lsn-primary.sql` | Generated at runtime by step 04; excluded via `.gitignore`
`lsn-secondary.sql` | Generated at runtime by step 04; excluded via `.gitignore`

## Parameters

The main script accepts these sqlcmd variables via the `-v` flag:

Parameter | Description
----------|------------
`DistributedAGName` | Name of the Distributed Availability Group
`Primary` | Current primary replica (e.g., `YOURSERVER1\INSTANCE`)
`Secondary` | Current secondary / failover target (e.g., `YOURSERVER2\INSTANCE`)
`SyncWaitSeconds` | Seconds to wait for LSN hardening after switching to synchronous commit
`SetToAsyncCommitAfterFailover` | `YES` to reset to async commit after failover; omit to leave synchronous
`DNSServer` | DNS server hostname for CNAME updates
`TTL` | DNS record TTL in seconds
`CName` | DNS CNAME alias to update
`DNSZone` | DNS zone name
`EnableXPCmdShellIfRequired` | `YES` to auto-enable xp_cmdshell if not already enabled
`StopAtStep` | Stop execution after this step number (0 = stop immediately, 10 = run all steps)
`TestMode` | `Failback` to return to the original primary, `Failover` to complete the failover.  The PowerShell wrapper exposes this as `-Action`.

## Usage

### Pre-failover: disable application logins

Run `Generate-DrLoginScripts.ps1 -SqlInstance "<primary>"`.  Copy the DISABLE section from its output and execute it against the primary to prevent application connections during failover.

### Running the failover

**PowerShell 7 (recommended):**

```powershell
.\Invoke-DagFailover.ps1 `
    -DistributedAGName "MyDistributedAG" `
    -Primary "YOURSERVER1\INSTANCE" `
    -Secondary "YOURSERVER2\INSTANCE" `
    -SqlInstance "sqlag.example.com\INSTANCE" `
    -DNSServer "dc01.example.com" `
    -CName "sqlag" `
    -DNSZone "example.com" `
    -Action Failover `
    -EnableXPCmdShell `
    -SetToAsyncCommitAfterFailover
```

To reverse direction, swap the `-Primary` and `-Secondary` values.

To suppress the confirmation prompt, add `-Force`.

**Legacy CMD (deprecated):**

```cmd
sqlcmd -i distributed_ag_failover_main.sql ^
  -S sqlag.example.com\INSTANCE ^
  -M ^
  -v DistributedAGName = "MyDistributedAG" ^
     Primary = "YOURSERVER1\INSTANCE" ^
     Secondary = "YOURSERVER2\INSTANCE" ^
     DNSServer = "dc01.example.com" ^
     TTL = "30" ^
     CName = "sqlag" ^
     DNSZone = "example.com" ^
     EnableXPCmdShellIfRequired = "YES" ^
     StopAtStep = 10 ^
     SyncWaitSeconds = 15 ^
     SetToAsyncCommitAfterFailover = "Yes" ^
     TestMode = Failover
```

### Post-failover: re-enable application logins

Run the ENABLE section (from `Generate-DrLoginScripts.ps1` output) against the new primary to restore application access.

### DR rehearsal (validate without cutting over)

1. Disable logins on the current primary
2. Run with `-Action Failback` to execute the full preparation (steps 1-5) and then return to the original primary at step 6
3. Re-enable logins

This validates sync, LSN parity, and DNS without moving production.

### DR test (full failover and return)

1. Disable logins on the current primary
2. Run with `-Action Failover` to fail over to the secondary
3. Validate application connectivity on the new primary
4. Run again with Primary/Secondary swapped and `-Action Failover` to return to the original server
5. Re-enable logins on the restored primary

### Stepping through

Use `StopAtStep` to pause execution at any point.  This is useful for verifying intermediate state during a DR rehearsal:

```cmd
REM Stop after confirming synchronous commit (step 3)
... StopAtStep = 3 ...
```

## Login Management

`Generate-DrLoginScripts.ps1` queries `sys.server_principals` at runtime and produces up-to-date DISABLE and ENABLE scripts, so there is no static login list to maintain in the repository.

Logins to exclude (DBA accounts, AG service accounts) are listed in `excluded-logins.txt` (`login | reason`, one per line).  That file is git-ignored so site-specific login names are never committed; copy `excluded-logins.sample.txt` to get started.  Excluded logins are printed as comments in the generated output for auditability.

## Understanding the `-Action` Parameter

The `-Action` parameter (mapped to the `TestMode` sqlcmd variable) controls what happens **after** steps 1-5 complete.  Steps 1-5 always run regardless of the action value: they validate the AG state, switch to synchronous commit, confirm LSN parity, and demote the primary.

Action | What it does | Use case
-------|-------------|----------
`Failover` | Promotes the **secondary** to primary (step 7).  Production moves to the other server. | Planned DR failover or real disaster recovery.
`Failback` | Re-promotes the **original primary** (step 6).  Production stays on the same server. | DR rehearsal: validates the full preparation process (sync, LSN parity, DNS) without actually cutting over.

### Failback is not an undo mechanism

`-Action Failback` is **not** a recovery option for a failed `-Action Failover` run.  Because the script always starts from step 1, running it again with `Failback` would attempt to re-execute the full preparation sequence against an AG that may already be in a partially reconfigured state.

If a failover fails partway through (for example, step 5 demotes the primary but step 7 fails to promote the secondary), the Distributed AG will be in an indeterminate state that requires manual assessment and recovery.  Use `StopAtStep` during rehearsals to validate each step individually before running the full sequence.

## How It Works

### Data loss prevention

Distributed AGs only support `FORCE_FAILOVER_ALLOW_DATA_LOSS`; planned failover is not available.  To ensure zero data loss despite this, the toolkit:

1. Switches both replicas to synchronous commit (step 2)
2. Waits for the configured `SyncWaitSeconds` to allow in-flight transactions to harden (step 4)
3. Compares `last_hardened_lsn` across all databases on both replicas (step 4a)
4. Aborts if any LSN mismatch is detected

Only after LSN parity is confirmed does the script proceed to demote the primary and execute the failover.

### DNS CNAME update

Step 9 attempts to update the DNS CNAME automatically via the PowerShell `DnsServer` module and `xp_cmdshell`.  If the module is not installed on the SQL Server host, the script prints the equivalent `Add-DnsServerResourceRecordCName` command for manual execution.

## Author

Hannah Vernon, 2022
