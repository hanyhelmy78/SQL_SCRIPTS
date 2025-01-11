create table Sales.OrderDetails (ListPrice money not null, 
								 Quantity int not null, 
								 LineltemTotal as ListPrice * Quantity)
declare @ErrorVar int
set @ErrorVar = @@ERROR
if @ErrorVar = 0 
print 'Table Sales.OrderDetails Created Successfully'