
/*6.write select query to find number of employee of all department. It should return two columns:
1. EmployeeCount
2. Department Name
Write View for this
*/

CREATE VIEW VW_NoOfEmpPerDept
AS
SELECT E.DepartmentID,
       D.DepartmentName,
       COUNT(E.EmployeeId) AS EmployeeCount
FROM dbo.Employee E
    INNER JOIN dbo.Department D
        ON D.DepartmentID = E.DepartmentID
GROUP BY E.DepartmentID,
         D.DepartmentName;

--select * from VW_NoOfEmpPerDept



/*11.if DA is 20% of salary then find DA for all employee. It should return three columns:
1. EmployeeName
2. Salary
3. DA
Use Function
*/

CREATE FUNCTION FN_FindDAForEmp()
RETURNS TABLE
AS
RETURN SELECT E.FirstName +' ' +E.LastName AS UserName,E.Salary, CAST((E.Salary * 0.20) AS INT) AS DA FROM dbo.Employee E;

--SELECT * FROM FN_FindDAForEmp()



/*13.List Users who is born in particular month.month will pass as parameter of stored procedure.*/

--SP_GetUserByBirthMonth 1

alter PROC SP_GetUserByBirthMonth
	@birthMonth int
AS
BEGIN
	SELECT * FROM dbo.Employee E 
	WHERE DATEPART(MONTH,E.DateofBirth) = @birthMonth
END

SELECT DATENAME(MONTH,'20230101')




/*16. List All States from India & Number of users in it. It should return two columns: (If there are no users in any state, State name should also come in result)
1. State
2. UserCount
Write Stored procedure
*/

--SP_GetAllStateOdIndAndUsersInStates 'USA'
alter PROC SP_GetAllStateOdIndAndUsersInStates
(
	 @country Varchar(50)
)
AS
BEGIN
    SELECT s.StateName,
           COUNT(e.EmployeeId) AS UserCount
    FROM State s
        LEFT JOIN City c
            ON s.StateID = c.StateID
        LEFT JOIN Employee e
            ON c.CityID = e.CityID
        INNER JOIN Country co
            ON s.CountryID = co.CountryID
    WHERE co.CountryName = @country
    GROUP BY s.StateName;
END;



/*19. Make one trigger for employee table.So when new employee created at that time new user is automatically created.
*/
CREATE TRIGGER TR_NewUserOnNewEmpReg
ON dbo.Employee
AFTER INSERT
AS
DECLARE	@FirstName VARCHAR(50);
DECLARE @LastName VARCHAR(50);
DECLARE @Gender VARCHAR(10);
DECLARE @DateofBirth DATETIME;
DECLARE @DepartmentID int;
DECLARE @Salary INT;
DECLARE @Address VARCHAR(100);
DECLARE @CityID INT;
DECLARE @PinCode INT;
DECLARE @IsActive INT;

SELECT @FirstName = I.FirstName,
@LastName = I.LastName,
@Gender = I.Gender,
@DateofBirth = I.DateofBirth,
@DepartmentID = I.DepartmentID,
@Salary = I.Salary,
@Address = I.Address,
@CityID = I.CityID,
@PinCode = I.PinCode,
@IsActive = I.IsActive
FROM Inserted I;

INSERT INTO dbo.Users
(
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
(   @FirstName,   -- FirstName - varchar(50)
    @LastName, -- LastName - varbinary(50)
    @Gender,   -- Gender - char(1)
    @DateofBirth, -- DateofBirth - datetime
    @DepartmentID, -- DepartmentID - int
    @Salary, -- Salary - decimal(18, 2)
    @Address, -- Address - varchar(200)
    @CityID, -- CityID - int
    @PinCode, -- PinCode - char(6)
    @IsActive  -- IsActive - bit
    )




/*20. Make one view which shows users all detail*/
CREATE VIEW VW_GetAllUsers
AS
SELECT * FROM Users

--select * from VW_GetAllUsers
--select * from employee
