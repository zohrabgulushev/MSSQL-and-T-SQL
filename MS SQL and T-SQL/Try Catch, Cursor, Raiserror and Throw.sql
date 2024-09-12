
--Üçbucaq Məsələsi:

DECLARE
	@x decimal(18,2) = 5.5,
	@y decimal(18,2) = 1.5,
	@z decimal(18,2) = 3.5
IF (@x+@y<=@z) OR (@x+@z<=@y) OR (@y+@z<=@x)
BEGIN
	PRINT N'Verilmiş tərəflərə uyğun üçbucaq yoxdur!'
END
ELSE
BEGIN
	PRINT N'Üçbucağın perimetri P='+CAST((@x+@y+@z) AS varchar(18))
END

------------------------------------------

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
			PRINT CONVERT(varchar(5),@KenarSaygac) + ' * ' + CONVERT(varchar(5),@DaxiliSaygac) + ' = ' + CONVERT(varchar(5),(@KenarSaygac * @DaxiliSaygac));
		SET @DaxiliSaygac += 1;  
		END;
SET @KenarSaygac += 1;
END;

--------------------------------------------------


CREATE TABLE #Telebe
(
	telebe_id INT IDENTITY,
	ad NVARCHAR(20),
	soyad NVARCHAR(20),
	giris_bal TINYINT,
	final_bal TINYINT,
	[status] NVARCHAR(15)
);

INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Sahil' , N'Pirverdiyev' , 65, 50)
INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Nihat' , N'Aliyev' , 48, 62)
INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Sevda' , N'Aliyeva' , 75, 85)
INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Namir' , N'Muradov' , 35, 40)
INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Fatime' , N'Quliyeva' , 79, 60)
INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Aynur' , N'Samedova' , 62, 59)
INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Fuad' , N'Qasimov' , 35, 55)
INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Nicat' , N'Bayramov' , 70, 35)
INSERT #Telebe (ad,soyad,giris_bal,final_bal) VALUES (N'Aygun' , N'Bagirov' , 74, 40)

SELECT * FROM #Telebe

CREATE TABLE #KesreQalanlar
(
	ad NVARCHAR(20),
	soyad NVARCHAR(20),
	OrtaBal  NVARCHAR(20)
)

SELECT * FROM #KesreQalanlar
-----------------------------------------------


DECLARE @Tid INT, @girisBal INT, @finalBal INT

DECLARE Imtahan CURSOR 
FOR SELECT telebe_id,giris_bal,final_bal FROM #telebe order by telebe_id asc

OPEN Imtahan 

FETCH NEXT FROM Imtahan INTO @Tid,@girisBal,@finalBal

WHILE @@FETCH_STATUS = 0

BEGIN
	DECLARE @OrtaBal FLOAT
	SET @OrtaBal = ((@girisBal * 30) / 100 + (@finalBal * 70) / 100)
	IF(@OrtaBal  >= 50)
	BEGIN
		UPDATE #telebe  SET [status] = 'Keçdi'  WHERE telebe_id = @Tid
	END  
	ELSE
	BEGIN
		UPDATE #telebe  SET [status] = N'Kəsildi'  WHERE telebe_id = @Tid;
		INSERT INTO #KesreQalanlar( ad, soyad, OrtaBal ) 
		SELECT ad, soyad, @OrtaBal AS OrtaBal FROM #telebe WHERE telebe_id = @Tid
	END                   
FETCH NEXT FROM Imtahan INTO @Tid,@girisBal,@finalBal
END  

CLOSE Imtahan

DEALLOCATE Imtahan



---------------------------

SELECT * FROM #Telebe
SELECT * FROM #KesreQalanlar


PRINT 5/2 

PRINT 5/0



BEGIN TRY
	PRINT 5/1
END TRY
BEGIN CATCH
	PRINT N'Sıfıra bölmək olmaz'
END CATCH


BEGIN TRY
	PRINT 5/0
END TRY
BEGIN CATCH
	PRINT N'Sıfıra bölmək olmaz'
END CATCH

-----------------------------------

BEGIN TRY
	PRINT 5/0;
END TRY
BEGIN CATCH
	PRINT 'Catch bloqunun daxili';
	PRINT ERROR_NUMBER();
	PRINT ERROR_MESSAGE();
END CATCH
PRINT 'Catch bloqunun xarici'
PRINT ERROR_NUMBER()
GO

-----------------------------------


BEGIN TRY
	PRINT 5/0;
END TRY
BEGIN CATCH
	PRINT 'Catch bloqunun daxili' 
	PRINT ERROR_NUMBER() 
	PRINT ERROR_MESSAGE() 
	PRINT ERROR_LINE()
	PRINT ERROR_PROCEDURE()
	PRINT ERROR_STATE() 
	PRINT ERROR_SEVERITY() 
END CATCH

-----------------------------------


EXEC ('select 1 as sutunadi')

EXEC ('select * from [AdventureWorks2014].[Person].[Address]')

EXEC ('select * from [AdventureWorks2014]')

EXEC ('select * from ')

-------------------------------

DECLARE @SQL nvarchar(max)
    SET @SQL = 'select * from [AdventureWorks2014].[Person].[Address]'
    EXEC sp_executesql @SQL


