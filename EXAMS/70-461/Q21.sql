--alter table Sales.Customers add constraint PK_CustomerId primary key (CustomerId)
--alter table Sales.Orders add CustomerId int not null foreign key references Sales.Customers (CustomerId)
 set ansi_nulls on;
go
alter proc RPT_OrderDetails 
as select o.OrderId,
		  RANK() over(partition by o.CustomerId order by MAX(o.OrderDate))as MostRecentOrder,
		  c.LastName,
		  o.OrderDate as MostRecentOrderDate
from Sales.Orders o join Sales.Customers c
on o.CustomerId = c.CustomerId
group by o.OrderId, o.CustomerId, c.LastName, o.OrderDate
order by o.OrderId desc