```sql

ALTER DATABASE [AdventureWorks2019] SET ONLINE
/*
Error message:
Msg 5118, Level 16, State 1, Line 1
The file "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019.mdf" 
is compressed but does not reside in a read-only database or filegroup. The file must be decompressed.

```

Decompression cannot be completed because the file is currently in use.

![alt text](https://github.com/MohamedAbdelhalem/dbatools/blob/main/Features_and_Administration/RES/media/compress_file.png)

If you attempt to set the database offline.

```sql
ALTER DATABASE [AdventureWorks2019] SET OFFLINE
GO
```

You will receive an error due to the database being involved in mirroring (AG).

Open `sqlcmd` and connect to any node. Then, execute the following command:

```sql
:CONNECT SQLSERVERVM01
ALTER AVAILABILITY GROUP [AG] REMOVE DATABASE [AdventureWorks2019];
GO
ALTER DATABASE [AdventureWorks2019] SET OFFLINE
GO
```
Decompress the data file again, then execute the following commands:

```sql
:CONNECT SQLSERVERVM01
ALTER DATABASE [AdventureWorks2019] SET ONLINE
GO
ALTER AVAILABILITY GROUP [AG] ADD DATABASE [AdventureWorks2019];
GO
:CONNECT SQLSERVERVM02
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO
:CONNECT SQLSERVERVM03
ALTER DATABASE [AdventureWorks2019] SET HADR AVAILABILITY GROUP = [AG]
GO
```

