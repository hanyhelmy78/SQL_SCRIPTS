After learning from our life lesson, we realize that taking backups from the system database is inevitable.

This is the second solution to resolve the master database corruption issue: restoring the recent backup of the master, msdb, and model databases.

After completing all the steps from the link below

[Rebuilding master database after the recovery from corruption](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/Instance/S10_Master_Database_Corruption.md)

We now need to open the SQL server in single-user mode.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MasterCorruption_04.png)

Next, open a new session to restore the master database.

After the master has been restored, SQL Server will shut down immediately.

Then start it up again, and restore the msdb and model databases.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/MasterCorruption_05.png)

