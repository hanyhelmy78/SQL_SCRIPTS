declare cursor1 cursor for
select BusinessEntityID 
from HumanResources.EmployeePayHistory
where RateChangeDate <> (select MAX(RateChangeDate)
						 from HumanResources.EmployeePayHistory)
open cursor1;
fetch from cursor1;
update HumanResources.EmployeePayHistory
set PayFrequency = 2
where CURRENT of cursor1;
close cursor1;
deallocate cursor1;					 