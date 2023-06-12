
---------------------------------------------------------------------
-- Evaluating the Use of Cursor/Iterative Solutions vs. Set-Based Solutions
---------------------------------------------------------------------

---------------------------------------------------------------------
-- iterations for operations that have to be done per row
---------------------------------------------------------------------

-- procedure doing work for an input customer
USE TSQL2012;

IF OBJECT_ID(N'Sales.ProcessCustomer', N'P') IS NOT NULL
  DROP PROC Sales.ProcessCustomer;
GO

CREATE PROC Sales.ProcessCustomer
(
  @custid AS INT
)
AS

PRINT 'Processing customer ' + CAST(@custid AS VARCHAR(10));
GO

-- iterations with a cursor
SET NOCOUNT ON;

DECLARE @curcustid AS INT;

DECLARE cust_cursor CURSOR FAST_FORWARD FOR
  SELECT custid
  FROM Sales.Customers;

OPEN cust_cursor;

FETCH NEXT FROM cust_cursor INTO @curcustid;

WHILE @@FETCH_STATUS = 0
BEGIN
  EXEC Sales.ProcessCustomer @custid = @curcustid;

  FETCH NEXT FROM cust_cursor INTO @curcustid;
END;

CLOSE cust_cursor;

DEALLOCATE cust_cursor;
GO

-- iterations without a cursor
SET NOCOUNT ON;

DECLARE @curcustid AS INT;

SET @curcustid = (SELECT TOP (1) custid
                  FROM Sales.Customers
                  ORDER BY custid);

WHILE @curcustid IS NOT NULL
BEGIN
  EXEC Sales.ProcessCustomer @custid = @curcustid;
  
  SET @curcustid = (SELECT TOP (1) custid
                    FROM Sales.Customers
                    WHERE custid > @curcustid
                    ORDER BY custid);
END;
GO

