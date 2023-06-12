-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <12-06-2023>
-- Description:	<Stored Procedure that Update Records in Employee table with values getting from frontEnd>
-- =======================================================================================================================================

ALTER PROC SP_UpdateEmployee
@EmployeeId BIGINT,
@FirstName VARCHAR(100),
@LastName VARCHAR(100),
@Gender CHAR(2),
@DateofBirth DATETIME,
@DepartmentId INT,
@Salary INT,
@Address VARCHAR(150),
@CityId int,
@PinCode int,
@IsActive BIT,
@outPut INT OUT
AS
BEGIN
    UPDATE dbo.Employee SET FirstName = @FirstName, 
							LastName = @LastName, Gender = @Gender, DateofBirth = @DateofBirth, DepartmentID = @DepartmentId, Salary = @Salary, Address = @Address, CityID = @CityId, PinCode = @PinCode, IsActive = @IsActive
							WHERE EmployeeId = @EmployeeId

	SET @outPut = 1
END