
---------------------------------------------------------------------
-- Using the IDENTITY Column Property
---------------------------------------------------------------------

-- create table Sales.MyOrders
USE TSQL2012;
IF OBJECT_ID(N'Sales.MyOrders', N'U') IS NOT NULL DROP TABLE Sales.MyOrders;
GO

CREATE TABLE Sales.MyOrders
(
  orderid INT NOT NULL IDENTITY(1, 1)
    CONSTRAINT PK_MyOrders_orderid PRIMARY KEY,
  custid  INT NOT NULL
    CONSTRAINT CHK_MyOrders_custid CHECK(custid > 0),
  empid   INT NOT NULL
    CONSTRAINT CHK_MyOrders_empid CHECK(empid > 0),
  orderdate DATE NOT NULL
);

-- insert some rows
INSERT INTO Sales.MyOrders(custid, empid, orderdate) VALUES
  (1, 2, '20120620'),
  (1, 3, '20120620'),
  (2, 2, '20120620');

SELECT * FROM Sales.MyOrders;

-- identity-related functions
SELECT
  SCOPE_IDENTITY()                AS SCOPE_IDENTITY,
  @@IDENTITY                      AS [@@IDENTITY],
  IDENT_CURRENT('Sales.MyOrders') AS IDENT_CURRENT;

-- clear the table
TRUNCATE TABLE Sales.MyOrders;

-- see that identity was reset
SELECT IDENT_CURRENT('Sales.MyOrders') AS [IDENT_CURRENT];

-- reseed
DBCC CHECKIDENT('Sales.MyOrders', RESEED, 4);

INSERT INTO Sales.MyOrders(custid, empid, orderdate) VALUES(2, 2, '20120620');
SELECT * FROM Sales.MyOrders;

-- can have gaps (will fail)
INSERT INTO Sales.MyOrders(custid, empid, orderdate) VALUES(3, -1, '20120620');

INSERT INTO Sales.MyOrders(custid, empid, orderdate) VALUES(3, 1, '20120620');

SELECT * FROM Sales.MyOrders;

---------------------------------------------------------------------
-- Using the Sequence Object
---------------------------------------------------------------------

-- create sequence
IF OBJECT_ID(N'Sales.SeqOrderIDs', N'SO') IS NOT NULL DROP SEQUENCE Sales.SeqOrderIDs;

CREATE SEQUENCE Sales.SeqOrderIDs AS INT
  MINVALUE 1
  CYCLE;

-- request a new value; run 3 times
SELECT NEXT VALUE FOR Sales.SeqOrderIDs;

-- alter sequence properties (all besides type)
ALTER SEQUENCE Sales.SeqOrderIDs
  RESTART WITH 1;

-- recreate Sales.MyOrders table
IF OBJECT_ID(N'Sales.MyOrders', N'U') IS NOT NULL DROP TABLE Sales.MyOrders;
GO

CREATE TABLE Sales.MyOrders
(
  orderid INT NOT NULL
    CONSTRAINT PK_MyOrders_orderid PRIMARY KEY,
  custid  INT NOT NULL
    CONSTRAINT CHK_MyOrders_custid CHECK(custid > 0),
  empid   INT NOT NULL
    CONSTRAINT CHK_MyOrders_empid CHECK(empid > 0),
  orderdate DATE NOT NULL
);

-- use in INSERT VALUES
INSERT INTO Sales.MyOrders(orderid, custid, empid, orderdate) VALUES
  (NEXT VALUE FOR Sales.SeqOrderIDs, 1, 2, '20120620'),
  (NEXT VALUE FOR Sales.SeqOrderIDs, 1, 3, '20120620'),
  (NEXT VALUE FOR Sales.SeqOrderIDs, 2, 2, '20120620');

-- use in INSERT SELECT
INSERT INTO Sales.MyOrders(orderid, custid, empid, orderdate)
  SELECT
    NEXT VALUE FOR Sales.SeqOrderIDs OVER(ORDER BY orderid),
    custid, empid, orderdate
  FROM Sales.Orders
  WHERE custid = 1;

SELECT * FROM Sales.MyOrders;

