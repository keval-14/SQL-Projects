/*write select query to find name of employee whose salary is highest.*/
SELECT TOP 1
       E.FirstName +' ' +E.LastName AS UserName,
       E.Salary
FROM dbo.Employee E
ORDER BY E.Salary DESC;

--or

SELECT 
       E.FirstName +' ' +E.LastName AS UserName,
       Salary
FROM dbo.Employee E
WHERE E.Salary = (SELECT MAX(Salary) AS Salary FROM dbo.Employee)



/*write select query to find name of employee whose salary is second highest.*/
SELECT *
FROM
(
    SELECT DENSE_RANK() OVER (ORDER BY E.Salary DESC) AS Number,
           E.FirstName +' ' +E.LastName AS UserName,
           E.Salary
    FROM dbo.Employee E
) T
WHERE T.Number = 4;


/*write select query to find name of employee whose salary is third highest.*/
SELECT E.FirstName +' ' +E.LastName AS UserName,
       E.Salary
FROM dbo.Employee E
ORDER BY E.Salary DESC OFFSET 2 ROW FETCH FIRST 1 ROW ONLY;

--or

SELECT *
FROM
(
    SELECT DENSE_RANK() OVER (ORDER BY E.Salary DESC) AS Number,
           E.FirstName +' ' +E.LastName AS UserName,
           E.Salary
    FROM dbo.Employee E
) T
WHERE T.Number = 3;


/*write select query to find name of employee whose salary is lowest.*/
SELECT TOP 1
       E.FirstName +' ' +E.LastName AS UserName,
       E.Salary
FROM dbo.Employee E
ORDER BY E.Salary;

--or

SELECT 
      E.FirstName +' ' +E.LastName AS UserName,
       Salary
FROM dbo.Employee E
WHERE E.Salary = (SELECT MIN(Salary) AS Salary FROM dbo.Employee)

/*write select query to find name of employee whose is from "USA" country*/
SELECT E.FirstName +' ' +E.LastName AS UserName,
       CN.CountryName
FROM dbo.Employee E
    INNER JOIN dbo.City C
        ON C.CityID = E.CityID
    INNER JOIN dbo.State S
        ON S.StateID = C.StateID
    INNER JOIN dbo.Country CN
        ON CN.CountryID = S.CountryID 
WHERE CN.CountryName = 'USA';


/*write select query to find number of employee of all department. It should return two columns:
1. EmployeeCount
2. Department Name
*/

SELECT E.DepartmentID,
       D.DepartmentName,
       COUNT(E.EmployeeId) AS EmployeeCount
FROM dbo.Employee E
    INNER JOIN dbo.Department D
        ON D.DepartmentID = E.DepartmentID
GROUP BY E.DepartmentID,
         D.DepartmentName;


/*write select query to find name of department who has highest paid salary employee*/

SELECT TOP 1
       E.DepartmentID,
       D.DepartmentName,
       E.Salary AS Salary
FROM dbo.Employee E
    INNER JOIN dbo.Department D
        ON D.DepartmentID = E.DepartmentID
ORDER BY Salary DESC;


/*write select query to find name of state whose zip code is "510240"*/
SELECT S.StateName
FROM dbo.Employee E
    INNER JOIN dbo.City C
        ON C.CityID = E.CityID
    INNER JOIN dbo.State S
        ON S.StateID = C.StateID
WHERE E.PinCode = '510240';

SELECT S.StateName FROM dbo.State S INNER JOIN dbo.City C ON C.StateID = S.StateID
INNER JOIN dbo.Employee E ON E.CityID = C.CityID
WHERE E.PinCode = '510240'


/*write select query to find name of employee who is younger most (smallest age employee)*/

SELECT TOP 1
       E.FirstName +' ' +E.LastName AS UserName,
       DATEDIFF(YEAR, E.DateofBirth, GETDATE()) AS Age
FROM dbo.Employee E
ORDER BY Age;


/*write select query to find name of country for which we don't have any employee.*/

