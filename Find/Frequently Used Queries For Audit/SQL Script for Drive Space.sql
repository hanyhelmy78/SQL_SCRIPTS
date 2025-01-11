/******************Enable xp_cmdshell:*********************/
sp_configure 'show advanced options' ,1
Go
reconfigure
Go
sp_configure 'xp_cmdshell' ,1
Go
reconfigure
/***************Script for Drive Space****************************/


DECLARE @Drive TINYINT,
@SQL VARCHAR(100)
SET @Drive = 97
DECLARE @Drives TABLE
(
Drive CHAR(1),
Info VARCHAR(80)
)
WHILE @Drive <= 122
BEGIN
SET @SQL = 'EXEC XP_CMDSHELL ''fsutil volume diskfree ' + CHAR(@Drive) + ':'''


INSERT @Drives
(
Info)
EXEC (@SQL)
UPDATE @Drives
SET Drive = CHAR(@Drive)
WHERE Drive IS NULL
SET @Drive = @Drive + 1
END

CREATE TABLE #DiskSpace
( DriveLetter char(1),
TotalSize decimal(20,0),
AvailableSpace decimal(20,0),

)
 INSERT INTO #DiskSpace (DriveLetter, TotalSize, AvailableSpace)
SELECT Drive,
SUM(CASE WHEN Info LIKE 'Total # of bytes%' THEN CAST(REPLACE(SUBSTRING(Info, 32, 48), CHAR(13), '') AS BIGINT) ELSE CAST(0 AS BIGINT) END) AS TotalBytes,
SUM(CASE WHEN Info LIKE 'Total # of free bytes%' THEN CAST(REPLACE(SUBSTRING(Info, 32, 48), CHAR(13), '') AS BIGINT) ELSE CAST(0 AS BIGINT) END) AS FreeBytes
--SUM(CASE WHEN Info LIKE 'Total # of avail free bytes : %' THEN CAST(REPLACE(SUBSTRING(Info, 32, 48), CHAR(13), '') AS BIGINT) ELSE CAST(0 AS BIGINT) END) AS AvailFreeBytes
FROM (
SELECT Drive 
, Info
FROM @Drives
WHERE Info LIKE 'Total # of %'
) AS d
GROUP BY Drive
ORDER BY Drive

----select DriveLetter , (((TotalSize / 1024)/1024)/1024) As [TotalSize in GB], 
----AvailableSpace/ (1024*1024*1024) as [AvailableSpace in GB] from #DiskSpace order by DriveLetter
----select sum (TotalSize)/ (1024*1024*1024)as [Total Size of disk in GB] from #DiskSpace
/*****Result in roud off ********/
select @@servername as Servername ,DriveLetter , CAST(ROUND((((TotalSize / 1024)/1024)/1024) , 2) AS FLOAT) As [TotalSize in GB], 
CAST(ROUND(AvailableSpace/ (1024*1024*1024) , 2) AS FLOAT) as [AvailableSpace in GB] from #DiskSpace order by DriveLetter

select CAST(ROUND(Sum(TotalSize)/ (1024*1024*1024), 2) AS FLOAT) as [Total Size of disk in GB] from #DiskSpace

drop table #DiskSpace


/***************END OF Script **************************/
