USE AdventureWorks2014 ;  
GO  
DROP VIEW IF EXISTS hiredate_view ;  
GO  


CREATE VIEW dbo.hiredate_view  
AS   
SELECT p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate  
FROM HumanResources.Employee AS e   
JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID ;  
GO  


SELECT * FROM dbo.hiredate_view


CREATE VIEW dbo.v_hiredate_view  
AS   
SELECT p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate  
FROM HumanResources.Employee AS e   
JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID ;  
GO 


SELECT * FROM dbo.v_hiredate_view

------------------------------------------------------------------------------------------------------


CREATE LOGIN narmin WITH PASSWORD='A1234'
GO

USE AdventureWorks2014
GO
CREATE USER [narmin] FOR LOGIN [narmin]
GO

SELECT * FROM AdventureWorks2014.Person.Person

GRANT SELECT ON AdventureWorks2014.Person.Person TO narmin

--bu sorgunu bashqa session-da narmin useri ile ishlet
SELECT * FROM AdventureWorks2014.Person.Person

REVOKE SELECT ON AdventureWorks2014.Person.Person FROM narmin

--bu sorgunu bashqa session-da narmin useri ile ishlet
SELECT * FROM AdventureWorks2014.Person.Person


CREATE VIEW dbo.v_PersonsInfo
AS
SELECT 
	BusinessEntityID,
	FirstName,
	LastName
FROM AdventureWorks2014.Person.Person

-- sa useri ile ishledi
SELECT * FROM AdventureWorks2014.dbo.v_PersonsInfo


-- indi ise narmin useri ile ferqli sessionda yoxlayiriq lakin neticede ishlemediyi goruruk. 
--cunki icaze verilmeyib
SELECT * FROM AdventureWorks2014.dbo.v_PersonsInfo


GRANT SELECT ON AdventureWorks2014.dbo.v_PersonsInfo TO narmin

-- icaze verdikden sonra lazim olan sutunlari Narmin useri ile gormush olacagiq
SELECT * FROM AdventureWorks2014.dbo.v_PersonsInfo


------------------------------------------------------------------------------------------------------


DROP VIEW IF EXISTS hiredate_view ;  
GO  

-- xeta verecek sebeb ise sorguda order by istifade olunmasidir
CREATE VIEW hiredate_view  
AS 
SELECT p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate  
FROM HumanResources.Employee e   
JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID 
order by e.BusinessEntityID;
 


CREATE VIEW hiredate_view  
AS 
SELECT TOP 500 p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate  
FROM HumanResources.Employee e   
JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID 
order by e.BusinessEntityID;


SELECT * FROM hiredate_view  
GO

---------------------------------------

CREATE VIEW dbo.v_persons
AS
SELECT 
	[BusinessEntityID] ,
	[PersonType] ,
	[Title] ,
	[FirstName] ,
	[LastName] ,
	[EmailPromotion],
	[rowguid] 
FROM [AdventureWorks2014].[Person].[Person] 
WHERE Title='Mr.'
  WITH CHECK OPTION

SELECT * FROM Person.BusinessEntity


SET IDENTITY_INSERT [Person].[BusinessEntity] ON

INSERT INTO [Person].[BusinessEntity]
           ([BusinessEntityID],
		    [rowguid]
           ,[ModifiedDate])
     VALUES  (50000,newid(),getdate())
GO

SET IDENTITY_INSERT [Person].[BusinessEntity] OFF


INSERT INTO [AdventureWorks2014].[Person].[Person]
( [BusinessEntityID] ,
	[PersonType] ,
	[Title] ,
	[FirstName] ,
	[LastName] ,
	[EmailPromotion],
	[rowguid]
)
VALUES(50000,	'EM',	'Mr.',	'Jossef',	'Goldberg',	0,	'0DEA28FD-EFFE-482A-AFD3-B7E8F199D544')

------------------------------------------------------------------

SET IDENTITY_INSERT [Person].[BusinessEntity] ON

INSERT INTO [Person].[BusinessEntity]
           ([BusinessEntityID],
		    [rowguid]
           ,[ModifiedDate])
     VALUES  (51000,newid(),getdate())
GO

SET IDENTITY_INSERT [Person].[BusinessEntity] OFF

------------------------------------------------------------------


SELECT * FROM dbo.v_persons 

