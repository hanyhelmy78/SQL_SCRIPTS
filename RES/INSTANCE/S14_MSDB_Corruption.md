### When your `msdb` database is in recovery pending, you may be experiencing system database corruption.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MSDBCorruption_01.png)

### However, The SQL Agent remains operational.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MSDBCorruption_02.png)

### To resolve this issue:

1. Stop the SQL Agent service.
2. Restore msdb database from your good backup to avoid rebuilding the databases.
3. Enable service broker on msdb for asynchronous tasks like mail delivery.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MSDBCorruption_03.png)

4. Enabling the service broker may encounter some blocking because it requires a session-free environment.
5. Terminate the blocked session if it exists.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MSDBCorruption_04.png)

6. Start the SQL Agent service.

