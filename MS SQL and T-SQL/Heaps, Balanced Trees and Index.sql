USE AdventureWorks2014 
GO 
CREATE TABLE dbo.TestStructure
(
	id INT NOT NULL,
	filler1 CHAR(36) NOT NULL,
	filler2 CHAR(216) NOT NULL
);


SELECT * FROM dbo.TestStructure

INSERT INTO dbo.TestStructure
VALUES(5,'Test5','Test5')

INSERT INTO dbo.TestStructure
VALUES(3,'Test5','Test5')


INSERT INTO dbo.TestStructure
VALUES(2,'Test5','Test5')


INSERT INTO dbo.TestStructure
VALUES(4,'Test5','Test5')


INSERT INTO dbo.TestStructure
VALUES(1,'Test5','Test5')

SELECT * FROM dbo.TestStructure 

SELECT * FROM dbo.TestStructure 
WHERE id = 4

--- Heaps Table - (Table Scan)


--------------------------

SELECT 
	OBJECT_NAME([object_id]) AS table_name,
	[name] AS index_name, 
	[type], 
	[type_desc]
FROM sys.indexes
WHERE [object_id] = OBJECT_ID(N'[HumanResources].[Department]', N'U');


SELECT 
	OBJECT_NAME([object_id]) AS table_name,
	[name] AS index_name, 
	[type], 
	[type_desc]
FROM sys.indexes
WHERE [object_id] = OBJECT_ID(N'[dbo].[TestStructure]', N'U');

SELECT DB_ID(N'AdventureWorks2014')

SELECT DB_ID(N'Test123')

SELECT OBJECT_ID(N'[HumanResources].[Department]')



SELECT 
	index_type_desc, 
	page_count,
	record_count, 
	avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats
(DB_ID(N'AdventureWorks2014'), OBJECT_ID(N'[HumanResources].[Department]'), NULL, NULL , 'DETAILED');


SELECT * FROM [HumanResources].[Department]


EXEC dbo.sp_spaceused @objname = N'[HumanResources].[Department]', @updateusage = true;


SELECT * FROM [dbo].[TestStructure]


SELECT * FROM [dbo].[TestStructure]
ORDER BY ID ASC


SELECT * FROM [dbo].[TestStructure]
ORDER BY ID DESC


SELECT * FROM [dbo].[TestStructure]

--OKAY
ALTER TABLE [dbo].[TestStructure]
ADD PRIMARY KEY ([id])


SELECT * FROM [dbo].[TestStructure]

-- Fail: Table 'TestStructure' already has a primary key defined on it.
ALTER TABLE [dbo].[TestStructure]
ADD PRIMARY KEY ([filler1])

--Fail: Cannot create more than one clustered index on table 'dbo.TestStructure'.
CREATE CLUSTERED INDEX [IX_TestStructure_filler1]
ON [dbo].[TestStructure]([filler1])

--Fail: because it does not exist or you do not have permission.
DROP INDEX [IX_TestStructure_filler1] ON [dbo].[TestStructure]

--Fail: It is being used for PRIMARY KEY constraint enforcement.
DROP INDEX [PK__TestStru__3213E83F3F895226] ON [dbo].[TestStructure]

--Okay : PK silindi
ALTER TABLE [dbo].[TestStructure]
DROP CONSTRAINT [PK__TestStru__3213E83F3F895226]

--Okay
CREATE CLUSTERED INDEX [IX_TestStructure_filler1]
ON [dbo].[TestStructure]([id])

--Okay
DROP INDEX [IX_TestStructure_filler1] ON [dbo].[TestStructure]

INSERT INTO dbo.TestStructure
VALUES(6,'EDFG','EDFG')

INSERT INTO dbo.TestStructure
VALUES(8,'ABCE','EDFG')

INSERT INTO dbo.TestStructure
VALUES(7,'FGTR','FGTR')

INSERT INTO dbo.TestStructure
VALUES(7,'AAAA','AAAA')

