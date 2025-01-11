/* https://docs.microsoft.com/en-us/answers/questions/80814/move-data-file-to-another-drive-in-ag.html

1- Fail over the AG so that this node becomes a secondary.

2- If it is set up be synchronous, change it to be asynchronous.

3- Run ALTER DATABASE MODIFY FILE to change the file location in the system table.

4- Stop the SQL SERVER SERVICE.

5- Move the file physically.

6- Start the SQL SERVER SERVICE.

7- Switch back the replica to be synchronous.
*/

ALTER DATABASE DRTEST   
    MODIFY FILE (NAME = DRTEST,   
                 FILENAME = 'L:\APP_LOG\DRTEST.mdf');  
GO
ALTER DATABASE DRTEST   
    MODIFY FILE (NAME = DRTEST_LOG,   
                 FILENAME = 'D:\APP_DATA\DRTEST_log.ldf');  
GO