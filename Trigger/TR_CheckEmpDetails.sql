-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <01-06-2023>
-- Description:	<After Insert Trigger on Employee table for check AGE>18 and validate Email and check for existing Email>
-- =======================================================================================================================================
USE [SQL-Practice]
GO	

ALTER TRIGGER TR_CheckEmpDetails
ON dbo.Employee
AFTER INSERT
AS
DECLARE @emp_dob VARCHAR(20);
DECLARE @Age INT;
DECLARE @Email VARCHAR(100);

SELECT @emp_dob = I.DateofBirth
FROM Inserted I;
SELECT @Email = I.Address
FROM Inserted I;

SET @Age = DATEDIFF(YEAR, @emp_dob, GETDATE());
IF @Age < 18
BEGIN
    PRINT 'Age must be Greater than 18';
    ROLLBACK;
END;

ELSE IF ISNULL(@Email, '') = ''
        OR @Email NOT LIKE '_%@__%.__%'
BEGIN
    PRINT 'Please Enter Valid Email Address';
    ROLLBACK;
END;

--ELSE IF @Email IN (SELECT DISTINCT E.Address FROM dbo.Employee E WHERE E.Address = @Email)
--BEGIN
--    PRINT 'Email Already Exists Please Use Different Email';
--    ROLLBACK;
--END

ELSE
BEGIN

    PRINT 'Employee Inserted Successfully...!!';
END;

PRINT(@Email)



sp_helptext 'TR_CheckEmpDetails'

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
(   'Rajan',         -- FirstName - varchar(50)
    'Koyani',        -- LastName - varbinary(50)
    'M',             -- Gender - char(1)
    '2001-02-15',    -- DateofBirth - datetime
    '5',             -- DepartmentID - int
    '45000',         -- Salary - decimal(18, 2)
    'uytuytu@ad.ad', -- Address - varchar(200)
    '5',             -- CityID - int
    '252525',        -- PinCode - char(6)
    '1'              -- IsActive - bit
    );


--SELECT * FROM dbo.Employee;





--DECLARE @Email VARCHAR(100);
--SET @Email = 'ram@gmail.com'
--IF @Email in (SELECT DISTINCT E.Address FROM dbo.Employee E WHERE E.Address LIKE TRIM(@Email))
--BEGIN
--    SELECT * FROM dbo.Employee
--END
