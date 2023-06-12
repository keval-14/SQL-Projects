
-- =============================================
-- Author:		<Keval Mangukiya>
-- Create date: <09-06-2023>
-- Description:	<Delete Employee from EmployeeTable by Employee Id>
-- =============================================
ALTER PROCEDURE SP_DeleteEmployeeById 
@EmployeeId INT,
@output INT OUT

AS
BEGIN
	DELETE FROM dbo.Employee WHERE EmployeeId = @EmployeeId
	SET @output = 1
END
GO

