--INSERT INTO [dbo].[VW_EmployeeandDept]
--(
--    FirstName,
--    LastName,
--    Gender,
--    DateofBirth,
--    DepartmentName,
--    Salary,
--    Address,
--    CityID,
--    PinCode,
--    IsActive
--)
--VALUES
--(   'Amir',                 -- FirstName - varchar(50)
--    'Dalal',                -- LastName - varbinary(50)
--    'M',                    -- Gender - char(1)
--    '2001-02-05',           -- DateofBirth - datetime
--    'Marketing',            -- DepartmentName - varchar(50)
--    '70000',                -- Salary - decimal(18, 2)
--    'helloamir@in.com', -- Address - varchar(200)
--    '5',                    -- CityID - int
--    '395820',               -- PinCode - char(6)
--    '1'                     -- IsActive - bit
--    );


SELECT * FROM dbo.Employee WHERE EmployeeId = 19
SELECT * FROM dbo.EmployeeTemp WHERE FK_EmployeeId = 19

EXEC SP_InsertOrUpdateIntoEmployeeTempTbl

TRUNCATE TABLE dbo.EmployeeTemp

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
(   'Ankita',               -- FirstName - varchar(50)
    'Kanani',            -- LastName - varbinary(50)
    'M',                     -- Gender - char(1)
    '2022-02-05',            -- DateofBirth - datetime
    '4',                     -- DepartmentID - int
    '20000',                 -- Salary - decimal(18, 2)
    'Ankita@Ankita.com', -- Address - varchar(200)
    '10',                    -- CityID - int
    '251414',                -- PinCode - char(6)
    '1'                      -- IsActive - bit
    );


UPDATE dbo.Employee SET FirstName='Keval',LastName = 'TestName',Gender='F',DateofBirth='1990-02-05',DepartmentID=5, Address='tatvatest@gmail.com', CityID=2, Salary=5000,PinCode=380001,IsActive=0 WHERE EmployeeId = 81


UPDATE dbo.Employee SET FirstName='Vyas',LastName = 'Shah' WHERE EmployeeId = 22
DELETE FROM dbo.Employee WHERE EmployeeId = 21