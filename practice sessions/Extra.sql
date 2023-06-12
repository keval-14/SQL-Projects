USE [SQL-Practice]
SELECT * FROM dbo.Employee
ORDER BY Salary DESC

SELECT * FROM dbo.Employee
SELECT * FROM dbo.City WHERE StateID IN (
SELECT StateID FROM dbo.State WHERE CountryID IN (4
,5,6,7))

SELECT * FROM dbo.City WHERE CityID IN (2,3,9,4,8)
SELECT * FROM dbo.State WHERE StateID IN (2,4,9,10)