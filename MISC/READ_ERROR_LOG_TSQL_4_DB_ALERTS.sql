DECLARE @errorLog TABLE (LogDate DATETIME, ProcessInfo VARCHAR(64), [Text] VARCHAR(MAX));

INSERT INTO @errorLog 
EXEC sp_readerrorlog

BEGIN
SELECT LogDate,[Text]
FROM @errorLog a
WHERE EXISTS (SELECT TOP 100 * 
              FROM @errorLog b
              WHERE ([Text] LIKE N'Error:%'OR [Text] LIKE N'%severity%'OR [Text] LIKE N'%64001%'OR [Text] LIKE N'%64000%'OR [Text] LIKE N'%41414%'OR [Text] LIKE N'%41406%'OR [Text] LIKE N'%41142%'OR [Text] LIKE N'%41131%'OR [Text] LIKE N'%41091%'OR [Text] LIKE N'%35279%'OR [Text] LIKE N'%35276%'OR [Text] LIKE N'%35275%'OR [Text] LIKE N'%35274%'OR [Text] LIKE N'%35273%'OR [Text] LIKE N'%35267%'OR [Text] LIKE N'%35264%'OR [Text] LIKE N'%35254%'OR [Text] LIKE N'%35250%'OR [Text] LIKE N'%19406%'OR [Text] LIKE N'%1480%'OR [Text] LIKE N'%856%'OR [Text] LIKE N'%855%'OR [Text] LIKE N'%832%'OR [Text] LIKE N'%825%'OR [Text] LIKE N'%824%'OR [Text] LIKE N'%823%'OR [Text] LIKE N'%41145%'OR [Text] LIKE N'%3313%'OR [Text] LIKE N'%3314%'OR [Text] LIKE N'%17810%'OR [Text] LIKE N'%17832%'OR [Text] LIKE N'%17836%')
                AND a.LogDate = b.LogDate
                AND a.ProcessInfo = b.ProcessInfo
				AND B.LogDate >= DATEADD(HOUR, -1, GETDATE()))
				ORDER BY A.LogDate DESC
END

SELECT COUNT(*) SUSPECT_PAGES FROM msdb.dbo.suspect_pages;