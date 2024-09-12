
------------------- CASE -------------------------

SELECT 1 as sutunadi, case 3
						when 1 then 'Bir'
						when 2 then 'Iki'
						when 3 then 'Uch'
						else 'Bilinmir'
					  end as CaseSutunu


USE AdventureWorks2014;  
GO  


SELECT   
	  ProductNumber,
	  ProductLine,
      CASE ProductLine  
         WHEN 'R' THEN 'Road'  
         WHEN 'M' THEN 'Mountain'  
         WHEN 'T' THEN 'Touring'  
         WHEN 'S' THEN 'Other sale items'  
         ELSE 'Not for sale'  
      END AS Category,  
     [Name]  
FROM Production.Product  
ORDER BY ProductNumber;  
GO  
--------------------------------

SELECT   
	  ProductNumber,
	  ProductLine,
      Category = CASE ProductLine  
         WHEN 'R' THEN 'Road'  
         WHEN 'M' THEN 'Mountain'  
         WHEN 'T' THEN 'Touring'  
         WHEN 'S' THEN 'Other sale items'  
         ELSE 'Not for sale'  
      END,  
     [Name]  
FROM Production.Product  
ORDER BY ProductNumber;  
GO  


--------------------------------

SELECT 
	BusinessEntityID, 
	SalariedFlag  
FROM HumanResources.Employee  
ORDER BY 
		CASE SalariedFlag WHEN 1 THEN BusinessEntityID END DESC,  
        CASE WHEN SalariedFlag = 0 THEN BusinessEntityID END ASC;  
GO


--------------------------------


SELECT 
	BusinessEntityID, 
	LastName, 
	TerritoryName, 
	CountryRegionName  
FROM Sales.vSalesPerson  
WHERE TerritoryName IS NOT NULL  
ORDER BY 
		CASE CountryRegionName 
			WHEN 'United States' THEN TerritoryName  
			ELSE CountryRegionName 
		END ASC;
GO

--------------------------

SELECT * FROM HumanResources.Employee  
WHERE SalariedFlag = 0;  


UPDATE HumanResources.Employee  
SET VacationHours =   
    ( 
	   CASE  
         WHEN ((VacationHours - 10.00) < 0) THEN VacationHours + 40  
         ELSE (VacationHours + 20.00)  
       END  
    )  
WHERE SalariedFlag = 0;  




SELECT * FROM HumanResources.Employee  
WHERE SalariedFlag = 0;  


----------------------------------------------


-- insert value for parameter BusinessEntityID
DECLARE @BusinessEntityID nvarchar(50) = 1000,
		@ContactType nvarchar(50);  


SET @ContactType =   
        CASE   
		-- Check for employee  
            WHEN EXISTS(SELECT * FROM HumanResources.Employee AS e   WHERE e.BusinessEntityID = @BusinessEntityID)    THEN 'Employee'  
		-- Check for store
            WHEN EXISTS(SELECT * FROM Person.BusinessEntityContact AS bec   WHERE bec.BusinessEntityID = @BusinessEntityID)  THEN 'Store Contact'  
		-- Check for vendor  
            WHEN EXISTS(SELECT * FROM Purchasing.Vendor AS v   WHERE v.BusinessEntityID = @BusinessEntityID)  THEN 'Vendor' 
		-- Check for individual consumer  
            WHEN EXISTS(SELECT * FROM Sales.Customer AS c   WHERE c.PersonID = @BusinessEntityID)  THEN 'Customer'  
        END;

PRINT @ContactType




SELECT * FROM HumanResources.Employee AS e   WHERE e.BusinessEntityID = 1000
SELECT * FROM Person.BusinessEntityContact AS bec   WHERE bec.BusinessEntityID = 1000
SELECT * FROM Purchasing.Vendor AS v   WHERE v.BusinessEntityID = 1000
SELECT * FROM Sales.Customer AS c   WHERE c.PersonID = 1000




------------------

SELECT  case 2
			when 1 then 'Bir'
			when 2 then 'Iki ***'
			when 2 then 'Iki'
			else 'Bilinmir'
		end as CaseSutunu

------------------



SELECT  case 5
			when 1 then 'Bir'
			when 2 then 'Iki ***'
			when 2 then 'Iki'
			else 'Bilinmir'
		end as CaseSutunu

------------------

SELECT  case 5
			when 1 then 'Bir'
			when 2 then 'Iki ***'
			when 2 then 'Iki'
		end as CaseSutunu

------------------------------------------------------


USE AdventureWorks2014;  
GO  



SELECT 
	JobTitle, 
	Gender, 
	MAX(ph1.Rate) AS MaximumRate  
FROM HumanResources.Employee AS e  
JOIN HumanResources.EmployeePayHistory AS ph1 
ON e.BusinessEntityID = ph1.BusinessEntityID  
GROUP BY JobTitle, Gender 
HAVING MAX(ph1.Rate) > 50 
ORDER BY MaximumRate DESC;  

--------------------------------------
SELECT 
	JobTitle, 
	Gender, 
	MAX(ph1.Rate) AS MaximumRate  
FROM HumanResources.Employee AS e  
JOIN HumanResources.EmployeePayHistory AS ph1 
ON e.BusinessEntityID = ph1.BusinessEntityID  
GROUP BY JobTitle, Gender 
HAVING MAX(CASE WHEN Gender = 'M' THEN ph1.Rate ELSE NULL END) > 40.00  
		OR
	   MAX(CASE WHEN Gender = 'F' THEN ph1.Rate ELSE NULL END) > 42.00
ORDER BY MaximumRate DESC;  

--------------------------------------

