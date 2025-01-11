DECLARE @DBName AS NVARCHAR(100),
          @LogFileName AS NVARCHAR(100),
          @exec_stmt nvarchar(625)
       SET NOCOUNT ON
       -----------------------------------------------------------------------------
      --create the temporary table to hold the log file names
      -----------------------------------------------------------------------------
      CREATE TABLE #logfiles
      (
          dbname NVARCHAR(100),
          filename NVARCHAR(100),
      )
    -----------------------------------------------------------------------------
      --select all dbs, except for system dbs
      -----------------------------------------------------------------------------
      DECLARE curDBName CURSOR FOR
      SELECT
          [name]
      FROM
          master.sys.databases
      WHERE
          name NOT IN ('master', 'tempdb', 'model', 'msdb')
          AND state_desc = 'ONLINE'
      -------------------------------------------------------------------------------
      --add the log file name to the temporary table,groupid=0 is for logfile and 1 for datafile.
      -----------------------------------------------------------------------------
      OPEN curDBName
      FETCH NEXT FROM curDBName INTO @DBName
      WHILE @@FETCH_STATUS = 0
      BEGIN
          SELECT @exec_stmt = 'INSERT INTO #logfiles
           SELECT ''' + @DBName + ''' , name FROM ' + quotename(@DBName, N'[') + N'.dbo.sysfiles
           WHERE groupid = 0'
          EXECUTE (@exec_stmt)
      FETCH NEXT FROM curDBName INTO @DBName
      END
      CLOSE curDBName
      DEALLOCATE curDBName
      --SELECT * FROM #logfiles
      ------------------------------------------------
      --select all log filenames from the #logiles
      -------------------------------------------------
      DECLARE curLogName CURSOR FOR
      SELECT
          dbname, [filename]
      FROM
          #logfiles
      ----------------------------------------------------
      --shrink all log files
      -----------------------------------------------------
      OPEN curLogName
          FETCH NEXT FROM curLogName INTO @DBName, @LogFileName
      WHILE @@FETCH_STATUS = 0
      BEGIN
          SELECT @exec_stmt = ' USE ' + quotename(@DBName) + N' DBCC SHRINKFILE (' + quotename(@LogFileName)+')'
          --print (@exec_stmt)
          EXECUTE (@exec_stmt)
      FETCH NEXT FROM curLogName INTO @DBName, @LogFileName
      END
      CLOSE curLogName
      DEALLOCATE curLogName
      ----------------------------------------
      --clean up the logfile table