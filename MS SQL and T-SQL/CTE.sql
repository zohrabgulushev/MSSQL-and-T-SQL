

DECLARE 
	@x int
SET @x = 5
SELECT @x


----------------

DECLARE 
	@MyTableVar TABLE
(  
    ProductID int NOT NULL,   
    ProductName nvarchar(50) NOT NULL,  
    ProductModelID int NOT NULL,   
    PhotoID int NOT NULL
); 
SELECT * FROM @MyTableVar
INSERT INTO @MyTableVar(ProductID,ProductName,ProductModelID,PhotoID)
VALUES(1,'Kitab',3,5)
SELECT * FROM @MyTableVar
UPDATE @MyTableVar SET ProductName = 'Qelem' WHERE ProductID=1
SELECT * FROM @MyTableVar
DELETE FROM @MyTableVar WHERE ProductID=1
SELECT * FROM @MyTableVar

---------------------------------------
USE AdventureWorks2014
GO


-- Define the CTE expression name and column list.  
;WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)  
AS  
-- Define the CTE query.  
(  
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
)
-- Define the outer query referencing the CTE name.  
SELECT SalesYear, SalesPersonID, COUNT(SalesOrderID) AS TotalSales  
FROM Sales_CTE   
GROUP BY SalesYear, SalesPersonID  
ORDER BY SalesPersonID, SalesYear;  
GO  


---------------------------------------

WITH Sales_CTE (SalesPersonID, TotalSales, SalesYear)  
AS  
-- Define the first CTE query.
(  
    SELECT SalesPersonID, SUM(TotalDue) AS TotalSales, YEAR(OrderDate) AS SalesYear  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
    GROUP BY SalesPersonID, YEAR(OrderDate)  
)  
,   
-- Use a comma to separate multiple CTE definitions. Define the second CTE query, which returns sales quota data by year for each sales person.  
Sales_Quota_CTE (BusinessEntityID, SalesQuota, SalesQuotaYear)  
AS  
(  
       SELECT BusinessEntityID, SUM(SalesQuota)AS SalesQuota, YEAR(QuotaDate) AS SalesQuotaYear  
       FROM Sales.SalesPersonQuotaHistory  
       GROUP BY BusinessEntityID, YEAR(QuotaDate)  
)  
-- Define the outer query by referencing columns from both CTEs.  
SELECT 
	SalesPersonID  
  , SalesYear  
  , FORMAT(TotalSales,'C','en-us') AS TotalSales  
  , SalesQuotaYear  
  , FORMAT (SalesQuota,'C','en-us') AS SalesQuota  
  , FORMAT (TotalSales - SalesQuota, 'C','en-us') AS Amt_Above_or_Below_Quota  
FROM Sales_CTE  
INNER JOIN Sales_Quota_CTE ON Sales_Quota_CTE.BusinessEntityID = Sales_CTE.SalesPersonID  
                    AND Sales_CTE.SalesYear = Sales_Quota_CTE.SalesQuotaYear  
ORDER BY SalesPersonID, SalesYear;  
GO  

---------------------------------------

-- Create an Employee table.  
CREATE TABLE dbo.MyEmployees  
(  
	EmployeeID int NOT NULL,  
	FirstName nvarchar(30)  NOT NULL,  
	LastName  nvarchar(40) NOT NULL,  
	Title nvarchar(50) NOT NULL,  
	DeptID smallint NOT NULL,  
	ManagerID int NULL,  
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)   
);   
-- Populate the table with values.  
INSERT INTO dbo.MyEmployees VALUES   
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)  
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)  
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)  
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)  
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)  
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)  
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)  
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)  
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);  


SELECT * FROM dbo.MyEmployees


USE AdventureWorks2014;  
GO  


WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel) 
AS   
(  
    SELECT ManagerID, EmployeeID, Title, 0 AS EmployeeLevel FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1  
    FROM dbo.MyEmployees AS e INNER JOIN DirectReports AS d ON e.ManagerID = d.EmployeeID   
)  
SELECT ManagerID, EmployeeID, Title, EmployeeLevel FROM DirectReports  
ORDER BY EmployeeLevel;  
GO  

-------------------------


WITH DirectReports(Name, Title, EmployeeID, EmployeeLevel, Sort)  
AS 
(
	SELECT CONVERT(varchar(255), e.FirstName + ' ' + e.LastName),  
        e.Title,  
        e.EmployeeID,  
        1 as EmployeeLevel,  
        CONVERT(varchar(255), e.FirstName + ' ' + e.LastName)  as Sort
    FROM dbo.MyEmployees AS e  
    WHERE e.ManagerID IS NULL  
 UNION ALL  
    SELECT CONVERT(varchar(255), REPLICATE ('|    ' , EmployeeLevel) + e.FirstName + ' ' + e.LastName),  
        e.Title,  
        e.EmployeeID,  
        EmployeeLevel + 1,  
        CONVERT (varchar(255), RTRIM(Sort) + '|    ' + FirstName + ' ' + LastName) as Sort
    FROM dbo.MyEmployees AS e  
    INNER JOIN DirectReports AS d ON e.ManagerID = d.EmployeeID  
    )  
SELECT EmployeeID, Name, Title, EmployeeLevel FROM DirectReports   
ORDER BY Sort;  
GO  
