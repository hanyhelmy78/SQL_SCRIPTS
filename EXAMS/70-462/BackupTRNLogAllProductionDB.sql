DECLARE @SQL NVARCHAR(MAX),
		@v_TLog_dir NVARCHAR(MAX),
		@v_compression_YN NCHAR(1);
  BEGIN

  SET @v_TLog_dir = 'C:\backup';
  SET @v_compression_YN = 'Y';

  SELECT @SQL = COALESCE(@SQL + CHAR(13) + CHAR(10),'') + N'
  Use [' + d.name + '];' + CHAR(13) +
  'BACKUP LOG ' + d.name + ' TO DISK = N''' + @v_TLog_dir + '\' + mf.name + '.trn'' WITH NOFORMAT, INIT, SKIP, NOREWIND, NOUNLOAD' +
  CASE @v_compression_YN
  WHEN 'Y' THEN
  ', COMPRESSION, COPY_ONLY;'
  WHEN 'N' THEN
  ', COPY_ONLY;'
  END + CHAR(13) +
  'DBCC SHRINKFILE (' + QUOTENAME(mf.[name],'''') + ', 1) WITH NO_INFOMSGS;'
  FROM sys.databases d INNER JOIN sys.master_files mf ON d.database_id = mf.database_id
  WHERE d.name NOT IN ('master', 'tempdb', 'model', 'msdb', 'ReportServer', 'ReportServerTempDB')
  AND d.recovery_model_desc = 'FULL'
  AND d.is_read_only = 0
  AND mf.type_desc = 'LOG'
  ORDER BY d.name;
  EXEC sp_executesql @SQL;
  END; 