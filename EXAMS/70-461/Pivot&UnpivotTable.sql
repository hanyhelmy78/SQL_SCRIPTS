USE Sales
GO
--ALTER TABLE pomain ADD vendorid	INT --NOT NULL DEFAULT 1; 
SELECT remainingdays, AVG(standardcost) AS AverageCost
FROM products 
GROUP BY remainingdays

SELECT 'AverageCost' AS ProductionDays, [0], [1], [2], [3], [4]
FROM (SELECT remainingdays, standardcost
FROM products) AS SourceTable
PIVOT (AVG(standardcost)
FOR remainingdays IN ([0], [1], [2], [3], [4])
)AS PivotTable 

SELECT vendorid, [1]AS emp1, [2]AS emp2, [3]AS emp3, [4] AS emp4
FROM (SELECT poid,empid,vendorid
      FROM pomain) AS SourceTable
PIVOT (COUNT(poid) FOR empid IN ([1],[2],[3],[4])
) AS PivotTable
ORDER BY PivotTable.vendorid   

--CREATE TABLE pvt (vendorid INT, emp1 INT, emp2 INT, emp3 INT, emp4 INT)
--INSERT INTO pvt VALUES (1,4,3,5,4), (2,4,1,5,5), (3,4,3,5,4), (4,4,2,5,5), (5,5,1,5,5) 

SELECT vendorid, employee, orders
FROM (SELECT * FROM pvt) AS sourcetable
UNPIVOT (orders FOR employee IN (emp1,emp2,emp3,emp4)) AS unpoivot; 