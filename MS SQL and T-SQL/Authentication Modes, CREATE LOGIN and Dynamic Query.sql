CREATE LOGIN [egnb058\Zohrab] 
FROM WINDOWS 
--User windows userlarından seçilir
WITH DEFAULT_DATABASE=[master] 
--Default Database olaraq master database-i set etmişik

---------------------------------------------------------------

DROP LOGIN [Zohrab]

--------------------------


CREATE LOGIN [Zohrab]  WITH PASSWORD = N'A1234',
--Login-in şifrəsini yazırıq
DEFAULT_DATABASE=[master], 
--Burada default Database olaraq master database-i set etmişik
CHECK_EXPIRATION=OFF, 
--şifrənin vaxtının bitməməsini istəmişik  
CHECK_POLICY=OFF
--şifrə üçün SQL Serverin mövcud qaydalarının yoxlanılmasını deaktiv etmişikşpolicy kontrolü yapılmasın



----------------------------

EXEC sp_addsrvrolemember 'Zohrab', 'sysadmin'

EXEC sp_dropsrvrolemember  'Zohrab', 'sysadmin'

EXEC sp_addsrvrolemember 'Zohrab', 'setupadmin'

EXEC sp_dropsrvrolemember  'Zohrab', 'sysadmin'

---------------------------------


USE [TSQLV4]
GO
CREATE USER [Zohrab]  FOR LOGIN [Zohrab]


EXEC sp_addrolemember N'db_owner', N'Zohrab'



EXEC sp_droprolemember N'db_owner', N'Zohrab'


EXEC sp_addrolemember N'db_datareader', N'Zohrab'


--- Ashidaki iki komanda (select ve drop)  Zohrab logini vasitesile icra edilmelidir

--SELECT * FROM [Sales].[OrderDetails]
--DROP TABLE [Sales].[OrderDetails]

-----------------------


USE AdventureWorks2014
GO
--GRANT SELECT,INSERT,UPDATE,DELETE ON [Sales].[SalesPerson] TO [user_name]


GRANT SELECT,UPDATE ON [Sales].[SalesPerson] TO [Zohrab]

--Ashagidaki 3 komandani bashqa bir sessiondan Zohrab logini vasitesi ile girish edib selecet edin

--Success
SELECT * FROM [Sales].[SalesPerson]

--Success
UPDATE [Sales].[SalesPerson] SET Bonus=100  where BusinessEntityID=275

--Fail. Cunki Zohrab userinin Delete etmek ucun permission yoxdur 
DELETE FROM [Sales].[SalesPerson] WHERE BusinessEntityID=275

-------------------------------

USE AdventureWorks2014
GO
GRANT SELECT TO [Zohrab]


--------------------------------------------
USE AdventureWorks2014
GO
--tek cedvelden revoke ile icazeni legv etmek
REVOKE SELECT ON [Sales].[SalesPerson] FROM [Zohrab]



USE AdventureWorks2014
GO
-- butun database uzerinde olan select icazesini revoke komandasi ile legv etmek
REVOKE SELECT  FROM [Zohrab]


--------------------------------------------

USE AdventureWorks2014
GO
SELECT * FROM sys.database_permissions 

SELECT * FROM sys.sysusers

SELECT 
	t.name,
	p.permission_name,
	p.state_desc,
	grantee.name AS grantee_user, 
	grantor.name AS grantor_user
from  sys.tables t 
INNER JOIN sys.database_permissions p ON t.object_id=p.major_id
INNER JOIN sys.sysusers grantee ON grantee.uid=p.grantee_principal_id
INNER JOIN sys.sysusers grantor ON grantor.uid=p.grantor_principal_id
WHERE t.name = 'SalesPerson';




USE AdventureWorks2014
GO

GRANT DELETE ON [Sales].[SalesPerson] TO [Zohrab]

SELECT 
	t.name,
	p.permission_name,
	p.state_desc,
	grantee.name AS grantee_user, 
	grantor.name AS grantor_user
from  sys.tables t 
INNER JOIN sys.database_permissions p ON t.object_id=p.major_id
INNER JOIN sys.sysusers grantee ON grantee.uid=p.grantee_principal_id
INNER JOIN sys.sysusers grantor ON grantor.uid=p.grantor_principal_id
WHERE t.name = 'SalesPerson';

---------------------

REVOKE DELETE ON [Sales].[SalesPerson] FROM [Zohrab]


SELECT 
	t.name,
	p.permission_name,
	p.state_desc,
	grantee.name AS grantee_user, 
	grantor.name AS grantor_user
from  sys.tables t 
INNER JOIN sys.database_permissions p ON t.object_id=p.major_id
INNER JOIN sys.sysusers grantee ON grantee.uid=p.grantee_principal_id
INNER JOIN sys.sysusers grantor ON grantor.uid=p.grantor_principal_id
WHERE t.name = 'SalesPerson';


-----------------------------

