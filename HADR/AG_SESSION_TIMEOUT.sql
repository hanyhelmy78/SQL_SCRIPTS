/*
https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/availability-groups/troubleshooting-intermittent-connection-timeouts-availability-groups
What else can I do to mitigate the connection time-outs?
The default availability group, SESSION_TIMEOUT is configured for 10 seconds. You might be able to mitigate the connection time-outs by adjusting the availability group replica SESSION_TIMEOUT property. This setting is per replica. **Adjust it for the primary and each affected secondary replica**. Here's an example of the syntax. The default SESSION_TIMEOUT value is 10. Therefore, you could use 15 as the next value.
*/
ALTER AVAILABILITY GROUP ag
MODIFY REPLICA ON 'SQL19AGN1' WITH (SESSION_TIMEOUT = 15);