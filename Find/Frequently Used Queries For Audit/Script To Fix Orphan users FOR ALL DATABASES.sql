--Script 1: Find Orphan users

/**********************************************************/
  EXECUTE master.sys.sp_MSforeachdb ' USE [?]; Select ''?'' ;
                EXEC ?.dbo.sp_change_users_login   ''report'' '
/**********************************************************/
--Script 2 : Generate Script To Fix Orphan users

/**********************************************************/ 
 EXECUTE master.sys.sp_MSforeachdb ' USE [?];
select ''EXEC ?.dbo.sp_change_users_login '''''' +  ''update_one'' +
 '''''''' +  '',['' + '''' +  name + ''''+ ''],['' +'''' +   name + '']'' + + ''''
from sysusers 
where sid NOT IN (select sid from master..syslogins ) 
AND islogin = 1 AND name NOT LIKE ''%guest%''  '