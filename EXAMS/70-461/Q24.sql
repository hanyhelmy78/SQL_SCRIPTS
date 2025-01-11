alter proc usp_Customers (@Count int)
as set nocount on;
set ROWCOUNT @Count
select LastName
from Sales.Customers
order by LastName asc

--exec usp_customers 4