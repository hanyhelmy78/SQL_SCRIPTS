SET QUOTED_IDENTIFIER ON;
GO
--ALTER TABLE "Order" ADD SalesPerId INT --NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES SalesPerson (PersonId)
-- CommonTableExpression
WITH sales_cte (SalesPerId, id, sales)
-- CTE query definition
AS (SELECT SalesPerId, ID, YEAR(date) AS Sales
    FROM "Order")
-- Outer query references CTE
SELECT SalesPerId, COUNT(id) AS OrdID, sales
FROM sales_cte
GROUP BY sales, SalesPerId
ORDER BY SalesPerId    