USE Test
GO
DECLARE @TableVar TABLE (empid INT NOT NULL PRIMARY KEY,vacHour INT, EditedOn DATETIME)
INSERT INTO @TableVar (empid)
SELECT EmployeeID FROM Employees 
UPDATE @TableVar SET vacHour = e.vacHour + 8, EditedOn = GETDATE()
FROM Employees e 
WHERE e.EmployeeID = empid
SELECT * FROM @TableVar
ORDER BY empid