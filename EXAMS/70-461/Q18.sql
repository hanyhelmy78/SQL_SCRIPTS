--create table Sales.Customers (CustomerId int not null, FirstName Varchar(100) not null, LastName varchar(100) not null)
create view Sales.uv_CustomerFullName
with SCHEMABINDING
AS select CustomerId,
		 (FirstName + ' ' + LastName) as CustomerFullName
from Sales.Customers