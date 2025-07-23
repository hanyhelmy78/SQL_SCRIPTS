If you are experiencing an issue with the `mssqlsystemresource` system database, you have multiple approaches to resolve it.

You will encounter the following error:
![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/mssqlsystemresource_01.png)

### The first solution is to take the `mssqlsystemresource` database from another secondary replica for the sake of using Always-On.


> [!Note]
> Go to this directory `C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn` to copy the **mssqlsystemresource.mdf** and **mssqlsystemresource.ldf** for `mssqlsystemresource` database.
> This approach is **faster** and more **recommended**.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/mssqlsystemresource_02.png)

### The second solution is to repair the system databases.

> [!Note]
> *Don't use* `setup.exe` from **Bootstrap** folder `C:\Program Files\Microsoft SQL Server\150\Setup Bootstrap\SQL2019`.


> [!TIP]
> *Use* the `SQL Server installation media` **ISO**.

This approach will take some time, unlike taking `mssqlsystemresource` database files from another replica.

```cmd
setup.exe /q /ACTION=Repair /INSTANCENAME=MSSQLSERVER
```

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/mssqlsystemresource_03.png)
