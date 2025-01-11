/* Options to Move a Big SQL Server Database to a New Drive with Minimal Downtime:

1. The SQL Server Database Detach and Attach Method (THE BEST METHOD):
	a. DETACH USING GUI OR: sp_detach_db	b. MOVE THE DB FILE PHYSICALLY	c. ATTACH THE DB USING GUI OR: CREATE DATABASE FOR ATTACH (T-Sql)

2. The SQL Server Database Backup and Restore Method:
	a. perform full bkp		b. restore it WITH MOVE switch to specify the new file location.

3. The SQL Server OFFLINE Database Method:
	a. ALTER DATABASE SET SINGLE_USER	b. ALTER DATABASE SET OFFLINE	c. ALTER DATABASE MODIFY FILE (to move the files to new location).	
	d. MOVE THE DB FILE PHYSICALLY	e. ALTER DATABASE SET ONLINE.
*/