SELECT * FROM sys.dm_tran_active_transactions;

SELECT @@TRANCOUNT  

SELECT  XACT_STATE()  

--------------------------- AUTOCOMMIT -------------------------

SELECT * FROM Store.dbo.Customers

SELECT * FROM Store.dbo.Customers WHERE Customer_id is null

DELETE FROM Store.dbo.Customers WHERE Customer_id is null

--Bu komandalar autocommit tranzaksiya rejiminde ishlemir
--COMMIT;
--ROLLBACK;

SELECT * FROM Store.dbo.Customers WHERE Customer_id is null


SELECT @@TRANCOUNT  

SELECT  XACT_STATE()  

SELECT * FROM sys.dm_tran_active_transactions;


----------------------------  Implicit Transaction  --------------------------


SET IMPLICIT_TRANSACTIONS ON;

	SELECT @@TRANCOUNT  
	SELECT  XACT_STATE()  

	--cedvel uzerinde ilk proses (select,update,insert,delete)
	SELECT * FROM Store.dbo.Customers

	SELECT @@TRANCOUNT 
	SELECT XACT_STATE()

	DELETE FROM Store.dbo.Customers WHERE Customer_id = 20
		
	SELECT @@TRANCOUNT 
	SELECT XACT_STATE()

	--bu sorgu ile 20 nomreli setirin silindiyine shahid olduq amma hele commit ile tesdiq etmemishik
	SELECT * FROM Store.dbo.Customers

	--burada delete komandasi rollback ile geri qaytarildi. yani tesdiqlenmedi
	--ROLLBACK;
	COMMIT

	SELECT @@TRANCOUNT 
	SELECT XACT_STATE()

	--select edib yeniden hemin 20 nomreli setiri goruruk
	SELECT * FROM Store.dbo.Customers

	SELECT @@TRANCOUNT 
	SELECT XACT_STATE()

	ROLLBACK;

	SELECT @@TRANCOUNT 
	SELECT XACT_STATE()

SET IMPLICIT_TRANSACTIONS OFF;


	SELECT * FROM Store.dbo.Customers

	SELECT @@TRANCOUNT 
	SELECT XACT_STATE()




-------------------

SET IMPLICIT_TRANSACTIONS ON;
  
	SELECT * FROM Store.dbo.Customers
	SELECT @@TRANCOUNT  
	SELECT  XACT_STATE()

	--KILL komandasi user tranzaksiya daxilinde ozu ozunu kill ede bilmez.
	--Bunu bashqa bir sessiion-dan etmek lazimdir
	KILL 60;

	SELECT @@TRANCOUNT  
	SELECT  XACT_STATE()

SELECT * FROM sys.dm_tran_active_transactions;


-----------------------------


------------------------- Explicit Transaction  ------------------------------


--------------------------------------------------

SELECT * FROM sys.dm_tran_active_transactions;

-- Bu cur ic-ice yazilan Explicit tranzaksiyalara Nested (komalashmish) Transaction deyilir 
BEGIN TRAN	
	SELECT @@TRANCOUNT  
	SELECT  XACT_STATE()

		BEGIN TRAN		 
			SELECT @@TRANCOUNT  
			SELECT  XACT_STATE()

						BEGIN TRAN		 
							SELECT @@TRANCOUNT  
							SELECT  XACT_STATE()

SELECT * FROM sys.dm_tran_active_transactions;

ROLLBACK
	SELECT @@TRANCOUNT  
	SELECT  XACT_STATE()

SELECT * FROM sys.dm_tran_active_transactions;
--------------------------------------------------

--  BEGIN TRAN  =  BEGIN TRANSACTION 
--  COMMIT = COMMIT TRANSACTION = COMMIT TRAN  =  COMMIT WORK
--  ROLLBACK = ROLLBACK TRANSACTION = ROLLBACK TRAN  =  ROLLBACK WORK

-------------------------


BEGIN TRAN
	UPDATE [AdventureWorks2014].[Person].[Address] 
	SET AddressLine2='This is test string-1'
	WHERE AddressID=1
	SELECT @@TRANCOUNT

	BEGIN TRAN
		UPDATE [AdventureWorks2014].[Person].[Address] 
		SET AddressLine2='This is test string-2'
		WHERE AddressID=1
		SELECT @@TRANCOUNT

		BEGIN TRAN
			UPDATE [AdventureWorks2014].[Person].[Address] 
			SET AddressLine2='This is test string-3'
			WHERE AddressID=1
			SELECT @@TRANCOUNT

ROLLBACK;


---------------------------------


BEGIN TRAN --1
	UPDATE [AdventureWorks2014].[Person].[Address] 
	SET AddressLine2='This is test string-1'
	WHERE AddressID=1
	SELECT @@TRANCOUNT

	BEGIN TRAN --2
		UPDATE [AdventureWorks2014].[Person].[Address] 
		SET AddressLine2='This is test string-2'
		WHERE AddressID=1
		SELECT @@TRANCOUNT

		BEGIN TRAN -- 3
			UPDATE [AdventureWorks2014].[Person].[Address] 
			SET AddressLine2='This is test string-3'
			WHERE AddressID=1
			SELECT @@TRANCOUNT

		COMMIT; --3
	COMMIT; --2
COMMIT; --1

SELECT @@TRANCOUNT

----------------------------------------------------------

UPDATE [AdventureWorks2014].[Person].[Address] 
			SET AddressLine2=NULL
			WHERE AddressID=1

SELECT * FROM [AdventureWorks2014].[Person].[Address] WHERE AddressID=1


----------------------------------------------------------

---------------------------------


BEGIN TRAN --1
	UPDATE [AdventureWorks2014].[Person].[Address] 
	SET AddressLine2='This is test string-1'
	WHERE AddressID=1
	SELECT @@TRANCOUNT

	BEGIN TRAN --2
		UPDATE [AdventureWorks2014].[Person].[Address] 
		SET AddressLine2='This is test string-2'
		WHERE AddressID=1
		SELECT @@TRANCOUNT

		BEGIN TRAN -- 3
			UPDATE [AdventureWorks2014].[Person].[Address] 
			SET AddressLine2='This is test string-3'
			WHERE AddressID=1
			SELECT @@TRANCOUNT

		COMMIT; --3
		 SELECT @@TRANCOUNT
	ROLLBACK; --2 --1

SELECT @@TRANCOUNT

------------------------------------------------------


