DECLARE @query varchar(1000),
 @dbname varchar(1000),
 @count int

 SET NOCOUNT ON

 DECLARE csr CURSOR FAST_FORWARD READ_ONLY
 FOR
 SELECT name
 FROM master.dbo.sysdatabases

 CREATE TABLE ##loginfo
 (
 dbname varchar(100),
 num_of_rows int)

 OPEN csr

 FETCH NEXT FROM csr INTO @dbname

 WHILE (@@fetch_status <> -1)
 BEGIN

     SET @query = 'DBCC loginfo (' + '''' + @dbname + ''') '
     EXEC (@query)
     SET @count = @@rowcount

     INSERT ##loginfo
     VALUES(@dbname, @count)

 FETCH NEXT FROM csr INTO @dbname

 END

 CLOSE csr
 DEALLOCATE csr

 SELECT dbname,
 num_of_rows
 FROM ##loginfo
 WHERE num_of_rows >= 50 --My rule of thumb is 50 VLFs. Your mileage may vary.
 ORDER BY num_of_rows DESC

DROP TABLE ##loginfo