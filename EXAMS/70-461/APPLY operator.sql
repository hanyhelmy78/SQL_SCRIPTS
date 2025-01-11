create table #A (S varchar(10), R varchar(10))
insert into #A values ('Alpha','D1234'),('beta','A1122'),('charlie','D1234'),('bravo','C1342'), ('Doug','B1964'),('harry','A1122')

create table #B (R varchar(10), S int)
insert into #B values ('D1234',1001),('A1122',4001),('D1234',2001),('C1342',5001) ,('A1122',3001);

select tblA.S, tblA.R, subQuery.S
from #A tblA
outer apply (select R,S from #B tblB where tblA.R = tblB.R) subQuery; 

--CROSS APPLY returns only rows from the outer table that produce a result set from the table-valued function. 
--OUTER APPLY returns both rows that produce a result set, and rows that do not, with NULL values in the columns produced by the table-valued function