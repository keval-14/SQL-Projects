/*List All User*/
SELECT *
FROM dbo.Employee;

/*List All Country*/
SELECT *
FROM dbo.Country;

/*List All State*/
SELECT *
FROM dbo.State;

/*List All State Of 5 different countries*/

SELECT s.StateName,
       c.CountryID
FROM State s
    JOIN
    (SELECT TOP 5 CountryID, CountryName FROM Country) c
        ON s.CountryID = c.CountryID;

/*List All Department*/
SELECT *
FROM dbo.Department;

/*List All Cities*/
SELECT *
FROM dbo.City;

/*List User Who have no address specified*/
SELECT *
FROM dbo.Employee E
WHERE E.Address IS NULL;

/*List User with of 5 different departments*/

SELECT *
FROM dbo.Employee
WHERE DepartmentID IN
      (
          SELECT DISTINCT TOP (5) DepartmentID FROM dbo.Employee
      );

--or

SELECT E.FirstName,
       E.LastName,
       E.DepartmentID,
       C.CityName,
       S.StateName,
       CN.CountryName
FROM(
(
    SELECT FirstName,
           LastName,
           CityID,
           DepartmentID,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY EmployeeId) AS rn
    FROM Employee
) E
    JOIN
    (SELECT TOP 5 DP.DepartmentID FROM dbo.Department DP) D
        ON D.DepartmentID = E.DepartmentID
    JOIN dbo.City C
        ON C.CityID = E.CityID
    JOIN dbo.State S
        ON S.StateID = C.StateID
    JOIN dbo.Country CN
        ON CN.CountryID = S.CountryID)
WHERE rn = 1;



/*List All Male Users*/
SELECT *
FROM dbo.Employee E
WHERE E.Gender = 'M';

/*List All Female Users*/
SELECT *
FROM dbo.Employee E
WHERE E.Gender = 'F';

/*List Users Whoes Last name is null*/
SELECT *
FROM dbo.Employee E
WHERE E.LastName = ''
      AND E.LastName IS NULL;

/*List Users Whoes Last name is not null*/
SELECT *
FROM dbo.Employee E
WHERE E.LastName != ''
      OR E.LastName IS NOT NULL;

/*List All Users with state,country,department,address Of 5 different department*/
SELECT *
FROM dbo.Employee
WHERE DepartmentID IN
      (
          SELECT DISTINCT TOP (5) DepartmentID FROM dbo.Employee
      )
	  ORDER BY DepartmentID

--or

SELECT DISTINCT
       E.DepartmentID,
       E.FirstName,
       E.LastName,
       E.Address,
       C.CityName,
       S.StateName,
       CN.CountryName
FROM dbo.Employee E
    JOIN dbo.City C
        ON C.CityID = E.CityID
    JOIN dbo.State S
        ON S.StateID = C.StateID
    JOIN dbo.Country CN
        ON CN.CountryID = S.CountryID
    JOIN
    (SELECT TOP 5 D.DepartmentID FROM dbo.Department D) DP
        ON DP.DepartmentID = E.DepartmentID;

--or

SELECT E.FirstName,
       E.LastName,
       D.DepartmentName,
       C.CityName,
       S.StateName,
       CN.CountryName
FROM(
(
    SELECT FirstName,
           LastName,
           CityID,
           DepartmentID,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY EmployeeId) AS rn
    FROM Employee
) E
    JOIN
    (
        SELECT TOP 5
               DP.DepartmentID,
               DP.DepartmentName
        FROM dbo.Department DP
    ) D
        ON D.DepartmentID = E.DepartmentID
    JOIN dbo.City C
        ON C.CityID = E.CityID
    JOIN dbo.State S
        ON S.StateID = C.StateID
    JOIN dbo.Country CN
        ON CN.CountryID = S.CountryID)
WHERE rn = 1;


/*List All Users with state,country,department,address Of 5 different States*/



SELECT E.FirstName,
       E.LastName,
       D.DepartmentName,
       C.CityName,
       S.StateName,
       CN.CountryName
FROM(
(
    SELECT FirstName,
           LastName,
           CityID,
           DepartmentID,
           ROW_NUMBER() OVER (PARTITION BY dbo.State.StateID ORDER BY EmployeeId) AS rn
    FROM Employee
) E
    JOIN
    (
        SELECT TOP 5
               DP.DepartmentID,
               DP.DepartmentName
        FROM dbo.Department DP
    ) D
        ON D.DepartmentID = E.DepartmentID
    JOIN dbo.City C
        ON C.CityID = E.CityID
    JOIN dbo.State S
        ON S.StateID = C.StateID
    JOIN dbo.Country CN
        ON CN.CountryID = S.CountryID)
