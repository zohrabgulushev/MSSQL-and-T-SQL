USE AdventureWorks2014;  
GO  
--CREATE PROC

CREATE PROCEDURE HumanResources.uspGetEmployeesTest2   
    @LastName nvarchar(50),   
    @FirstName nvarchar(50)   
AS  
BEGIN
    SET NOCOUNT ON;  
    SELECT FirstName, LastName, Department  
    FROM HumanResources.vEmployeeDepartmentHistory  
    WHERE FirstName = @FirstName AND LastName = @LastName  
    AND EndDate IS NULL;  
END
GO 


------------------------------------------------------------------------------------

EXECUTE HumanResources.uspGetEmployeesTest2 N'Ackerman', N'Pilar';  

-- və ya
EXEC HumanResources.uspGetEmployeesTest2 @LastName = N'Ackerman', @FirstName = N'Pilar';  
GO  


-- və ya
EXECUTE HumanResources.uspGetEmployeesTest2 @FirstName = N'Pilar', @LastName = N'Ackerman';  
GO  

------------------------------------------------------------------------------------
USE AdventureWorks2014;  
GO  
ALTER PROCEDURE HumanResources.uspGetEmployeesTest2   
    @LName nvarchar(50),   
    @FName nvarchar(60)   
AS   
    SET NOCOUNT ON;  
    SELECT FirstName, LastName, Department  
    FROM HumanResources.vEmployeeDepartmentHistory  
    WHERE FirstName = @FName AND LastName = @LName; 
GO 


------------------------------------------------------------------------------------

USE AdventureWorks2014;  
GO  
CREATE OR ALTER PROCEDURE HumanResources.uspGetEmployeesTest2   
    @LName nvarchar(50),   
    @FName nvarchar(60)   
AS   
    SET NOCOUNT ON;  
    SELECT FirstName, LastName, Department  
    FROM HumanResources.vEmployeeDepartmentHistory  
    WHERE FirstName = @FName AND LastName = @LName; 
GO 

------------------------------------------------------------------------------------
EXECUTE HumanResources.uspGetEmployeesTest2  'Ackerman','Pilar';

EXECUTE HumanResources.uspGetEmployeesTest2  'Ackerman',@Fname='Pilar';


EXECUTE HumanResources.uspGetEmployeesTest2  @Lname='Ackerman',@Fname='Pilar';

------------------------------------------------------------------------------------


USE AdventureWorks2014;  
GO   
DROP PROCEDURE IF EXISTS Sales.uspGetEmployeeSalesYTD;  
GO  


CREATE PROC Sales.uspGetEmployeeSalesYTD  
	@SalesPerson nvarchar(50),  
	@SalesYTD money OUTPUT  
AS 
BEGIN
    SET NOCOUNT ON;  
    SELECT  @SalesYTD=SalesYTD FROM Sales.SalesPerson AS sp  
    JOIN HumanResources.vEmployee AS e ON e.BusinessEntityID = sp.BusinessEntityID  
    WHERE LastName = @SalesPerson;  
RETURN  
END
GO  

------------------------------------------------------------------------------------
--Fail
EXECUTE Sales.uspGetEmployeeSalesYTD 

--Fail
EXECUTE Sales.uspGetEmployeeSalesYTD  @SalesPerson = 'Blythe'

--Fail
EXECUTE Sales.uspGetEmployeeSalesYTD  @SalesPerson = 'Blythe', @SalesYTD OUTPUT
------------------------------------------------------------------------------------

USE AdventureWorks2014
GO

-- Proseduranın output dəyərini qəbul etmək üçün yeni bir dəyişən elan edirik.
DECLARE @SalesYTDBySalesPerson money;  
-- Proseduranı işlədərkən, input parametri üçün təyin edilmiş Soyadı (last name) daxil edirik 
-- və output dəyərini özündə saxlamaq üçün @SalesYTDBySalesPerson dəyişənini də qeyd edirik.
EXECUTE Sales.uspGetEmployeeSalesYTD @SalesPerson = N'Blythe', @SalesYTD = @SalesYTDBySalesPerson OUTPUT;  
-- Burada isə proseduranın nəticəsindən qayıdan dəyəri görürük (print edirik)  
PRINT 'Year-to-date sales for this employee is ' +  convert(varchar(10),@SalesYTDBySalesPerson);  
GO 


------------------------------------------------------------------------------------

USE AdventureWorks2014;  
GO  
EXEC sp_rename 'Sales.uspGetEmployeeSalesYTD', 'TestRename';  
GO  


------------------------------------------------------------------------------------


USE AdventureWorks2014;  
GO  
DROP PROCEDURE IF EXISTS HumanResources.uspGetEmployeesTest2;
GO   



USE AdventureWorks2014;  
GO  
DROP PROCEDURE IF EXISTS HumanResources.uspGetEmployeesTest222;
GO   

---------------------------------


SELECT * FROM sys.procedures;  


---------------------------------



SELECT
     [name] AS [procedure_name]   
    ,SCHEMA_NAME([schema_id]) AS [schema_name]  
    ,[type_desc]  
    ,[create_date]  
    ,[modify_date]
FROM sys.procedures; 


------------------------------

CREATE OR ALTER PROC dbo.TestTest
  @a decimal(6,3)
AS
BEGIN
	DECLARE @S DECIMAL(10,5)
	SET @S=SQUARE(@a)
	PRINT @S
END



EXEC dbo.TestTest @a=5



------------------------------



CREATE OR ALTER PROC dbo.Test_TryCatch
  @a decimal(6,3),
  @b decimal(6,3)
AS
BEGIN
	DECLARE @x DECIMAL(10,5)
	SET @x=@a/@b
	PRINT @x
END


--OK
EXEC dbo.Test_TryCatch 5,2

--Fail: Divide by zero error encountered
EXEC dbo.Test_TryCatch 5,0

 
CREATE OR ALTER PROC dbo.Test_TryCatch
  @a decimal(6,3),
  @b decimal(6,3)
AS
BEGIN
	DECLARE @x DECIMAL(10,5)
	BEGIN TRY
		SET @x=@a/@b
	END TRY
	BEGIN CATCH 
		PRINT N'Xahiş edirik böləni sıfırdan fərqli ədəd təyin edin'
	END CATCH
	PRINT @x
END


------------------------------------------------------

EXEC dbo.Test_TryCatch 5,0

------------------------------------------------------

CREATE OR ALTER PROC dbo.Test_Tran
  @PersonId int
AS
BEGIN
	DELETE FROM AdventureWorks2014.Person.Person
	WHERE BusinessEntityID = @PersonId
END


------------------------------------------------------


EXEC Test_Tran @PersonId=1


------------------------------------------------------

CREATE OR ALTER PROC dbo.Test_Tran
  @PersonId int
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION 
			DELETE FROM AdventureWorks2014.Person.Person
			WHERE BusinessEntityID = @PersonId
		COMMIT TRANSACTION
		PRINT N'Silinmə əməliyyatı uğurla tamamlandı'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT N'Silinmə əməliyyatında problem baş verdi: Xəta kodu - ' + convert(varchar(10),error_number())
	END CATCH
END


------------------------------------------------------

EXEC Test_Tran @PersonId=1