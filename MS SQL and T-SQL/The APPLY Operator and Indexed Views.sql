USE TSQLV4
GO


CREATE OR ALTER VIEW Sales.OrderTotals
WITH SCHEMABINDING
AS
SELECT
	O.orderid, O.custid, O.empid, O.shipperid, O.orderdate,
	O.requireddate, O.shippeddate,
	SUM(OD.qty) AS qty,
	CAST(SUM(OD.qty * OD.unitprice * (1 - OD.discount)) AS NUMERIC(12, 2)) AS val
FROM Sales.Orders AS O
INNER JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
GROUP BY
O.orderid, O.custid, O.empid, O.shipperid, O.orderdate,
O.requireddate, O.shippeddate;
GO

----------------------------
--Merge Inner Join
--Nested loops



SELECT * FROM [Sales].[OrderTotals]
WHERE orderid= 10256

--------------------------------

--ERROR bash verdi
USE TSQLV4
GO
CREATE UNIQUE CLUSTERED INDEX idx_cl_orderid 
ON Sales.OrderTotals(orderid);


-------------------------------
CREATE OR ALTER VIEW Sales.OrderTotals
WITH SCHEMABINDING
AS
SELECT
	O.orderid, O.custid, O.empid, O.shipperid, O.orderdate,
	O.requireddate, O.shippeddate,
	SUM(OD.qty) AS qty,
	CAST(SUM(OD.qty * OD.unitprice * (1 - OD.discount)) AS NUMERIC(12, 2)) AS val,
	COUNT_BIG(*) AS numorderlines
FROM Sales.Orders AS O
INNER JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
GROUP BY
O.orderid, O.custid, O.empid, O.shipperid, O.orderdate,
O.requireddate, O.shippeddate;
GO

-----------------------------
-- Yeniden bashqa ERROR bash verdi
CREATE UNIQUE CLUSTERED INDEX idx_cl_orderid 
ON Sales.OrderTotals(orderid);

-----------------------------------------



-------------------------------
CREATE OR ALTER VIEW Sales.OrderTotals
WITH SCHEMABINDING
AS
SELECT
	O.orderid, O.custid, O.empid, O.shipperid, O.orderdate,
	O.requireddate, O.shippeddate,
	SUM(OD.qty) AS qty,
	SUM(OD.qty * OD.unitprice * (1 - OD.discount)) AS val,
	COUNT_BIG(*) AS numorderlines
FROM Sales.Orders AS O
INNER JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
GROUP BY
O.orderid, O.custid, O.empid, O.shipperid, O.orderdate,
O.requireddate, O.shippeddate;
GO

-----------------------------
-- Bu defe Success oldu
CREATE UNIQUE CLUSTERED INDEX idx_cl_orderid 
ON Sales.OrderTotals(orderid);

-----------------------------------------


SELECT * FROM [Sales].[OrderTotals]
WHERE orderid= 10256


CREATE NONCLUSTERED INDEX idx_nc_custid ON Sales.OrderTotals(custid);
CREATE NONCLUSTERED INDEX idx_nc_empid ON Sales.OrderTotals(empid);
CREATE NONCLUSTERED INDEX idx_nc_shipperid ON Sales.OrderTotals(shipperid);
CREATE NONCLUSTERED INDEX idx_nc_orderdate ON Sales.OrderTotals(orderdate);
CREATE NONCLUSTERED INDEX idx_nc_shippeddate ON Sales.OrderTotals(shippeddate);


-----------------------------

DROP INDEX idx_nc_custid ON Sales.OrderTotals
DROP INDEX idx_nc_empid ON Sales.OrderTotals
DROP INDEX idx_nc_shipperid ON Sales.OrderTotals
DROP INDEX idx_nc_orderdate ON Sales.OrderTotals
DROP INDEX idx_nc_shippeddate ON Sales.OrderTotals

-----------------------------------

SELECT orderid, custid, empid, shipperid, orderdate,
requireddate, shippeddate, qty, val, numorderlines
FROM Sales.OrderTotals
WITH (NOEXPAND);

----------------------------------------

INSERT INTO Production.Suppliers
(companyname, contactname, contacttitle, address, city, postalcode, country, phone)
VALUES(N'Supplier XYZ', N'Jiru', N'Head of Security', N'42 Sekimai Musashino-shi',
N'Tokyo', N'01759', N'Japan', N'(02) 4311-2609');


----------------------------------------
SELECT TOP (2) 
	productid, 
	productname, 
	unitprice
FROM Production.Products
WHERE supplierid = 1
ORDER BY unitprice, productid
----------------------------------------



SELECT 
	S.supplierid, 
	S.companyname AS supplier, 
	A.*
FROM Production.Suppliers AS S
CROSS APPLY 
(
	SELECT TOP (2) 
		productid, 
		productname, 
		unitprice
	FROM Production.Products AS P
	WHERE P.supplierid=S.supplierid
	ORDER BY unitprice, productid
) AS A
WHERE S.country = N'Japan';


------------------------------------
 SELECT 
	S.supplierid, 
	S.companyname AS supplier, 
	A.*
FROM Production.Suppliers AS S
OUTER APPLY 
(
	SELECT TOP (2) 
		productid, 
		productname, 
		unitprice
	FROM Production.Products AS P
	WHERE P.supplierid=S.supplierid
	ORDER BY unitprice, productid
) AS A
WHERE S.country = N'Japan';

------------------------------------


CREATE FUNCTION Sales.fn_my_function(@supplierid int)
RETURNS @tmptbl TABLE 
( 
	productid int, 
	productname varchar(200), 
	unitprice decimal(10,4)
)
AS
BEGIN
        INSERT INTO @tmptbl
		SELECT TOP (2) productid, productname, unitprice
		FROM TSQLV4.Production.Products AS P
		WHERE P.supplierid = @supplierid
		ORDER BY unitprice, productid
RETURN 
END
GO


-------------------------

SELECT 
	S.supplierid, 
	S.companyname AS supplier, 
	A.*
FROM Production.Suppliers AS S
CROSS APPLY Sales.fn_my_function(S.supplierid) AS A
WHERE S.country = N'Japan';

---------------------------

SELECT 
	S.supplierid, 
	S.companyname AS supplier, 
	A.*
FROM Production.Suppliers AS S
OUTER APPLY Sales.fn_my_function(S.supplierid) AS A
WHERE S.country = N'Japan';