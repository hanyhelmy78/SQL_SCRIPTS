SELECT d.deptid, d.name,d.mgrid, st.empid, st.EmpName, st.mgrid
FROM Departments d
CROSS APPLY dbo.fn_getsubtree(d.mgrid) st
SELECT * FROM employees
SELECT * FROM departments