SELECT * FROM dbo.v_persons where Title!='Mr.'



--The attempted insert or update failed because the target view either specifies WITH CHECK OPTION 
--or spans a view that specifies WITH CHECK OPTION and one or more rows resulting from the operation d
--id not qualify under the CHECK OPTION constraint.

INSERT INTO [AdventureWorks2014].dbo.v_persons
( [BusinessEntityID] ,
	[PersonType] ,
	[Title] ,
	[FirstName] ,
	[LastName] ,
	[EmailPromotion],
	[rowguid]
)
VALUES(51000,	'EM',	'Ms.',	'Jossef',	'Goldberg',	0,	'0DEA28FD-EFFE-482A-AFD3-B7E8F199D555')


-- OKAY oldu cunki  Title sutunu ucun "Mr." daxil etdik
INSERT INTO [AdventureWorks2014].dbo.v_persons
( [BusinessEntityID] ,
	[PersonType] ,
	[Title] ,
	[FirstName] ,
	[LastName] ,
	[EmailPromotion],
	[rowguid]
)
VALUES(51000,	'EM',	'Mr.',	'Jossef',	'Goldberg',	0,	'0DEA28FD-EFFE-482A-AFD3-B7E8F199D555')



--------------------------

USE AdventureWorks2014 ;  
GO  
CREATE VIEW Purchasing.PurchaseOrderReject  
WITH ENCRYPTION  
AS  
SELECT PurchaseOrderID, ReceivedQty, RejectedQty, RejectedQty / ReceivedQty AS RejectRatio, DueDate  FROM Purchasing.PurchaseOrderDetail  
WHERE RejectedQty / ReceivedQty > 0 AND DueDate > CONVERT(DATETIME,'20010630',101) ;  
GO 


SELECT * FROM Purchasing.PurchaseOrderReject  

-- yalandan deyishdi :))
ALTER VIEW Purchasing.PurchaseOrderReject  
AS
SELECT 1 as col1



DELETE FROM dbo.v_persons WHERE BusinessEntityID=51000


UPDATE dbo.v_persons SET [FirstName]='Abdullah' WHERE BusinessEntityID=50000



-------------------------------------------------------


--Create the tables and insert the values.  
CREATE TABLE dbo.SUPPLY1 (  
supplyID INT PRIMARY KEY CHECK (supplyID BETWEEN 1 and 150),  
supplier CHAR(50)  
); 


CREATE TABLE dbo.SUPPLY2 (  
supplyID INT PRIMARY KEY CHECK (supplyID BETWEEN 151 and 300),  
supplier CHAR(50)  
);

CREATE TABLE dbo.SUPPLY3 (  
supplyID INT PRIMARY KEY CHECK (supplyID BETWEEN 301 and 450),  
supplier CHAR(50)  
); 

CREATE TABLE dbo.SUPPLY4 (  
supplyID INT PRIMARY KEY CHECK (supplyID BETWEEN 451 and 600),  
supplier CHAR(50)  
); 
GO  



SELECT * FROM SUPPLY1
SELECT * FROM SUPPLY2
SELECT * FROM SUPPLY3
SELECT * FROM SUPPLY4

-- Faild 
INSERT INTO SUPPLY2
VALUES(50, 'Test')


--Success
INSERT INTO SUPPLY2
VALUES(155, 'Test')


SELECT * FROM SUPPLY1
SELECT * FROM SUPPLY2
SELECT * FROM SUPPLY3
SELECT * FROM SUPPLY4


SELECT * FROM SUPPLY1
UNION ALL
SELECT * FROM SUPPLY2
UNION ALL
SELECT * FROM SUPPLY3
UNION ALL
SELECT * FROM SUPPLY4



CREATE VIEW v_All_Supply
AS
	SELECT * FROM SUPPLY1
	UNION ALL
	SELECT * FROM SUPPLY2
	UNION ALL
	SELECT * FROM SUPPLY3
	UNION ALL
	SELECT * FROM SUPPLY4


SELECT * FROM v_All_Supply


INSERT INTO v_All_Supply
VALUES(50, 'Test')



SELECT * FROM SUPPLY1  --50 nomreli ID Bu cedvele insert gedib 
SELECT * FROM SUPPLY2
SELECT * FROM SUPPLY3
SELECT * FROM SUPPLY4

