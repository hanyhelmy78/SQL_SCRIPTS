-- query to retrive table which a specific user don`t have access to

SELECT DISTINCT O.name as 'Table'
FROM sysobjects O ,sysprotects P 
WHERE p.id = o.id and 
	  o.name NOT IN (SELECT DISTINCT o.name 
					 FROM sysprotects P WITH (NOLOCK) inner join 
						  sysobjects O WITH (NOLOCK) on P.id = O.id inner join 
						  sysusers U WITH (NOLOCK) on P.uid = U.uid AND 
						  U.name = 'coreBio') and 
	  o.type = 'U'

--select * from sysobjects