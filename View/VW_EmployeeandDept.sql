ALTER VIEW VW_EmployeeandDept
AS

SELECT E.EmployeeId,
       E.FirstName,
       E.LastName,
       E.Gender,
       E.DateofBirth,
       D.DepartmentName,
       E.Salary,
       E.Address,
       E.CityID,
       E.PinCode,
       E.IsActive
FROM dbo.Employee E
    INNER JOIN dbo.Department D
        ON E.DepartmentID = D.DepartmentID;
GO


--SELECT *
--FROM dbo.VW_EmployeeandDept;


--SELECT D.DepartmentName
--FROM dbo.Department D;
--SELECT *
--FROM dbo.Employee;