WHERE rn = 1;

/*List All Users with state,country,department,address Of 5 different City*/

SELECT *
FROM dbo.Employee
WHERE CityID IN
      (
          SELECT DISTINCT TOP (5) CityID FROM dbo.Employee
      );

--or

SELECT E.FirstName,
       E.LastName,
       D.DepartmentName,
       CI.CityName,
       S.StateName,
       CN.CountryName
FROM(
(
    SELECT FirstName,
           LastName,
           CityID,
           DepartmentID,
           ROW_NUMBER() OVER (PARTITION BY CityID ORDER BY EmployeeId) AS rn
    FROM Employee
) E
    JOIN dbo.Department D
        ON D.DepartmentID = E.DepartmentID
    JOIN
    (SELECT TOP 5 C.CityID, C.CityName, C.StateID FROM dbo.City C) CI
        ON CI.CityID = E.CityID
    JOIN dbo.State S
        ON S.StateID = CI.StateID
    JOIN dbo.Country CN
        ON CN.CountryID = S.CountryID)
WHERE rn = 1;



/*List Users with all fields who is born aftre year 2000*/
SELECT *
FROM dbo.Employee E
WHERE YEAR(E.DateofBirth) > 2000;

/*List Users with all fields who is born before year 2000*/
SELECT *
FROM dbo.Employee E
WHERE YEAR(E.DateofBirth) < 2000;

/*List users whose birthday is 01-Jan-1990*/

SELECT *
FROM dbo.Employee E
WHERE E.DateofBirth = '01-Jan-1990';

/*List users whose birthday is between 01-Jan-1990 and 01-Jan-1995*/
SELECT *
FROM dbo.Employee E
WHERE E.DateofBirth >  '01-Jan-1990'
      AND E.DateofBirth <  '01-Jan-1995'

/*List All Users Order by Date of Birth*/
SELECT *
FROM dbo.Employee
ORDER BY DateofBirth;

/*List All Active and inactive users.*/
SELECT *
FROM dbo.Employee
ORDER BY IsActive;

--or
SELECT *
FROM dbo.Employee E
WHERE E.IsActive IN (0,1)
ORDER BY IsActive;


/*List all users whose First Name Start with  A*/
SELECT *
FROM dbo.Employee E
WHERE E.FirstName LIKE 'A%';

/*List All Users whose email address contains domain @server1.com*/
SELECT *
FROM dbo.Employee E
WHERE E.Address LIKE '%@server1.com';

/*List all users to whome department is not assigned*/
SELECT *
FROM dbo.Employee E
WHERE E.DepartmentID = ''
      and E.DepartmentID IS NULL;

/*List all female users from state gujarat*/
SELECT E.EmployeeId,
       E.FirstName,
       E.LastName,
       E.Gender,
       E.DateofBirth,
       E.DepartmentID,
       E.Salary,
       C.CityName,
       E.PinCode
FROM dbo.Employee E
    JOIN dbo.City C
        ON C.CityID = E.CityID
    JOIN dbo.State S
        ON C.StateID = S.StateID
WHERE E.Gender = 'F' AND S.StateName = 'Gujarat'

/*List all male users from City Mumbai*/
SELECT E.EmployeeId,
       E.FirstName,
       E.LastName,
       E.Gender,
       E.DateofBirth,
       E.DepartmentID,
       E.Salary,
       C.CityName,
       E.PinCode
FROM dbo.Employee E
    JOIN dbo.City C
        ON C.CityID = E.CityID
WHERE C.CityName = 'Mumbai' AND E.Gender ='M';

/*List User's all detail who belongs to account department*/
SELECT E.EmployeeId,
       E.FirstName,
       E.LastName,
       E.Gender,
       E.DateofBirth,
       E.DepartmentID,
       E.Salary,
       E.CityID,
       E.PinCode
FROM dbo.Employee E
    JOIN dbo.Department D
        ON D.DepartmentID = E.DepartmentID
WHERE D.DepartmentName = 'account';

/*List User's all detail whoes zip code is 380015*/
SELECT *
FROM dbo.Employee
WHERE PinCode = '380015';