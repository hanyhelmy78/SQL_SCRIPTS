USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[DMV_BackupAll]    Script Date: 3/16/2015 7:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE [msdb]
GO

/****** Object:  UserDefinedTableType [dbo].[Exceptionlist]    Script Date: 17/09/2013 02:36:13 PM ******/
CREATE TYPE [dbo].[Exceptionlist] AS TABLE(
	[list] [int] NULL
)
GO

CREATE PROC [dbo].[DMV_BackupAll] (@start_DB_ID int, @END_DB_ID int,@TapeBackupLocation varchar(500),@TranBackupLocation varchar(500)
,@FULLBackup INT = 0 , @DiffBackup INT =0 , @TXNLOG INT = 0 ,@TXLLOGType INT = 0 
 ,@Job_Name Nvarchar(50) = 'No Job Name'
 ,@Exceptionlist_DBs Exceptionlist readonly
 ,@p_recipients nvarchar (1000)
)
as 
begin 
SET NOCOUNT ON;
-- Multiple Recipients can be added to @p_recipients by using semicolon
Declare @recovery_model int 
Declare @TXLLOGTypeName varchar (20)
DECLARE @name NVARCHAR(500)
 -- database name 
DECLARE @sql NVARCHAR(MAX) = N''
 -- sql statment
DECLARE @p_body AS NVARCHAR(MAX) ,   @p_subject AS NVARCHAR(MAX),    @p_profile_name AS NVARCHAR(MAX) 
SET @p_subject = N'Backup failed on Job Name''' + @Job_Name + ''' On Server '  + ( CAST((SELECT  SERVERPROPERTY('ServerName')) AS nvarchar)) 

DECLARE @msg VARCHAR(max) 
Declare @patherror varchar(50)
--------------------------------------------------------------------------------------------------------------

----Path for @TapeBackupLocation
DECLARE @FileName varchar(255)
DECLARE @IsExist Int
Declare  @Temp Table
(File_Exist int , Directory int , Parent int) 
SELECT @FileName= @TapeBackupLocation
Insert Into @Temp
EXEC Master.dbo.xp_fileexist @filename
Set @IsExist =  (Select Directory from @Temp)

---- Check Path @TranBackupLocation
		DECLARE @FileName2 varchar(255)
		DECLARE @IsExist2 Int
		Declare  @Temp2 Table
		(File_Exist int , Directory int , Parent int) 
		SELECT @FileName2= @TranBackupLocation
		Insert Into @Temp2
		EXEC Master.dbo.xp_fileexist @FileName2
		Set @IsExist2 =  (Select Directory from @Temp2)

----Send Error massage
if (isnull(@IsExist,0) <> 1 ) OR @IsExist2 <> 1
			begin
			set @patherror=' Because This Path  ''' + @TapeBackupLocation + ''' or this Path ''' + @TranBackupLocation + ''' Is not Correct' 
            SET @p_body = 'Database Backup Will not Complete on the server </br></br>' +
             + 'Server : <b>' + ( CAST((SELECT  SERVERPROPERTY('ServerName')) AS nvarchar))+ '</b></br>' + 
			 ' and On the Job Name '''+ isnull(@Job_Name,'') +''' ' + '</b></br>' + 
             'and the corrupted database: <b>' + isnull(@name,'') +'</b></br></br>' + isnull(@patherror,'') 
               PRINT @p_body
---Send massage

EXEC msdb.dbo.sp_send_dbmail 
@recipients = @p_recipients, 
@body = @p_body ,
@body_format = 'HTML', 
@subject = @p_subject
GOTO GOOUT
end		
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
--Haja Creatation temp table to store failure data
DECLARE @h_body as nvarchar(max)
Declare @BackupType as varchar(50)
Create table #JobFailed
(Dbname sysname,
[Errormessage] varchar(300),
BackupType varchar(30))
-------------------------------------------------------------
DECLARE db_cursor CURSOR  fast_forward read_only forward_only FOR SELECT name FROM sys.databases
 WHERE  database_id >= @start_DB_ID and database_id<=@END_DB_ID and state_desc = 'ONLINE'
 and database_id not in (select * from  @Exceptionlist_DBs)

declare @count int
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0 
    BEGIN  
              
        BEGIN TRY
            DECLARE @Return INT
			set @sql = N''
---------------------------------------------------
-- Check Full OR Deffrential Backup Device
			IF (@FULLBackup = 1 or @DiffBackup = 1)
			begin
			set @count = 0 
			select @count= count(*) from sys.backup_devices
			where lower(name) = lower(@name) + lower('_full')

			if @count = 0
				begin

				set @sql = @sql + N' 
				
				USE [master]
				EXEC master.dbo.sp_addumpdevice  @devtype = N''disk'', @logicalname = N''' + @name + '_full'', @physicalname				= N''' + @TapeBackupLocation + @name + '_full.bak'''
				end
			end
--Full Backup------------------------------------------------------------------------------------
			IF (@FULLBackup = 1)
			BEGIN
			set @BackupType='Full Backup'
				set @sql = @sql + N' 
