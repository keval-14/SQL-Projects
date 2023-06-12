-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <02-06-2023>
-- Description:	<Instead Of Insert Trigger on View VW_EmployeeandDept for check Valid Department Name entered by User and check for existing Email>
-- =======================================================================================================================================

USE [SQL-Practice]
GO

ALTER TRIGGER TR_InsertorUpdateInView
ON [dbo].[VW_EmployeeandDept]
INSTEAD OF INSERT
AS
DECLARE @DepartmentName VARCHAR(150);
SELECT @DepartmentName = I.DepartmentName
FROM Inserted I;

IF @DepartmentName NOT IN
   (
       SELECT D.DepartmentName FROM dbo.Department D
   )
BEGIN
    RAISERROR('Please Enter Valid Department Name', 10, 1);
    RETURN;
END;
ELSE
BEGIN
    DECLARE @fName VARCHAR(200);
    DECLARE @lName VARCHAR(200);
    DECLARE @gender CHAR(2);
    DECLARE @dob VARCHAR(20);
    DECLARE @deptId VARCHAR(10);
    DECLARE @salary BIGINT;
    DECLARE @emailAdd VARCHAR(200);
    DECLARE @cityId BIGINT;
    DECLARE @pinCode BIGINT;
    DECLARE @isActive BIT;

    SELECT @emailAdd = I.Address
    FROM Inserted I;
    IF @emailAdd NOT IN
       (
           SELECT DISTINCT E.Address FROM dbo.Employee E
       )
    BEGIN

        SELECT @fName = I.FirstName
        FROM Inserted I;
        SELECT @lName = I.LastName
        FROM Inserted I;
        SELECT @gender = I.Gender
        FROM Inserted I;
        SELECT @dob = I.DateofBirth
        FROM Inserted I;
        SELECT @deptId =
        (
            SELECT D.DepartmentID
            FROM dbo.Department D
            WHERE D.DepartmentName = @DepartmentName
        );
        SELECT @salary = I.Salary
        FROM Inserted I;
        SELECT @cityId = I.CityID
        FROM Inserted I;
        SELECT @pinCode = I.PinCode
        FROM Inserted I;
        SELECT @isActive = I.IsActive
        FROM Inserted I;

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
        (   @fName,    -- FirstName - varchar(50)
            @lName,    -- LastName - varbinary(50)
            @gender,   -- Gender - char(1)
            @dob,      -- DateofBirth - datetime
            @deptId,   -- DepartmentID - int
            @salary,   -- Salary - decimal(18, 2)
            @emailAdd, -- Address - varchar(200)
            @cityId,   -- CityID - int
            @pinCode,  -- PinCode - char(6)
            @isActive  -- IsActive - bit
            );
    END;
    ELSE
    BEGIN
        RAISERROR('Email Already Exists, Please Enter Different Email...!', 10, 1);
        RETURN;
    END;
END;
--PRINT @DepartmentName