SELECT CNT.CountryID, CNT.CountryName
FROM dbo.Country CNT
WHERE CNT.CountryName NOT IN
      (
          SELECT DISTINCT
                 CN.CountryName
          FROM dbo.Employee E
              INNER JOIN dbo.City C
                  ON C.CityID = E.CityID
              INNER JOIN dbo.State S
                  ON S.StateID = C.StateID
              INNER JOIN dbo.Country CN
                  ON CN.CountryID = S.CountryID
      );

/*if DA is 20% of salary then find DA for all employee. It should return three columns:
1. EmployeeName
2. Salary
3. DA
*/

SELECT E.FirstName +' ' +E.LastName AS UserName,
       E.Salary,
       CAST((E.Salary * 0.20) AS INT) AS DA
FROM dbo.Employee E;


/*List All users with Age (Only Year) Like 25,26,20*/

SELECT E.FirstName +' ' +E.LastName AS UserName,
       DATEDIFF(YEAR, E.DateofBirth, GETDATE()) AS [Age(Year)]
FROM dbo.Employee E
ORDER BY [Age(Year)];


/*List Users who is born in particular month.month will pass as parameter of stored procedure.*/

--SP_GetUserByBirthMonth 1

alter PROC SP_GetUserByBirthMonth
	@birthMonth int
AS
BEGIN
	SELECT * FROM dbo.Employee E 
	WHERE DATEPART(MONTH,E.DateofBirth) = @birthMonth
END

SELECT DATENAME(MONTH,'20230101')


/*List users who born on date 21th  of any month and any year*/

SELECT *
FROM dbo.Employee E
WHERE DATEPART(DAY, E.DateofBirth) = 21;


/*List All Departments who has only 4 Users*/
SELECT *
FROM
(
    SELECT E.DepartmentID,
           D.DepartmentName,
           COUNT(E.EmployeeId) AS EmployeeCount
    FROM dbo.Employee E
        INNER JOIN dbo.Department D
            ON D.DepartmentID = E.DepartmentID
    GROUP BY E.DepartmentID,
             D.DepartmentName
) T
WHERE T.EmployeeCount = 4;


/*List All States from India & Number of users in it. It should return two columns: (If there are no users in any state, State name should also come in result)
1. State
2. UserCount
*/


SELECT DISTINCT
       S1.StateName,
       COUNT(E.EmployeeId) AS UserCount
FROM dbo.Employee E
    RIGHT JOIN dbo.City C
        ON C.CityID = E.CityID
    RIGHT JOIN dbo.State S1
        ON S1.StateID = C.StateID
WHERE S1.StateName IN
      (
          SELECT S.StateName
          FROM dbo.State S
              INNER JOIN dbo.Country CN
                  ON CN.CountryID = S.CountryID
          WHERE CN.CountryName = 'India'
      )
GROUP BY S1.StateName;

--or

SELECT s.StateName,
       COUNT(e.EmployeeId) AS UserCount
FROM State s
    LEFT JOIN City c
        ON s.StateID = c.StateID
    LEFT JOIN Employee e
        ON c.CityID = e.CityID
    INNER JOIN Country co
        ON s.CountryID = co.CountryID
WHERE co.CountryName = 'India'
GROUP BY s.StateName;




/*Find Active & Inactive User Count from Ahmedabad City*/
SELECT C.CityName,
       (CASE E.IsActive
            WHEN 1 THEN
                'Yes'
            WHEN 0 THEN
                'No'
        END
       ) AS IsActive,
       COUNT(E.FirstName) AS UserCount
FROM dbo.Employee E
    INNER JOIN dbo.City C
        ON C.CityID = E.CityID
WHERE E.IsActive IN ( 0, 1 )
      AND C.CityName = 'Ahmedabad'
GROUP BY C.CityName,
         E.IsActive;


/*List All States from which there are any Male Employees.*/

SELECT DISTINCT
       S.StateName
FROM dbo.Employee E
    INNER JOIN dbo.City C
        ON C.CityID = E.CityID
    INNER JOIN dbo.State S
        ON S.StateID = C.StateID
WHERE E.Gender = 'M';














