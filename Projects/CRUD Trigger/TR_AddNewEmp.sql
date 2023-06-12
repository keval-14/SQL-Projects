CREATE TRIGGER TR_AddNewEmp
ON dbo.Employee
FOR INSERT
AS
BEGIN
	DECLARE @id INT
	SELECT @id=Inserted.EmployeeId FROM Inserted
	INSERT INTO Notifications
	VALUES('message');
END

DROP TRIGGER TR_AddNewEmp

--SELECT * FROM notifications
