--exec sp_configure 'show Advanced option','1'
--reconfigure 
--go
--alter server role serveradmin add member "sa";
exec sp_addrolemember 'db_datareader', -- this is the role name
"HMG\Hany-ISD" -- and this is the login name
create login "sql_login" with password = '******' --create sql server login
create user "sql_user" for login "sql_login" -- create user on master db