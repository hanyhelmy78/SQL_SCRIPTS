SELECT name,type_desc,create_date,modify_date,password_hash 
FROM sys.sql_logins 
WHERE PWDCOMPARE(name,password_hash) = 1;