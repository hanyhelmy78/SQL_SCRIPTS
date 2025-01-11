--create database AdventureContacts
use AdventureContacts
go
--create table TableAlpha (FirstName nvarchar(max), LastName nvarchar(max))
--create table TableBeta (FirstName nvarchar(max), LastName nvarchar(max))
-- cmd command
bcp "SELECT FirstName, LastName FROM AdventureWorks2008R2.Person.Person ORDER BY LastName, FirstName" queryout C:\Data\contacts.txt -c -T