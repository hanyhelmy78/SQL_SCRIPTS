# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this toolkit, please report it privately so it
can be addressed before public disclosure.

- **Email:** vuln@mvct.com
- Please include a description of the vulnerability, the affected file(s), and steps to
  reproduce if possible.
- Do **not** open a public issue for security vulnerabilities.

You can expect an acknowledgement within a few business days.  Once the issue is confirmed,
a fix will be prepared and you will be credited (unless you prefer to remain anonymous).

## Scope

This toolkit executes privileged operations against SQL Server Distributed Availability
Groups, including forced failover and login management.  Please pay particular attention to:

- Credential handling and connection string construction
- `xp_cmdshell` enablement and DNS update logic
- Any code path that constructs and executes dynamic SQL or shell commands

## Supported Versions

Security fixes are applied to the `main` branch.  There are no separately maintained release
branches at this time.
