
CREATE PROCEDURE sp_folder_details (@path varchar (max) )
as
BEGIN
/*
Created Date: 01/Feb/2014
Details: This procedure is used to find details in Drive folders
Syntax: sp_folder_details 'C:\folder\folder'
*/
	DECLARE @cmd varchar(100)
	--DECLARE @path varchar(100)
	If @path is null
	Print 'Please pass valid path'
	Else
	Begin
	--SET @Path = 'H:\PDW\PDW_Ananda' --&gt; Pass the path in which you want to search
	SET @cmd = 'dir ' + @path + ' /A /OS /-C'
	CREATE Table #MyTable (Results varchar(500))
	INSERT INTO #MyTAble
	EXEC XP_CMDSHELL @cmd
	--EXEC XP_CMDSHELL 'Dir H:\PDW\PDW_Ananda  /A /OS /-C'
	SELECT LEFT(Results, 20) [create_date],
	CASE LTRIM(RTRIM(SUBSTRING(Results, 21, 18))) 
	WHEN '' THEN 1 ELSE 0 END as is_directory, 
	CASE LTRIM(RTRIM(SUBSTRING(Results, 21, 18))) 
	WHEN '' THEN NULL ELSE LTRIM(RTRIM(SUBSTRING(Results, 21, 18))) 
	END as size_in_bytes, 
	SUBSTRING(Results, 40, Len(Results)) AS [name]
	FROM #MyTable
	WHERE ISNULL(PATINDEX('%__/__/____%', Results), 0) != 0
	DROP TABLE #MyTable
	END
END