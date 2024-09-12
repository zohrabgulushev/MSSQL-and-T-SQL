USE AdventureWorks2014
GO
create table dbo.EmployeeSource
(
	EmployeeID int,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	Title nvarchar(100),
	RecruitmentDate datetime,
	Salary decimal,
	IsActive bit
)
GO

USE AdventureWorks2014
GO
create table dbo.EmployeeTarget
(
	EmployeeID int,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	Title nvarchar(100),
	RecruitmentDate datetime,
	Salary decimal,
	IsActive bit
)
GO

insert into dbo.EmployeeTarget 
values
(1, N'Murad', N'Memmedov', N'Team Leader', '20130412', 3000, 1),
(2, N'Tural', N'Ehmedov', N'DBA', '20100103', 2300, 1),
(3, N'Mahmud', N'Baxishov', N'Menecer', '20130303', 2000, 1),
(4, N'Aynur', N'Xelilova', N'Consultant', '20150618', 1200, 1)
GO


insert into dbo.EmployeeSource
values
(1, N'Samir', N'Qarayev', N'Team Leader', '20130417', 3000, 1),
(2, N'Tural', N'Ehmedov', N'DBA', '20100103', 2500, 1),
(3, N'Nadir', N'Huseynov', N'Consultant', '20120506', 1300, 1),
(5, N'Aynur', N'Xelilova', N'Consultant', '20150618', 1200, 0)
GO

select * from dbo.EmployeeSource
select * from dbo.EmployeeTarget

------------------------------------------------------------


MERGE INTO dbo.EmployeeTarget as t
USING dbo.EmployeeSource as s
ON t.EmployeeID = s.EmployeeID

WHEN MATCHED AND EXISTS(SELECT s.* EXCEPT SELECT t.*) THEN  
UPDATE SET	t.FirstName = s.FirstName, 
			t.LastName = s.LastName, 
			t.Title = s.Title, 
			t.RecruitmentDate = s.RecruitmentDate,
			t.Salary = s.Salary,
			t.IsActive = s.IsActive  

WHEN NOT MATCHED BY TARGET THEN
INSERT (EmployeeID, FirstName, LastName, Title, RecruitmentDate, Salary, IsActive)
VALUES (s.EmployeeID, s.FirstName, s.LastName, s.Title, s.RecruitmentDate, s.Salary, s.IsActive)

WHEN NOT MATCHED BY SOURCE THEN
DELETE

OUTPUT $action as DML_Komandalari,  deleted.*, inserted.*;


------------------------------------------------------------

select * from dbo.EmployeeSource
select * from dbo.EmployeeTarget

------------------------------------------------------------

select * from dbo.EmployeeSource
EXCEPT
select * from dbo.EmployeeTarget


------------------------------------------------------------
USE AdventureWorks2014
GO

CREATE FUNCTION dbo.ufnGetInventoryStock(@ProductID int)
RETURNS int 
AS 
BEGIN
    DECLARE @say int;
    SELECT @say = SUM(p.Quantity) FROM Production.ProductInventory p 
    WHERE p.ProductID = @ProductID 
        AND p.LocationID = '6';
     IF (@say IS NULL) 
        SET @say = 0;
    RETURN @say
END;





---------------------------------------------------------------------------

SELECT dbo.ufnGetInventoryStock(1) AS CurrentSupply

SELECT dbo.ufnGetInventoryStock(2) AS CurrentSupply

---------------------------------------------------------------------------


SELECT 
	ProductModelID, 
	[Name],
	ProductID, 
	dbo.ufnGetInventoryStock(ProductID) AS CurrentSupply 
FROM Production.Product


------------------------------------------------------------
exec dbo.ufnGetInventoryStock 1

------------------------------------------------------------
exec dbo.ufnGetInventoryStock @ProductID=1

------------------------------------------------------------
DECLARE @ReturnValue int;
exec  @ReturnValue=dbo.ufnGetInventoryStock @ProductID=1
SELECT @ReturnValue as CurrentSupply


------------------------------------------------------------

CREATE FUNCTION Sales.ufn_SalesByStore (@storeid int)
RETURNS TABLE
AS
RETURN 
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P 
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer AS C ON SH.CustomerID = C.CustomerID
    WHERE C.StoreID = @storeid
    GROUP BY P.ProductID, P.Name
);

----------------------------------------

SELECT * FROM Sales.ufn_SalesByStore(602);


--Msg 2809, Level 16, State 1, Line 158
-- The request for procedure 'ufn_SalesByStore' failed because 'ufn_SalesByStore' is a table valued function object.
EXEC Sales.ufn_SalesByStore @storeid=602;

---------------------------------------------------------

USE AdventureWorks2014;
GO

CREATE FUNCTION dbo.ufn_FindReports (@InEmpID INTEGER)
RETURNS @retFindReports TABLE 
(
    EmployeeID int primary key NOT NULL,
    FirstName nvarchar(255) NOT NULL,
    LastName nvarchar(255) NOT NULL,
    JobTitle nvarchar(50) NOT NULL,
    RecursionLevel int NOT NULL
)   --Returns a result set that lists all the employees who report to the specific employee directly or indirectly.*/
AS
BEGIN
			;WITH EMP_cte(EmployeeID, OrganizationNode, FirstName, LastName, JobTitle, RecursionLevel) 
			-- CTE name and columns
				AS (
					SELECT e.BusinessEntityID, e.OrganizationNode, p.FirstName, p.LastName, e.JobTitle, 0 
					-- Get the initial list of Employees for Manager n
					FROM HumanResources.Employee e 
					INNER JOIN Person.Person p  ON p.BusinessEntityID = e.BusinessEntityID
					WHERE e.BusinessEntityID = @InEmpID
				UNION ALL
					SELECT e.BusinessEntityID, e.OrganizationNode, p.FirstName, p.LastName, e.JobTitle, RecursionLevel + 1 
					-- Join recursive member to anchor
					FROM HumanResources.Employee e 
					INNER JOIN EMP_cte  ON e.OrganizationNode.GetAncestor(1) = EMP_cte.OrganizationNode
					INNER JOIN Person.Person p 
					ON p.BusinessEntityID = e.BusinessEntityID
					)
			-- copy the required columns to the result of the function 
			   INSERT INTO @retFindReports
			   SELECT EmployeeID, FirstName, LastName, JobTitle, RecursionLevel FROM EMP_cte 
			   RETURN
END;
GO


--------------------------------------------------------------


-- İndi isə yaratdığımız multistatement table-valued funksiyamızı icra edək. Bunu aşağıdakı kimi edirik:
SELECT 
	EmployeeID, 
	FirstName, 
	LastName, 
	JobTitle, 
	RecursionLevel
FROM dbo.ufn_FindReports(1); 
GO
