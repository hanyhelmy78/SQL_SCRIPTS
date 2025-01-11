--alter table Sales.Details add SalesTerritoryID int not null
select  SalesTerritoryID,
		ProductId,
	    AVG(UnitPrice) as AveragePrice,
	    MAX(OrderQty) as MaxQty,
	    MAX(Discount) as MaxDiscount
from Sales.Details
group by SalesTerritoryID,ProductId
order by SalesTerritoryID desc,ProductId desc