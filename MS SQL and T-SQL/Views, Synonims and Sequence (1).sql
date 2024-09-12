
USE tempdb;
GO
-- Create a synonym for the Product table in AdventureWorks2014.
CREATE SYNONYM MyProduct
FOR AdventureWorks2014.Production.Product;
GO
-- Query the Product table by using the synonym.
 

SELECT ProductID, Name FROM AdventureWorks2014.Production.Product
WHERE ProductID < 5;
GO


SELECT ProductID, Name FROM tempdb.dbo.MyProduct
WHERE ProductID < 5;
GO

CREATE SYNONYM MyEmployee 
FOR [127.0.0.1].AdventureWorks2014.HumanResources.Employee;
GO


SELECT * FROM MyEmployee


----------------------------------------------------------------------------------------
-- Creating the dbo.OrderDozen function
CREATE FUNCTION dbo.OrderDozen (@OrderAmt int)
RETURNS int
WITH EXECUTE AS CALLER
AS
BEGIN
IF @OrderAmt % 12 <> 0
BEGIN
    SET @OrderAmt +=  12 - (@OrderAmt % 12)
END
RETURN(@OrderAmt);
END;
GO

----------------------------------------------------------------------------------------
-- Using the dbo.OrderDozen function
DECLARE @Amt int
SET @Amt = 15
SELECT @Amt AS OriginalOrder, dbo.OrderDozen(@Amt) AS ModifiedOrder
-- Create a synonym dbo.CorrectOrder for the dbo.OrderDozen function.


----------------------------------------------------------------------------------------
CREATE SYNONYM dbo.CorrectOrder
FOR dbo.OrderDozen;
GO



DECLARE @Amt int
SET @Amt = 15
SELECT @Amt AS OriginalOrder, dbo.CorrectOrder(@Amt) AS ModifiedOrder
-- Create a synonym dbo.CorrectOrder for the dbo.OrderDozen function.


----------------------------------------------------------------------------------------

USE tempdb;
GO
-- Create a synonym for the Product table in AdventureWorks2014.
CREATE SYNONYM MyProduct
FOR AdventureWorks2014.Production.Product;
GO


-- Drop synonym MyProduct.
USE tempdb;
GO
DROP SYNONYM MyProduct;
GO


DROP SYNONYM IF EXISTS MyProduct;
GO



------------------------------------------------------------------------
USE tempdb
GO

CREATE SCHEMA Test ; 
GO 

CREATE SEQUENCE Test.TestSequence; 


SELECT NEXT VALUE FOR Test.TestSequence ;

------------------------------------------------------------------------

CREATE SEQUENCE Test.CountBy1  
    START WITH 1  
    INCREMENT BY 1 
GO 

SELECT NEXT VALUE FOR Test.CountBy1 


------------------------------------------------------------------------

CREATE SEQUENCE Test.CountByNeg1  
    START WITH 0  
    INCREMENT BY -1 ;  

SELECT NEXT VALUE FOR Test.CountByNeg1  

------------------------------------------------------------------------


SELECT * FROM sys.sequences 


SELECT * FROM sys.sequences where name = 'CountByNeg1'

------------------------------------------------------------------------
USE AdventureWorks2014
GO

CREATE SEQUENCE SmallSeq 
	AS tinyint 

SELECT NEXT VALUE FOR SmallSeq

------------------------------------------------------------------------
CREATE SCHEMA Test
GO

CREATE SEQUENCE Test.DecSeq  
    AS decimal(3,0)   
    START WITH 125  
    INCREMENT BY 25  
    MINVALUE 100  
    MAXVALUE 200  
    CYCLE  
    CACHE 3;  


SELECT NEXT VALUE FOR Test.DecSeq

SELECT cache_size, current_value  FROM sys.sequences  
WHERE name = 'DecSeq' ;   

------------------------------------------------------------------------


CREATE SEQUENCE Test.TestSeq  
    AS int   
    START WITH 125  
    INCREMENT BY 25  
    MINVALUE 100  
    MAXVALUE 200  
    CYCLE  
    CACHE 3 ;

SELECT NEXT VALUE FOR  Test.TestSeq  


ALTER SEQUENCE Test.TestSeq  
    RESTART WITH 100  
    INCREMENT BY 50  
    MINVALUE 50  
    MAXVALUE 200  
    NO CYCLE  
    NO CACHE;  


SELECT NEXT VALUE FOR  Test.TestSeq  


------------------------------------------------------------------------

USE AdventureWorks2014
GO

CREATE SEQUENCE Test.CountBy1 ;

SELECT NEXT VALUE FOR Test.CountBy1;

ALTER SEQUENCE Test.CountBy1 
RESTART WITH 1;  

SELECT NEXT VALUE FOR Test.CountBy1;

------------------------------------------------------------------------


DROP SEQUENCE Test.CountBy1 ;  
GO  


DROP SEQUENCE IF EXISTS CountBy1 ;  
GO  


----------------


------------------------------------------------------------------------



CREATE TABLE dbo.InsanlarOld
(
	id int identity(1,1),
	name nvarchar(20)
)

insert into dbo.InsanlarOld(name)
VALUES('Celil')

insert into dbo.InsanlarOld(name)
VALUES('Guler')

insert into dbo.InsanlarOld(name)
VALUES('Nurane')

select * from dbo.InsanlarOld

------------------------------------------------------------------------

CREATE SEQUENCE Test.InsanlarSEQ
    AS int   
    START WITH 10  
    INCREMENT BY 2  
    MINVALUE 1  
    MAXVALUE 200  
    CYCLE  
    CACHE 3 ;


CREATE TABLE dbo.InsanlarNew
(
	id int default next value for Test.InsanlarSEQ,
	name nvarchar(20)
)

insert into dbo.InsanlarNew(name)
VALUES('Celil')

insert into dbo.InsanlarNew(name)
VALUES('Guler')

insert into dbo.InsanlarNew(name)
VALUES('Nurane')

select * from dbo.InsanlarNew

-----------------------------------------------

