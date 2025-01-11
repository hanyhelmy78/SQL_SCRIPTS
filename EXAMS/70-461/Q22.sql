--create table Sales.ProductCatalog (CatId int, CatName varchar(20), ProductId int not null primary key, ProdName varchar(100),
--UnitPrice money)
--alter table Sales.Details add constraint FK_ProdId foreign key (ProductId) references Sales.ProductCatalog (ProductId) 
select ProductId,
	   ProdName,
	   UnitPrice,
	   RANK() over(order by UnitPrice desc) as PriceRank
from Sales.ProductCatalog
--order by UnitPrice desc 