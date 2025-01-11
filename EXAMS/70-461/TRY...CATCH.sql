alter proc testproc
as select * from notthere
begin try
exec testproc
end try
begin catch
select ERROR_SEVERITY() as errorSeverity,
	   ERROR_MESSAGE() as errorMsg
end catch	   	  