BACKUP DATABASE [' + @name + '] TO  [' + @name + '_full] WITH NOFORMAT, INIT,  NAME = N''' + @name + '-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, CHECKSUM, STATS = 5'			
				END
--------------------------------------------------------------------------------------------------
--Diffrential Backup------------------------------------------------------------------------------------
			IF (@DiffBackup = 1)
			BEGIN
			set @BackupType='Differentical Backup'
			
						set @sql = @sql + N'
						
BACKUP DATABASE [' + @name + '] TO  [' + @name + '] WITH DIFFERENTIAL , NOFORMAT, INIT,  NAME = N''' + @name + '-Differential Database Backup'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, CHECKSUM, STATS = 5'				
				END
--------------------------------------------------------------------------------------------------
--TXN Log overwirte-------------------------------------------------------------------------------
			

			IF (@TXNLOG = 1 AND @TXLLOGType >=0 AND @TXLLOGType <2)
			BEGIN
			set @BackupType='Transactional Log Backup'
			SELECT @recovery_model= recovery_model FROM sys.databases WHERE  name = @name 
			IF(@recovery_model in (1,2))
			BEGIN

			IF @TXLLOGType = 1 
			SET @TXLLOGTypeName = 'INIT' -- OVERWRITE THE EXISTING BKP MEDIA; THIS IS 4 FULL BKP ONLY***
			else 
			SET @TXLLOGTypeName = 'NOINIT' -- APPEND 2 THE EXISTING BKP MEDIA; THIS IS 4 DIFF & LOG BKP***

			set @count = 0 
			set @recovery_model = 1
			select @count= count(*) from sys.backup_devices
			where lower(name) = lower(@name) --+ lower('_fullDiff')

if (@count > 0 )
				begin
				set @sql = @sql + N'

BACKUP LOG [' + @name + '] TO  [' + @name + '_log] WITH NOFORMAT, ' + @TXLLOGTypeName + ',  NAME = N''' + @name + '-Transaction Log Backup'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, CHECKSUM, STATS = 5'
				end
					else 
				begin

				set @sql = @sql + N'
				
			USE [master]
				EXEC master.dbo.sp_addumpdevice  @devtype = N''disk'', @logicalname = N''' + @name + '_log'', @physicalname				= N''' + @TranBackupLocation + @name + '_log.trn''
				
BACKUP LOG [' + @name + '] TO  [' + @name + '_log] WITH NOFORMAT, ' + @TXLLOGTypeName + ',  NAME = N''' + @name + '-Transaction Log Backup'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, CHECKSUM, STATS = 5'
				end
				END
				END-- Recovery model
--------------------------------------------------------------------------------------------------
            SET @msg = 'Database Backup failed for the database ' + @name  
			print @sql
           EXEC @Return = sp_executesql @sql	
        END TRY
               BEGIN CATCH

         	if @return > 0
         	PRINT @return
			begin
		    raiserror (@msg,16,1) with log
			SET @msg = ( SELECT ERROR_MESSAGE())
			PRINT @Msg
            SET @p_body = 'Database Backup failed on the server </br></br>' +
             + 'Server : <b>' + ( CAST((SELECT  SERVERPROPERTY('ServerName')) AS nvarchar))+ '</b></br>' + 
			 ' and On the Job Name '''+ isnull(@Job_Name,'') +''' ' + '</b></br>' + 
             'and the corrupted database: <b>' + isnull(@name,'') +'</b></br></br>' + isnull(@msg,'')
               PRINT @p_body
				--Haja Failure data into temp table
			   	Insert into #JobFailed(Dbname,Errormessage,BackupType)
				select  @name,@p_body,@BackupType
--print @p_body
end
        END CATCH
     WAITFOR DELAY '000:00:15'
        FETCH NEXT FROM db_cursor INTO @name  
    END  

CLOSE db_cursor  
DEALLOCATE db_cursor

--Newly created by Haja for generate the Error message into HTML table 
set @h_body = cast( (
select td = Dbname + '</td><td>' + cast( Errormessage as varchar(max) ) + '</td><td>' + cast( BackupType as varchar(max) )
from (
      select Dbname,
             Errormessage,
			 BackupType
             
      from  #JobFailed
	              ) as d
for xml path( 'tr' ), type ) as varchar(max) )

		set @H_body = '<table cellpadding="2" cellspacing="2" border="1">'
          + '<tr><th>Database </th><th>Error Message</th><th>BackupType</th></tr>'
          + replace( replace( @H_body, '&lt;', '<' ), '&gt;', '>' )
          + '</table>'

		  DECLARE @COUNT1 INT = (SELECT COUNT (*) FROM #JobFailed  )
		  IF isnull(@COUNT1,0) > 0
		  BEGIN
				EXEC msdb.dbo.sp_send_dbmail @recipients = @p_recipients, @body = @H_body ,
                @body_format = 'HTML', @subject = @p_subject

			END
	   DROP TABLE #JobFailed  
GOOUT:
end
GO