-- add as default constraint
ALTER TABLE Sales.MyOrders
  ADD CONSTRAINT DFT_MyOrders_orderid
    DEFAULT(NEXT VALUE FOR Sales.SeqOrderIDs) FOR orderid;

-- add rows without explicitly specifying orderid
INSERT INTO Sales.MyOrders(custid, empid, orderdate)
  SELECT
    custid, empid, orderdate
  FROM Sales.Orders
  WHERE custid = 2;



---------------------------------------------------------------------
-- Merging Data
---------------------------------------------------------------------

-- clear table and reset sequence if the already exist
TRUNCATE TABLE Sales.MyOrders;
ALTER SEQUENCE Sales.SeqOrderIDs RESTART WITH 1;

-- create table and sequence if they don't already exist
IF OBJECT_ID(N'Sales.MyOrders', N'U') IS NOT NULL DROP TABLE Sales.MyOrders;
IF OBJECT_ID(N'Sales.SeqOrderIDs', N'SO') IS NOT NULL DROP SEQUENCE Sales.SeqOrderIDs;

CREATE SEQUENCE Sales.SeqOrderIDs AS INT
  MINVALUE 1
  CYCLE;

CREATE TABLE Sales.MyOrders
(
  orderid INT NOT NULL
    CONSTRAINT PK_MyOrders_orderid PRIMARY KEY
    CONSTRAINT DFT_MyOrders_orderid
      DEFAULT(NEXT VALUE FOR Sales.SeqOrderIDs),
  custid  INT NOT NULL
    CONSTRAINT CHK_MyOrders_custid CHECK(custid > 0),
  empid   INT NOT NULL
    CONSTRAINT CHK_MyOrders_empid CHECK(empid > 0),
  orderdate DATE NOT NULL
);

-- SELECT without FROM
DECLARE
  @orderid   AS INT  = 1,
  @custid    AS INT  = 1,
  @empid     AS INT  = 2,
  @orderdate AS DATE = '20120620';

SELECT *
FROM (SELECT @orderid, @custid, @empid, @orderdate )
      AS SRC( orderid,  custid,  empid,  orderdate );
GO
      
-- table value constructor
DECLARE
  @orderid   AS INT  = 1,
  @custid    AS INT  = 1,
  @empid     AS INT  = 2,
  @orderdate AS DATE = '20120620';

SELECT *
FROM (VALUES(@orderid, @custid, @empid, @orderdate))
      AS SRC( orderid,  custid,  empid,  orderdate);

GO

-- update where exists, insert where not exists
DECLARE
  @orderid   AS INT  = 1,
  @custid    AS INT  = 1,
  @empid     AS INT  = 2,
  @orderdate AS DATE = '20120620';

MERGE INTO Sales.MyOrders WITH (HOLDLOCK) AS TGT
USING (VALUES(@orderid, @custid, @empid, @orderdate))
       AS SRC( orderid,  custid,  empid,  orderdate)
  ON SRC.orderid = TGT.orderid
WHEN MATCHED THEN UPDATE
  SET TGT.custid    = SRC.custid,
      TGT.empid     = SRC.empid,
      TGT.orderdate = SRC.orderdate
WHEN NOT MATCHED THEN INSERT
  VALUES(SRC.orderid, SRC.custid, SRC.empid, SRC.orderdate);
GO

-- update where exists (only if different), insert where not exists
DECLARE
  @orderid   AS INT  = 1,
  @custid    AS INT  = 1,
  @empid     AS INT  = 2,
  @orderdate AS DATE = '20120620';

MERGE INTO Sales.MyOrders WITH (HOLDLOCK) AS TGT
USING (VALUES(@orderid, @custid, @empid, @orderdate))
       AS SRC( orderid,  custid,  empid,  orderdate)
  ON SRC.orderid = TGT.orderid
WHEN MATCHED AND (   TGT.custid    <> SRC.custid
                  OR TGT.empid     <> SRC.empid
                  OR TGT.orderdate <> SRC.orderdate) THEN UPDATE
  SET TGT.custid    = SRC.custid,
      TGT.empid     = SRC.empid,
      TGT.orderdate = SRC.orderdate
WHEN NOT MATCHED THEN INSERT
  VALUES(SRC.orderid, SRC.custid, SRC.empid, SRC.orderdate);
