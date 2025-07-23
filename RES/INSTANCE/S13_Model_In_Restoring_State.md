If the `model` database was stuck in `restoring` mode and you restarted the SQL Server.

Please follow the steps below:

1. Start SQL Server with trace flag `T3608` to skip the recovery of all databases except the `master` database.
2. `Don't` start SQL Server in `single user` mode as it restricts you to restoring only the `master` database.

```powershell
C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn> .\sqlservr.exe -s "mssqlserver" -c -T3608

```

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/ModelRestoring_01.png)
   
3. Open a new `CMD` session to access SQL Server and `restore` the `model` database `with recovery`.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/ModelRestoring_02.png)
![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/ModelRestoring_03.png)

4. `Start` SQL Server normally.

```bash
net start mssqlserver

```
