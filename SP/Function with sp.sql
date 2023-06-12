--testing database


CREATE FUNCTION MultiplyTwoNumbers
(
	@num1 INT,
	@num2 INT
)
RETURNS INT
AS
BEGIN
	DECLARE @result INT

	SELECT @result = @num1 * @num2
	RETURN @result
END



--above function will be used in below sp for multiplying two numbers


ALTER PROCEDURE MultiplyTwoNumWithFunction
(
	@firstNumber int,
	@secondNumber int
)
AS
BEGIN
--DECLARE @setval int
	SELECT [dbo].[MultiplyTwoNumbers](@firstNumber, @secondNumber) AS Result
END


MultiplyTwoNumWithFunction 2,3


--table valued function

create FUNCTION GetAllSallaryTable(
	@sallary int
)
RETURNS @TempTable TABLE
(
	pid int, NAME varchar(50), dept varchar(50), slr int
)
AS	
BEGIN
	INSERT INTO @TempTable
	SELECT * FROM dbo.Sallary WHERE dbo.Sallary.Salary > @sallary

RETURN
END

SELECT * FROM GetAllSallaryTable(50000)


alter PROC SP_getSallary
@sallary int
AS
BEGIN
	SELECT 
	pid AS [Person ID],
	NAME AS [Person Name],
	dept AS [Department],
	slr AS [Sallary]
	
	
	FROM GetAllSallaryTable(@sallary)
END


SP_getSallary 50000
