

IF 5>4 --true
	PRINT 'SALAM'

--------------------------------

IF 5<4 --false
	PRINT 'SALAM'

--------------------------------

IF 5<4 --false
	PRINT 'SALAM'
ELSE
	PRINT 'Welcome'


--------------------------------

IF 5<4 and 6>5 --false
	PRINT 'SALAM'
ELSE
	PRINT 'Welcome'

--------------------------------
IF 5<4 or 6>5 --true
	PRINT 'SALAM'
ELSE
	PRINT 'Welcome'



--------------------------------

DECLARE 
	@x int = 5,
	@y tinyint = 5

IF @x > @y 
	PRINT CAST(@x AS VARCHAR(5)) + N' dəyəri ' + CAST(@y AS VARCHAR(5)) + N' dəyərindən böyükdür...'
ELSE IF @x < @y  
	PRINT CAST(@x AS VARCHAR(5)) + N' dəyəri ' + CAST(@y AS VARCHAR(5)) + N' dəyərindən kiçikdir...'
--ELSE IF @x = @y  
ELSE
	PRINT CAST(@x AS VARCHAR(5)) + N' dəyəri ' + CAST(@y AS VARCHAR(5)) + N' dəyərinə bərabərdir...'
	
--------------------------------


DECLARE 
	@x int = 5,
	@y tinyint = 5

IF @x > @y 
BEGIN
	PRINT CAST(@x AS VARCHAR(5)) + N' dəyəri ' + CAST(@y AS VARCHAR(5)) + N' dəyərindən böyükdür...'
	--INSERT
	--UPDATE
	--SELECT
	--DELETE
	--ve sair
END
ELSE IF @x < @y  
BEGIN
	PRINT CAST(@x AS VARCHAR(5)) + N' dəyəri ' + CAST(@y AS VARCHAR(5)) + N' dəyərindən kiçikdir...'
	-- .... komandalar yaza bilersiniz
END
--ELSE IF @x = @y  
ELSE
BEGIN
	PRINT CAST(@x AS VARCHAR(5)) + N' dəyəri ' + CAST(@y AS VARCHAR(5)) + N' dəyərinə bərabərdir...'
END	

--------------------------------
SELECT DATENAME(weekday, GETDATE())



IF DATENAME(weekday, GETDATE()) IN (N'Saturday', N'Sunday')
       SELECT 'Weekend';
ELSE 
       SELECT 'Weekday';


--------------------------------

USE AdventureWorks2014;  
GO  


IF (SELECT COUNT(*) FROM Production.Product WHERE Name LIKE 'Touring-3000%') > 5  
	PRINT 'There are more than 5 Touring-3000 bicycles.'  
ELSE 
	PRINT 'There are 5 or less Touring-3000 bicycles.' 
GO 



--------------------------------
  
BEGIN TRANSACTION;  
GO  
IF (SELECT count(*) FROM Person.Person WHERE LastName = 'Adams') > 50  
BEGIN  
    UPDATE Person.Person SET MiddleName = 'TEST' WHERE LastName = 'Adams';  
	PRINT N'Updated table Person';  
END; 


SELECT @@TRANCOUNT

ROLLBACK

SELECT @@TRANCOUNT
--------------------------------


IF 1=1 --true
BEGIN
	PRINT '1 ededi 1 ededine beraberdir'
END

-----------------------------------------------


WHILE 1=1 --true
BEGIN
	PRINT '1 ededi 1 ededine beraberdir'
END


-----------------------------------------------

CREATE DATABASE TESTDB
GO
USE TESTDB
GO

CREATE TABLE test
(
	id bigint,
	name nvarchar(200)
)

insert into test(id,name) values(100,'Azerbaijan')


WHILE 1=1 --true
BEGIN
	update test set id=111,name='Can Azerbaycan !!!'
	PRINT 'updated'
END

USE master
GO

DROP DATABASE TESTDB
GO

--------------------------------------------

DECLARE @H int = 0
WHILE @H <= 20
BEGIN
	PRINT @H
	SET @H = @H + 1
END

--------------------------------------------


DECLARE @H int = 0
WHILE @H <= 20
BEGIN
	PRINT @H
	SET @H += 1
END

-- @a += 5   ,  @a = @a + 5
-- @a *= 5   ,  @a = @a * 5
-- @a -= 5   ,  @a = @a - 5
-- @a \= 5   ,  @a = @a \ 5

-----------------------------------------

USE AdventureWorks2014;  
GO 

WHILE (SELECT AVG(ListPrice) FROM Production.Product) < $650  
BEGIN 
   UPDATE Production.Product  SET ListPrice = ListPrice + 10;  
   SELECT AVG(ListPrice) FROM Production.Product
END 

-------------------------------------------------------


PRINT CHAR(65)
PRINT CHAR(66)
PRINT CHAR(40)

----------------------------------
DECLARE @saygac INT = 65;
WHILE @saygac < 91 
BEGIN
	PRINT CHAR(@saygac);
	SET @saygac += 1;
END;

---------------------------------------


DECLARE  @KenarSaygac INT = 2 
        ,@DaxiliSaygac INT
WHILE @KenarSaygac <= 10 
BEGIN
PRINT '--=====' + CAST(@KenarSaygac AS VARCHAR(2)) + N'=====--'
		SET @DaxiliSaygac = 1;
		WHILE @DaxiliSaygac <= 10 
		BEGIN
			IF @KenarSaygac % 9 = 0 
			BEGIN
				PRINT N'Dövrdən çıkıldı'
				BREAK;
			END;
			PRINT @KenarSaygac * @DaxiliSaygac;
		SET @DaxiliSaygac += 1;  
		END;
SET @KenarSaygac += 1;
END;


--=====2=====--
--2 * 1 = 2
--2 * 2 = 4
--2 * 3 = 6
--2 * 4 = 8
--....


USE AdventureWorks2014;  
GO  


WHILE (SELECT AVG(ListPrice) FROM Production.Product) < $1200  
BEGIN  
   UPDATE Production.Product  SET ListPrice = ListPrice + 10;  
   SELECT AVG(ListPrice) FROM Production.Product;  
   IF (SELECT AVG (ListPrice) FROM Production.Product) > $1100  
      BREAK; 
   ELSE  
      CONTINUE;  
END

-----------------------------------------

DECLARE @Counter int;  
SET @Counter = 1;  
WHILE @Counter < 10  
BEGIN   
    SELECT @Counter  
    SET @Counter = @Counter + 1  
    IF @Counter = 4 
		GOTO Branch_One --Jumps to the first branch.  
    IF @Counter = 5 
		GOTO Branch_Two  --This will never execute.  
END  
Branch_One:  
    SELECT 'Jumping To Branch One.'  
    GOTO Branch_Three; --This will prevent Branch_Two from executing.  
Branch_Two:  
    SELECT 'Jumping To Branch Two.'  
Branch_Three:  
    SELECT 'Jumping To Branch Three.';

-------------------------