SELECT COALESCE(1,2,3,4,5,6)



SELECT COALESCE(NULL,NULL,NULL,4,5,6)



SELECT 
	[Name], 
	Class, 
	Color, 
	ProductNumber 
FROM Production.Product;  




SELECT 
	[Name], 
	Class, 
	Color, 
	ProductNumber,  
	COALESCE(Class, Color, ProductNumber) AS FirstNotNull  
FROM Production.Product;  



DECLARE @y nvarchar(20) = 'Unknown'
SELECT 
	[Name], 
	Class, 
	Color, 
	ProductNumber,  
	COALESCE(Class, Color, @y) AS FirstNotNull  
FROM Production.Product;  


----------------------------


USE tempdb
GO
DROP TABLE IF EXISTS wages
GO  
CREATE TABLE dbo.wages  
(  
    emp_id        tinyint   identity,  
    hourly_wage   decimal   NULL,  
    salary        decimal   NULL,  
    commission    decimal   NULL,  
    num_sales     tinyint   NULL  
);  
GO  



INSERT dbo.wages (hourly_wage, salary, commission, num_sales)  
VALUES  
    (10.00, NULL, NULL, NULL),  
    (20.00, NULL, NULL, NULL),  
    (30.00, NULL, NULL, NULL),  
    (40.00, NULL, NULL, NULL),  
    (NULL, 10000.00, NULL, NULL),  
    (NULL, 20000.00, NULL, NULL),  
    (NULL, 30000.00, NULL, NULL),  
    (NULL, 40000.00, NULL, NULL),  
    (NULL, NULL, 15000, 3),  
    (NULL, NULL, 25000, 2),  
    (NULL, NULL, 20000, 6),  
    (NULL, NULL, 14000, 4);  
GO  


SELECT  emp_id,
		hourly_wage, 
		salary, 
		commission, 
		num_sales,
		CAST(COALESCE(hourly_wage * 50, salary, commission * num_sales) AS money) AS 'Total Salary'   
FROM dbo.wages  
ORDER BY emp_id, 'Total Salary';  




------------------------------------  NOCOUNT ------------------------------------ 


SET NOCOUNT ON;

SELECT  emp_id,
		hourly_wage, 
		salary, 
		commission, 
		num_sales,
		CAST(COALESCE(hourly_wage * 50, salary, commission * num_sales) AS money) AS 'Total Salary'   
FROM dbo.wages  
ORDER BY emp_id, 'Total Salary';  




SELECT * FROM AdventureWorks2014.Production.Product


SET NOCOUNT OFF;


SELECT * FROM AdventureWorks2014.Production.Product


------------------------------------  OUTPUT ------------------------------------ 

USE AdventureWorks2014;  
GO  


SELECT * FROM dbo.DatabaseLog 

DELETE TOP(1) dbo.DatabaseLog 
WHERE DatabaseLogID = -5;  
GO  


--- inserted,  deleted

DELETE TOP(1) dbo.DatabaseLog 
OUTPUT deleted.*
WHERE DatabaseLogID = 7;  
GO  


SELECT * FROM dbo.DatabaseLog 
WHERE DatabaseLogID = 7

-------------------------------------------



USE AdventureWorks2014;  
GO  
CREATE TABLE dbo.TestOutput
( 
	NewScrapReasonID smallint,  
	[Name] varchar(50),  
	ModifiedDate datetime
);
  
INSERT dbo.TestOutput
VALUES (1, N'Operator error', GETDATE()); 


SELECT * FROM dbo.TestOutput


INSERT dbo.TestOutput
VALUES (2, N'Operator error', GETDATE()); 



INSERT dbo.TestOutput
OUTPUT INSERTED.NewScrapReasonID, INSERTED.Name, INSERTED.ModifiedDate  
VALUES (1, N'Operator error', GETDATE()); 


SELECT * FROM dbo.TestOutput

----------------------------------------


USE AdventureWorks2014;  
GO  
CREATE TABLE dbo.TestOutputUpdate
(  
    EmpID int NOT NULL,  
    OldVacationHours int,  
    NewVacationHours int,  
    ModifiedDate datetime
);  

INSERT INTO dbo.TestOutputUpdate(EmpID,OldVacationHours,NewVacationHours,ModifiedDate)
VALUES(1,13,12,getdate());


SELECT * FROM dbo.TestOutputUpdate



UPDATE TOP(10) dbo.TestOutputUpdate  
SET NewVacationHours = OldVacationHours * 1.25,  
    ModifiedDate = GETDATE()   
OUTPUT inserted.NewVacationHours,inserted.ModifiedDate,  
       deleted.NewVacationHours,deleted.ModifiedDate

---------------------------------------------------


USE AdventureWorks2014;  
GO  
CREATE TABLE #MyTable 
(  
    ProductID int NOT NULL,   
    ProductName nvarchar(50) NOT NULL,  
    ProductModelID int NOT NULL,   
    PhotoID int NOT NULL
);  
  


SELECT * FROM Production.ProductProductPhoto AS ph  
JOIN Production.Product as p   
    ON ph.ProductID = p.ProductID   
    WHERE p.ProductModelID BETWEEN 120 and 130; 




DELETE Production.ProductProductPhoto  
OUTPUT DELETED.ProductID,  
       p.Name,  
       p.ProductModelID,  
       DELETED.ProductPhotoID  
   INTO #MyTable  
FROM Production.ProductProductPhoto AS ph  
JOIN Production.Product as p   
    ON ph.ProductID = p.ProductID   
    WHERE p.ProductModelID BETWEEN 120 and 130;  
  
--Display the results of the table variable.  
SELECT * FROM #MyTable  