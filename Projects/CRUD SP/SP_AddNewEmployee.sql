alter PROC SP_AddNewEmployee
	@firstName VARCHAR(50) = NULL,
	@lastName VARCHAR(50) = NULL,
	@gender VARCHAR(2)=NULL,
	@dateOfBirth DATETIME = NULL,
	@departmentId INT =NULL,
	@salary INT = NULL,
	@emailAddress NVARCHAR(200)= NULL,
	@cityId BIGINT = NULL,
	@pincode INT = NULL,
	@isActive BIT = NULL,
	@output NVARCHAR(50) OUTPUT
AS
BEGIN

	IF @emailAddress = (SELECT DISTINCT E.Address FROM dbo.Employee E WHERE E.Address = TRIM(@emailAddress))
	BEGIN
		--select('EmailExists')
		SET @output = '0' 
	END
	ELSE
    BEGIN
	INSERT INTO dbo.Employee
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
    (   @firstName,   -- FirstName - varchar(50)
        @lastName, -- LastName - varbinary(50)
        @gender,   -- Gender - char(1)
        @dateOfBirth, -- DateofBirth - datetime
        @departmentId, -- DepartmentID - int
        @salary, -- Salary - decimal(18, 2)
        @emailAddress, -- Address - varchar(200)
        @cityId, -- CityID - int
        @pincode, -- PinCode - char(6)
        @isActive  -- IsActive - bit
        )

		--select('EmployeeAdded')
		SET @output = '1'
	END

END

--exec SP_AddNewEmployee 'Rohan', 'Vaghasiya','M','2023-05-07','3','45000','roohma@gmail.com','12','365214','1','0'
--SELECT * FROM dbo.Employee