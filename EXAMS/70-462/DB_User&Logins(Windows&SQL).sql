
-- create Windows-Authentication login
create login sql_login with password = 'somepassword';
-- SQL Server–Authenticated Login
create login "server_name\user_name" from windows;
-- from certificate
create login login_name from certificate ServerCertificate
-- alter an existing login
alter login sql_login disable;
-- create db user from windows login
create user "hany_isd\local_group_b" for login "hany_isd\local_group_b";
-- create databse user from sql login
create user sql_user_c for login sql_user_c
-- create database role
create role TableAdmin;
-- grant access to db role
grant create table, create schema to TableAdmin;
-- add db user to an existing role
exec sp_addrolemember 'TableAdmin', "sql_user_c";