DECLARE @SQL nvarchar(max)
    SET @SQL = 'select * '
    EXEC sp_executesql @SQL




-----------------------------------


BEGIN TRY
    DECLARE @SQL nvarchar(max)
    SET @SQL ='select *'
    EXEC sp_executesql @SQL
END TRY
BEGIN CATCH 
    PRINT error_message()
END CATCH


-----------------------------------
BEGIN TRY
    DECLARE @SQL nvarchar(max)
    SET @SQL ='select *'
    EXEC sp_executesql @SQL
END TRY
BEGIN CATCH 
    SELECT ERROR_MESSAGE() as XetaMesaji,ERROR_NUMBER() as XetaNomresi, ERROR_SEVERITY() 
END CATCH


---------------------------------------------


-- Verify that the stored procedure does not exist.  
DROP PROCEDURE IF EXISTS usp_ExampleProc;  
GO  

-- Create a stored procedure that will cause an   
-- object resolution error.  
CREATE PROCEDURE usp_ExampleProc  
AS  
    SELECT * FROM NonexistentTable;  
GO  


EXECUTE usp_ExampleProc  

EXEC usp_ExampleProc  





BEGIN TRY  
    EXECUTE usp_ExampleProc;  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH;  


------------------------------------------
USE AdventureWorks2014
GO

BEGIN TRANSACTION   
	BEGIN TRY   
		DELETE FROM Production.Product WHERE ProductID = 980;  
	END TRY  
	BEGIN CATCH  
		SELECT   
			ERROR_NUMBER() AS ErrorNumber  ,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState   ,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  ,ERROR_MESSAGE() AS ErrorMessage;  
		-- Əgər tranzaksiya hələdə açıqdırsa rollback olsun
		IF  @@TRANCOUNT > 0  
			ROLLBACK TRANSACTION;  
	END CATCH;  
	-- Əgər tranzaksiya hələdə açıqdırsa commit olsun 
	IF @@TRANCOUNT > 0  
		COMMIT TRANSACTION;  
	GO  

------------------------------------------

-- Check to see whether this stored procedure exists.  
DROP PROCEDURE IF EXISTS usp_GetErrorInfo

-- Create procedure to retrieve error information.  
CREATE PROCEDURE usp_GetErrorInfo  
AS  
    SELECT   
         ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO  


EXEC usp_GetErrorInfo


-------------------------------------------

-- SET XACT_ABORT ON will cause the transaction to be uncommittable  
-- when the constraint violation occurs.   
SET XACT_ABORT ON;  
BEGIN TRY  
    BEGIN TRANSACTION;  
        -- A FOREIGN KEY constraint exists on this table. This   
        -- statement will generate a constraint violation error.  
        DELETE FROM Production.Product  
            WHERE ProductID = 980;  
    -- If the DELETE statement succeeds, commit the transaction.  
    COMMIT TRANSACTION;  
END TRY  
BEGIN CATCH  
    -- Execute error retrieval routine.  
    EXECUTE usp_GetErrorInfo;  
    -- Test XACT_STATE:  
        -- If 1, the transaction is committable.  
        -- If -1, the transaction is uncommittable and should  be rolled back.  
        -- XACT_STATE = 0 means that there is no transaction and  a commit or rollback operation would generate an error.  
    -- Test whether the transaction is uncommittable.  
    IF (XACT_STATE()) = -1  
    BEGIN  
        PRINT  N'The transaction is in an uncommittable state. Rolling back transaction.'  
        ROLLBACK TRANSACTION;  
    END;  
    -- Test whether the transaction is committable.  
    IF (XACT_STATE()) = 1  
    BEGIN  
        PRINT  N'The transaction is committable. Committing transaction.'  
        COMMIT TRANSACTION;     
    END;  
END CATCH;  
GO 

-------------------------------------------

BEGIN TRY
	SELECT 5/0
END TRY
BEGIN CATCH
	RAISERROR(N'Sıfıra bölmək olmaz',16, 1)
END CATCH

-------------------------------------------

SELECT * FROM sys.messages


SELECT * FROM sys.syslanguages where msglangid=1055


SELECT * FROM sys.messages where language_id=1055

-------------------------------------------

SET LANGUAGE Turkish


BEGIN TRY
	PRINT 5/0
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH





-------------------------------------------

SET LANGUAGE English


EXEC sp_dropmessage 50002;

EXEC sp_dropmessage 21;



IF EXISTS(SELECT * FROM sys.messages WHERE message_id = 50002) 
BEGIN
	EXEC sp_dropmessage 50002;
END;


PRINT N'Özümüzə xas olan xüsusi xəta mesajımız'


EXEC sp_addmessage 50002, 16, N'Belə bir müştəri yoxdur'; 


SELECT * FROM sys.messages WHERE message_id = 50002


------------------------------------------


DECLARE @MusteriID int = -1
IF NOT EXISTS(SELECT * FROM Sales.Customer WHERE CustomerID = @MusteriID )  --true
BEGIN 
	RAISERROR(50002,16,1);
END


------------------------------------------

BEGIN TRY 
	PRINT 5/0;
END TRY 
BEGIN CATCH
	RAISERROR(N'Heç bir ədəd sıfıra bölünə bilməz, buna görə xəta baş verdi',16,1);
END CATCH;


------------------------------------------
