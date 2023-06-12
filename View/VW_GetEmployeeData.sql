-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <01-06-2023>
-- Description:	<View for desplay all the Employees and can do edit and delete by using view instead of Employee table >
-- =======================================================================================================================================

USE [SQL-Practice]

CREATE VIEW VW_Employee
AS
SELECT * FROM dbo.Employee



SELECT * FROM VW_Employee

INSERT INTO VW_Employee VALUES('Ram','Vyas','M','2010-02-01','1','57000','ram@gmail.com','19','259898','1')

UPDATE VW_Employee SET Gender = 'F' WHERE EmployeeId = 41



