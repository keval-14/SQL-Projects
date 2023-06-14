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
@DateofBirth NVARCHAR(70),
@DepartmentId INT,
@Salary INT,
@Address VARCHAR(150),
@CityId int,
@PinCode int,
@IsActive BIT,
@outPut INT OUT
AS
BEGIN

DECLARE @age INT
DECLARE @EmailExist int
SET @age = DATEDIFF(YEAR,@DateofBirth, GETDATE());
IF @age >= 18
BEGIN
    UPDATE dbo.Employee SET FirstName = @FirstName, 
							LastName = @LastName, Gender = @Gender, DateofBirth = @DateofBirth, DepartmentID = @DepartmentId, Salary = @Salary, Address = @Address, CityID = @CityId, PinCode = @PinCode, IsActive = @IsActive
							WHERE EmployeeId = @EmployeeId

	SET @outPut = 1
END
ELSE
BEGIN
	SET @outPut = 0
END

END



--SELECT DATEDIFF(YEAR,15-02-2001, GETDATE())

--SELECT CAST('6-10-1971 00:00:00' AS DATETIME)

--DECLARE @DateofBirth NVARCHAR(70)
--SET @DateofBirth = '15-02-2001 00:00:00'

--SELECT DATEDIFF(YEAR,CONVERT(datetime,@DateofBirth,103), GETDATE());