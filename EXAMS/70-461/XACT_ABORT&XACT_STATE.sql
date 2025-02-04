USE [AdventureWorks2008R2]
GO
/****** Object:  StoredProcedure [dbo].[geterroerinfo]    Script Date: 07/31/2012 14:05:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[geterroerinfo]
as select ERROR_NUMBER() as errornum,
		  ERROR_SEVERITY() as errorseverity,
		  ERROR_STATE()as errorstatus,
		  ERROR_PROCEDURE()as errorproc,
		  ERROR_LINE()as errorline,
		  ERROR_MESSAGE() as errormsg
set xact_abort on;		  
begin try
	begin tran
delete from Production.Product where ProductID = 980
commit tran;
end try
begin catch
exec geterroerinfo;
if (xact_state()) = -1
print 'The transaction is in an uncommittable state.' +
            'Rolling back transaction.'
	rollback tran;
if (xact_state()) = 1
print 'The transaction is committable.' +
            'Committing transaction.'
	commit tran;	
end catch;		  