SELECT * FROM dbo.TestStructure

--Okay
CREATE CLUSTERED INDEX [IX_TestStructure_filler1]
ON [dbo].[TestStructure]([id] DESC, [filler1] ASC)

SELECT * FROM dbo.TestStructure

SELECT * FROM dbo.TestStructure
WHERE ID=4


SELECT * FROM dbo.TestStructure
WHERE ID=4 AND [filler1] ='Test5'

SELECT * FROM dbo.TestStructure
WHERE [filler1] ='Test5'

SELECT * FROM dbo.TestStructure
WHERE [filler2] ='Test5'


SELECT * FROM dbo.TestStructure
WHERE [filler1] ='Test5' AND ID=4

--Okay
DROP INDEX [IX_TestStructure_filler1] ON [dbo].[TestStructure]


-----------------------------

USE AdventureWorks2014;  
GO     
DROP INDEX IF EXISTS IX_ProductVendor_BusinessEntityID ON Purchasing.ProductVendor;
 
SELECT * FROM Purchasing.ProductVendor 

SELECT * FROM Purchasing.ProductVendor 
WHERE BusinessEntityID  = 1678


CREATE NONCLUSTERED INDEX IX_ProductVendor_BusinessEntityID   
    ON Purchasing.ProductVendor (BusinessEntityID);   
GO  

SELECT * FROM Purchasing.ProductVendor 
WHERE BusinessEntityID  = 1678


SELECT * FROM dbo.TestStructure

DROP INDEX IF EXISTS IX_TestStructure_filler1 
ON dbo.TestStructure

--FAIL: because a duplicate key was found - The duplicate key value is (Test5)
CREATE UNIQUE INDEX IX_TestStructure_filler1
ON dbo.TestStructure(filler1 ASC)

--FAIL: 7 ededi iki dene var idi.
CREATE UNIQUE INDEX IX_TestStructure_id
ON dbo.TestStructure(id ASC)


DELETE FROM dbo.TestStructure WHERE id=7 and filler1='AAAA'

CREATE UNIQUE INDEX IX_TestStructure_id
ON dbo.TestStructure(id ASC)

--------------------
SELECT 
	ProductAssemblyID, 
	ComponentID,
	StartDate,
	EndDate
FROM Production.BillOfMaterials



SELECT 
	ProductAssemblyID, 
	ComponentID,
	StartDate   
FROM Production.BillOfMaterials  
WHERE EndDate IS NOT NULL   
    AND ComponentID = 5   
    AND StartDate > '01/01/2008' ;  
GO 


CREATE NONCLUSTERED INDEX IX_DATACADEMY
ON Production.BillOfMaterials (EndDate,ComponentID,StartDate)


SELECT 
	ProductAssemblyID, 
	ComponentID,
	StartDate   
FROM Production.BillOfMaterials  
WHERE EndDate IS NOT NULL   
    AND ComponentID = 5   
    AND StartDate > '01/01/2008' ;  
GO 


DROP INDEX IX_DATACADEMY ON Production.BillOfMaterials  


SELECT 
	ProductAssemblyID, 
	ComponentID,
	StartDate   
FROM Production.BillOfMaterials  
WHERE EndDate IS NOT NULL   
    AND ComponentID = 5   
    AND StartDate > '01/01/2008' ;  
GO 



--CREATE NONCLUSTERED INDEX IX_DATACADEMY
--ON Production.BillOfMaterials (EndDate,ComponentID,StartDate)


CREATE NONCLUSTERED INDEX FIBillOfMaterialsWithEndDate 
ON Production.BillOfMaterials (ComponentID, StartDate) 
WHERE EndDate IS NOT NULL
GO 


SELECT 
	ProductAssemblyID, 
	ComponentID,
	StartDate   
FROM Production.BillOfMaterials  
WHERE EndDate IS NOT NULL   
    AND ComponentID = 5   
    AND StartDate > '01/01/2008' ;  
GO 