DENY SELECT ON [Sales].[SalesPerson] TO [Zohrab]


SELECT 
	t.name,
	p.permission_name,
	p.state_desc,
	grantee.name AS grantee_user, 
	grantor.name AS grantor_user
from  sys.tables t 
INNER JOIN sys.database_permissions p ON t.object_id=p.major_id
INNER JOIN sys.sysusers grantee ON grantee.uid=p.grantee_principal_id
INNER JOIN sys.sysusers grantor ON grantor.uid=p.grantor_principal_id
WHERE t.name = 'SalesPerson';

---------------------


GRANT SELECT ON [Sales].[SalesPerson] TO [Zohrab]



SELECT 
	t.name,
	p.permission_name,
	p.state_desc,
	grantee.name AS grantee_user, 
	grantor.name AS grantor_user
from  sys.tables t 
INNER JOIN sys.database_permissions p ON t.object_id=p.major_id
INNER JOIN sys.sysusers grantee ON grantee.uid=p.grantee_principal_id
INNER JOIN sys.sysusers grantor ON grantor.uid=p.grantor_principal_id
WHERE t.name = 'SalesPerson';

-------------------------


USE AdventureWorks2014
GO  

CREATE ROLE ITK AUTHORIZATION [Zohrab];  


DROP ROLE ITK


CREATE ROLE ITK AUTHORIZATION [dbo];  


GRANT SELECT TO ITK

GRANT UPDATE, CREATE VIEW TO ITK


EXEC sp_addrolemember 'ITK', 'Zohrab'


REVOKE UPDATE FROM ITK

-------------------------------------

SELECT * FROM AdventureWorks2014.HumanResources.EmployeePayHistory


EXEC('SELECT * FROM AdventureWorks2014.HumanResources.EmployeePayHistory')

--------------------------------------------

DECLARE 
	@db_name varchar(30) = 'AdventureWorks2014',
	@sch_name varchar(30) = 'HumanResources',
	@tbl_name varchar(30) = 'EmployeePayHistory'

PRINT('SELECT * FROM ['+@db_name+'].['+@sch_name+'].['+@tbl_name+']')
EXEC('SELECT * FROM ['+@db_name+'].['+@sch_name+'].['+@tbl_name+']')

--------------------------------------------


CREATE OR ALTER PROCEDURE dbo.sp_select_to_any_table
(
	@db_name varchar(30),
	@sch_name varchar(30),
	@tbl_name varchar(30)
)
AS
BEGIN
	EXEC('SELECT * FROM ['+@db_name+'].['+@sch_name+'].['+@tbl_name+']')
END	

--------------------------------

--Success
EXECUTE dbo.sp_select_to_any_table 'TSQLV4','HR','Employees'

--Success
EXECUTE dbo.sp_select_to_any_table 'TSQLV4','Sales','Orders'

--Fail
EXECUTE dbo.sp_select_to_any_table 'TSQLV4','Sales','YalanciCedvel'

--Xeta verse : mesaj cixsin ki, Bele bir database yaxud bele bir schema ve ya cedvel yoxdur


SELECT * FROM sys.databases
SELECT * FROM sys.schemas
SELECT * FROM sys.tables

-------------------------------

USE AdventureWorks2014
GO
CREATE PROCEDURE dbo.Dynamic_Table_Select
(
	@db_name varchar(30),
	@sch_name varchar(30),
	@tbl_name varchar(30),
	@col_name varchar(30),
	@find_value varchar(30)
)
AS 
BEGIN
	EXEC ('SELECT * FROM ['+@db_name+'].['+@sch_name+'].['+@tbl_name+'] WHERE '+@col_name+' > '+@find_value+'');
END


----------------
EXEC Dynamic_Table_Select
	'AdventureWorks2014',
	'HumanResources',
	'EmployeePayHistory',
	'Rate',
	'80'



---------------------------

--------------------------


SELECT BusinessEntityID, NationalIDNumber, JobTitle, LoginID  
       FROM AdventureWorks2014.HumanResources.Employee   
       WHERE BusinessEntityID = 197


-----------------------
DECLARE 
	@SQLString nvarchar(500), 
	@ParmDefinition nvarchar(500),
	@IntVariable int
/* Build the SQL string one time.*/  
SET @SQLString =  
     N'SELECT BusinessEntityID, NationalIDNumber, JobTitle, LoginID  
       FROM AdventureWorks2014.HumanResources.Employee   
       WHERE BusinessEntityID = @BusinessEntityID';
	   
SET @ParmDefinition = N'@BusinessEntityID tinyint';

/* Execute the string with the first parameter value. */  
SET @IntVariable = 197;  


EXECUTE sp_executesql @SQLString, @ParmDefinition, @BusinessEntityID = @IntVariable;  
 
SET @IntVariable = 109; 

EXECUTE sp_executesql @SQLString, @ParmDefinition, @BusinessEntityID = @IntVariable;  
