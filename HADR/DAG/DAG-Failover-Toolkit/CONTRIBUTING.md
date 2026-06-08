# Contributing

Thanks for your interest in improving the Distributed Availability Group failover toolkit.
This document describes how to set up, make changes, and submit them for review.

## Prerequisites

- **SQL Server** with a configured Distributed Availability Group for testing.  Always test
  against a non-production environment.
- **sqlcmd.exe** on the machine running the scripts.  SSMS sqlcmd mode is not supported.
- **PowerShell 5.1 or later** for the `.ps1` wrappers (`Invoke-DagFailover.ps1`,
  `Generate-DrLoginScripts.ps1`, `Check-DagSync.ps1`, and related scripts).
- **xp_cmdshell** access on the primary if you are exercising the DNS CNAME update path.
- **DnsServer PowerShell module** (optional) for automated DNS CNAME updates.

## Branch model

This repository uses a two-branch release model:

- `main` - release branch.  Protected.  No direct pushes.
- `dev` - integration branch.  Protected.  No direct pushes.

All work happens on short-lived topic branches cut from `dev`:

- `feature/<short-description>` for new functionality.
- `fix/<short-description>` for bug fixes.

Open a pull request from your topic branch into `dev`.  After it merges and is validated,
`dev` is promoted to `main` via a separate pull request.  Never commit directly to `dev` or
`main`, and never delete the `dev`, `main`, or `master` branches.

Use `git switch` and `git switch -c` rather than `git checkout` for changing or creating
branches.

## Coding standards

### PowerShell

- Every `.ps1` script must parse cleanly before it is committed.  Validate with the parser:

  ```powershell
  $errors = $null
  $tokens = $null
  [System.Management.Automation.Language.Parser]::ParseFile(
      "C:\path\to\script.ps1",
      [ref]$tokens,
      [ref]$errors
  )
  if ($errors.Count -gt 0) { $errors | ForEach-Object { Write-Error $_.Message } }
  ```

- Each script should carry a comment-based help block (`<# .SYNOPSIS ... #>`) above
  `[CmdletBinding()]`, with `.SYNOPSIS` present at minimum.
- When editing a script that already declares a `Param()` block, confirm no parameters were
  accidentally removed by diffing against the previous version.

### T-SQL

- Use explicit ANSI `JOIN` syntax.  Do not use deprecated comma joins.
- Use `/* ... */` block comments.  Do not use `--` line comments.
- Terminate every statement with a semicolon.
- Keep real server names, hostnames, IP addresses, and credentials out of committed scripts.
  The scripts read environment-specific values from parameters and `excluded-logins.txt`.

## Testing

Before opening a pull request, verify your change:

1. **Parse check** - all touched `.ps1` files parse with no errors.
2. **sqlcmd validation** - any `.sql` change runs through `sqlcmd` against a non-production
   Distributed AG.  Confirm the step you changed behaves as expected and that `StopAtStep`
   still aborts cleanly where applicable.
3. **Manual run** - exercise the affected workflow end to end where feasible.  For a
   non-destructive rehearsal, use `-Action Failback` with `StopAtStep` so the toolkit
   validates without cutting over.

Document what you tested in the pull request.

## Submitting a pull request

1. Create a topic branch off `dev`.
2. Make focused changes - one logical change per pull request.
3. Update documentation (`README.md`, parameter tables) when behavior changes.
4. Fill in the pull request template completely, including the testing and checklist
   sections.
5. Open the pull request against `dev` and request review.  At least one approval is
   required, conversations must be resolved, and stale approvals are dismissed on new pushes.

## Reporting issues

Use the issue templates for bug reports and feature requests.  Do not include real server
names, hostnames, IP addresses, or credentials in issue text or attached output.  For
security vulnerabilities, follow [SECURITY.md](SECURITY.md) instead of opening a public
issue.
