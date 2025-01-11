-- https://www.pigeonsql.com/single-post/downgrade-sql-server-edition-by-inplace
SELECT name, physical_name  AS current_file_location
FROM sys.master_files
WHERE database_id != 2
--=================================================================================
/*
Shutdown the SQL Server and Copy System Database apart from TempDB 
Copy master, model and msdb - Datafile(.mdf) and Log files(.ldf) to New Location for backup, because system databases will be removed after uninstallation from original folder!!!
====================================================================
Uninstall SQL Server
=============================================
Restart Server
=============================================
Install Developer Edition and Patches
•Make sure that Data and Log folder is set to correct location  
•Open SSMS and, Expand databases, Security,Logins, Jobs, etc… Should be looks like a fresh copy of SQL Server.
===========================================================
Shutdown the SQL server and copy the system database (Master, Model and MSDB)
•  Copy master, model and msdb - Datafile(.mdf) and Log files(.ldf) to original location where was installed.
===============================================================================
Start SQL Server
Open management Studio, Expand databases, Security, Logins, Jobs, etc… Everything should look like before uninstallation!!!
*/