GO

-- table as source
DECLARE @Orders AS TABLE
(
  orderid   INT  NOT NULL PRIMARY KEY,
  custid    INT  NOT NULL,
  empid     INT  NOT NULL,
  orderdate DATE NOT NULL
);

INSERT INTO @Orders(orderid, custid, empid, orderdate) VALUES
  (2, 1, 3, '20120612'),
  (3, 2, 2, '20120612'),
  (4, 3, 5, '20120612');

-- update where exists (only if different), insert where not exists,
-- delete when exists in target but not in source
MERGE INTO Sales.MyOrders AS TGT
USING @Orders AS SRC
  ON SRC.orderid = TGT.orderid
WHEN MATCHED AND (   TGT.custid    <> SRC.custid
                  OR TGT.empid     <> SRC.empid
                  OR TGT.orderdate <> SRC.orderdate) THEN UPDATE
  SET TGT.custid    = SRC.custid,
      TGT.empid     = SRC.empid,
      TGT.orderdate = SRC.orderdate
WHEN NOT MATCHED THEN INSERT
  VALUES(SRC.orderid, SRC.custid, SRC.empid, SRC.orderdate)
WHEN NOT MATCHED BY SOURCE THEN
  DELETE;

-- query table
SELECT *
FROM Sales.MyOrders;

---------------------------------------------------------------------
-- Using the OUTPUT Option 
---------------------------------------------------------------------

-- clear table and reset sequence if the already exist
TRUNCATE TABLE Sales.MyOrders;
ALTER SEQUENCE Sales.SeqOrderIDs RESTART WITH 1;

-- create table and sequence if they don't already exist
IF OBJECT_ID(N'Sales.MyOrders', N'U') IS NOT NULL DROP TABLE Sales.MyOrders;
IF OBJECT_ID(N'Sales.SeqOrderIDs', N'SO') IS NOT NULL DROP SEQUENCE Sales.SeqOrderIDs;

CREATE SEQUENCE Sales.SeqOrderIDs AS INT
  MINVALUE 1
  CYCLE;

CREATE TABLE Sales.MyOrders
(
  orderid INT NOT NULL
    CONSTRAINT PK_MyOrders_orderid PRIMARY KEY
    CONSTRAINT DFT_MyOrders_orderid
      DEFAULT(NEXT VALUE FOR Sales.SeqOrderIDs),
  custid INT NOT NULL
    CONSTRAINT CHK_MyOrders_custid CHECK(custid > 0),
  empid   INT NOT NULL
    CONSTRAINT CHK_MyOrders_empid CHECK(empid > 0),
  orderdate DATE NOT NULL
);

-- INSERT with OUTPUT
INSERT INTO Sales.MyOrders(custid, empid, orderdate)
  OUTPUT
    inserted.orderid, inserted.custid, inserted.empid, inserted.orderdate
  SELECT custid, empid, orderdate
  FROM Sales.Orders
  WHERE shipcountry = N'Norway';

-- could use INTO
INSERT INTO Sales.MyOrders(custid, empid, orderdate)
  OUTPUT
    inserted.orderid, inserted.custid, inserted.empid, inserted.orderdate
    INTO SomeTable(orderid, custid, empid, orderdate)
  SELECT custid, empid, orderdate
  FROM Sales.Orders
  WHERE shipcountry = N'Norway';

-- DELETE with OUTPUT
DELETE FROM Sales.MyOrders
  OUTPUT deleted.orderid
WHERE empid = 1;

-- UPDATE with OUTPUT
UPDATE Sales.MyOrders
  SET orderdate = DATEADD(day, 1, orderdate)
  OUTPUT
    inserted.orderid,
    deleted.orderdate AS old_orderdate,
    inserted.orderdate AS neworderdate
WHERE empid = 7;



-- cleanup
IF OBJECT_ID(N'Sales.MyOrders', N'U') IS NOT NULL
  DROP TABLE Sales.MyOrders;
IF OBJECT_ID(N'Sales.SeqOrderIDs', N'SO') IS NOT NULL
  DROP SEQUENCE Sales.SeqOrderIDs;

