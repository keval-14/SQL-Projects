-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <02-06-2023>
-- Description:	<Stored Procedure that Insert or Update Records in Dummy table from it's original table>
-- =======================================================================================================================================

--USE [SQL-Practice]
--GO

ALTER PROCEDURE SP_InsertOrUpdateIntoEmployeeTempTbl
AS
BEGIN

    MERGE dbo.EmployeeTemp AS ET
    USING dbo.Employee AS emp
    ON (ET.EmployeeID = emp.EmployeeID AND ET.CityID = emp.CityID)
    WHEN MATCHED THEN
        UPDATE SET ET.FirstName = emp.FirstName,
                   ET.LastName = emp.LastName,
                   ET.Gender = emp.Gender,
                   ET.DateofBirth = emp.DateofBirth,
                   ET.DepartmentID = emp.DepartmentID,
                   ET.Salary = emp.Salary,
                   ET.Address = emp.Address,
                   ET.CityID = emp.CityID,
                   ET.PinCode = emp.PinCode,
                   ET.IsActive = emp.IsActive
    WHEN NOT MATCHED THEN
        INSERT
        (
			EmployeeId,
            FirstName,
            LastName,
            Gender,
            DateofBirth,
            DepartmentID,
            Salary,
            Address,
            CityID,
            PinCode,
            IsActive
        )
        VALUES
        (emp.EmployeeId,emp.FirstName, emp.LastName, emp.Gender, emp.DateofBirth, emp.DepartmentID, emp.Salary,
         emp.Address, emp.CityID, emp.PinCode, emp.IsActive);

		 
	DELETE FROM dbo.EmployeeTemp WHERE EmployeeId NOT IN (SELECT E.EmployeeId FROM dbo.Employee E)



END;

