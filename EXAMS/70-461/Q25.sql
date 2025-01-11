alter proc Procedure1 (@Parameter1 datetime)
as select OrderId,
		  OrderDate,
		  CustomerId
from Sales.Orders
where OrderDate > @Parameter1	

--exec Procedure1 '1978-06-08'  