--create table Sales.Orders (OrderId int not null, OrderDate datetime, SalesTerritoryID int, TotalDue money)
--create view Sales.OrdersByTerritory as 
--select OrderId,
--	   OrderDate,
--	   SalesTerritoryID,
--	   TotalDue
--from Sales.Orders;
create function Sales.fn_OrdersByTerritory (@T int)
returns table 
as return select OrderId,
				 OrderDate,
				 SalesTerritoryID,
				 TotalDue
from Sales.Orders
where SalesTerritoryID = @T 