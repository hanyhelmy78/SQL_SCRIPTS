If you encounter a `model` database corruption, you will see this error in the event viewer or the SQL log.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/ModelCorruption_01.png)

Database corruption in the `model` database will prevent the instance from starting up, as SQL lacks the template to create the `Tempdb` database.

You can't open the instance using minimal configuration, because it must recover the model database and in this case we don't have a good one.

```bash
<SQL Server Binn directory>\sqlservr.exe -f -m ”SQLCMD” -s "MSSQLSERVER" -c
```

### To address this issue, you have two solutions.
1. Rebuilding the databases as we did before (see the link below) is not recommended. This method takes a long time to recover the instance, and without good, updated backups from master and msdb, you risk losing some credentials or jobs.

[Rebuilding master database after the recovery from corruption](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/Instance/S10_Master_Database_Corruption.md)

2. Use the `model` database from the template folder. Under the `Binn` folder, there is a sub-folder called `template`. After replacing the files, you can start SQL Server with `minimal configuration` **`-f`**, `single user` **`-m`**, and `skip service checks when starting from the command prompt` **`-c`** to restore the model database from a good backup or change it later.

```bash
cd "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn"

sqlservr.exe -f -m "SQLCMD" -s "MSSQLSERVER" -c

```
