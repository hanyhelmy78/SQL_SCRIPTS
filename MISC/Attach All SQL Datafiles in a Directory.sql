DECLARE @DataPath VARCHAR(MAX) = 'Data file path'
DECLARE @LogPath VARCHAR(MAX) = 'Log file path'
 
IF (OBJECT_ID('tempdb.dbo.#DataFiles') IS NOT NULL)
DROP TABLE #DataFiles
CREATE TABLE #DataFiles
(mdf VARCHAR(400))
 
IF (OBJECT_ID('tempdb.dbo.#DBFiles') IS NOT NULL)
DROP TABLE #DBFiles
CREATE TABLE #DBFiles
(status INT,
fileid INT,
name VARCHAR(256),
filename VARCHAR(256))
 
IF (OBJECT_ID('tempdb.dbo.#DBProperties') IS NOT NULL)
DROP TABLE #DBProperties
CREATE TABLE #DBProperties
(property VARCHAR(256),
value SQL_VARIANT)
 
DECLARE @Cmd VARCHAR(4000)
DECLARE @DataFileNames  TABLE (mdfFile nvarchar(260))
DECLARE @DataFileName VARCHAR(256)
DECLARE @ndfFileName VARCHAR(256)
DECLARE @AttachCMD VARCHAR(2000)
 
--get list of .mdf files from data directory
SET @Cmd = 'dir /b "' + @DataPath + '"\*.mdf'
 
INSERT into #DataFiles 
EXEC xp_cmdshell @Cmd
 
--cursor containing only .mdf files are aren't associatated with an existing database
UPDATE #DataFiles
SET mdf = @DataPath + '\' + mdf
DECLARE DataFilesCur CURSOR STATIC FORWARD_ONLY FOR
    SELECT mdf
    FROM #DataFiles
    WHERE mdf != 'null'
    AND mdf NOT IN (SELECT physical_name FROM sys.master_files)
 
OPEN DataFilesCur
 
FETCH NEXT FROM DataFilesCur INTO @DataFileName
 
WHILE @@FETCH_STATUS = 0
BEGIN
    TRUNCATE TABLE #DBFiles
    TRUNCATE TABLE #DBProperties
 
    --DBCC CHECKPRIMARYFILES to return all files associated with the database
    INSERT INTO #DBFiles(status, fileid, name, filename)
    EXEC ('DBCC CHECKPRIMARYFILE(''' + @DataFileName + ''', 3) WITH NO_INFOMSGS')
 
    --DBCC CHECKPRIMARYFILES to get database name
    INSERT INTO #DBProperties (property, value)
    EXEC ('DBCC CHECKPRIMARYFILE(''' + @DataFileName + ''', 2) WITH NO_INFOMSGS')
 
    --Begin constructing file attachment command
    SELECT @AttachCMD =  'CREATE DATABASE ' + QUOTENAME(CAST(value AS SYSNAME))
    FROM #DBProperties
    WHERE property = 'Database name'
 
    SET @AttachCMD = @AttachCMD + ' ON (FILENAME = ''' + @DataFileName + '''),'
 
    SELECT @AttachCMD = @AttachCMD + '(FILENAME = ''' + @LogPath + '\' + REVERSE(SUBSTRING(REVERSE(RTRIM(filename)),0,CHARINDEX('\',REVERSE(RTRIM(filename))))) + ''')'
    FROM #DBFiles
    WHERE filename LIKE '%.ldf'
 
    --cursor through the .ndf files
    DECLARE CURSOR ndfFileCur STATIC FORWARD_ONLY FOR
        SELECT filename
        FROM #DBFiles
        WHERE filename LIKE '%.ndf'
 
    OPEN ndfFileCur
    FETCH NEXT FROM ndfFileCur INTO @ndfFileName
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @AttchCMD = @AttachCMD + ',(FILENAME = ''' + @DataPath + '\' + REVERSE(SUBSTRING(REVERSE(RTRIM(@ndfFileName)),0,CHARINDEX('\',REVERSE(RTRIM(@ndfFileName))))) + ''')'
        FETCH NEXT FROM ndfFileCur INTO @ndfFileName
    END
 
    CLOSE ndfFileCur
    DEALLOCATE ndfFileCur
 
    SET @AttachCMD = @AttachCMD + ' FOR ATTACH'
 
    --PRINT @AttachCMD
    EXEC (@AttachCMD)
    FETCH NEXT FROM DataFilesCur INTO @DataFileName
END
 
CLOSE DataFilesCur
DEALLOCATE DataFilesCur