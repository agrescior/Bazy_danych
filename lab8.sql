--LAB8

USE AdventureWorks2019;

-- 1. Przygotuj blok anonimowy, kt�ry:
-- - znajdzie �redni� stawk� wynagrodzenia pracownik�w,
-- - wy�wietli szczeg�y pracownik�w, kt�rych stawka wynagrodzenia jest ni�sza ni� �rednia.

BEGIN

SELECT AVG([Rate]) AS '�rednia'
  FROM [AdventureWorks2019].[HumanResources].[EmployeePayHistory]

SELECT [HumanResources].[EmployeePayHistory].[BusinessEntityID],[PersonType]
      ,[NameStyle],[Title]
      ,[FirstName],[MiddleName]
      ,[LastName],[Suffix]
      ,[EmailPromotion],[Rate]
	FROM [AdventureWorks2019].[Person].[Person] LEFT OUTER JOIN [AdventureWorks2019].[HumanResources].[EmployeePayHistory]
	ON [Person].[Person].BusinessEntityID = [HumanResources].[EmployeePayHistory].BusinessEntityID
	WHERE Rate < (SELECT AVG([Rate]) FROM [AdventureWorks2019].[HumanResources].[EmployeePayHistory]);
END;


-- 2. Utw�rz funkcj�, kt�ra zwr�ci dat� wysy�ki okre�lonego zam�wienia.

CREATE OR ALTER FUNCTION OrderDate(@OrderID INT)
	RETURNS VARCHAR(30)
	AS
	BEGIN
	DECLARE @result VARCHAR(30)

	IF EXISTS (SELECT [SalesOrderID] FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] WHERE [SalesOrderID] = @OrderID)
		BEGIN
			SET @result = 
		(SELECT CONVERT(VARCHAR(30),[OrderDate],13)
		FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]
		WHERE  SalesOrderID = @OrderID)
		END
	ELSE
		BEGIN
			SET @result = 'NIEPOPRAWNE ID'
		END
	RETURN @result
END;

	SELECT dbo.OrderDate(43659) AS 'Data zam�wienia'
	SELECT dbo.OrderDate(436591) AS 'Data zam�wienia'

-- 3. Utw�rz procedur� sk�adowan�, kt�ra jako parametr przyjmuj� nazw� produktu, a jako
--rezultat wy�wietla jego identyfikator, numer i dost�pno��.

CREATE OR ALTER PROCEDURE FindProduct(@name AS NVARCHAR(50))
	AS
	BEGIN
	IF EXISTS (SELECT [Name] FROM [AdventureWorks2019].[Production].[Product] WHERE [Name] = @name)
		BEGIN
			SELECT [ProductID],[Name],[ProductNumber],[FinishedGoodsFlag] 
			FROM [AdventureWorks2019].[Production].[Product]
			WHERE [Name] = @name;
		END
	ELSE
		BEGIN
			PRINT 'Niepoprawna nazwa produktu'
		END
END;

	EXEC FindProduct 'Blade';
	EXEC FindProduct 'Bladezzzz';

-- 4. Utw�rz funkcj�, kt�ra zwraca numer karty kredytowej dla konkretnego zam�wienia

CREATE OR ALTER FUNCTION CreditCardNum(@OrderID INT)
	RETURNS NVARCHAR(25)
	AS
	BEGIN
	DECLARE @result NVARCHAR(25)

	IF EXISTS (SELECT [SalesOrderID] FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] WHERE [SalesOrderID] = @OrderID)
		BEGIN
			SET @result = 
		(SELECT [CardNumber]
		FROM [AdventureWorks2019].[Sales].[CreditCard] LEFT OUTER JOIN [AdventureWorks2019].[Sales].[SalesOrderHeader]
		ON [Sales].[CreditCard].[CreditCardID] = [Sales].[SalesOrderHeader].[CreditCardID]
		WHERE  SalesOrderID = @OrderID)
		END
	ELSE
		BEGIN
			SET @result = 'NIEPOPRAWNE ID'
		END
	RETURN @result
END;

	SELECT dbo.CreditCardNum(43681) AS 'Numer karty kredytowej'
	SELECT dbo.CreditCardNum(436811) AS 'Numer karty kredytowej'


-- 5. Utw�rz procedur� sk�adowan�, kt�ra jako parametry wej�ciowe przyjmuje dwie liczby, num1
-- i num2, a zwraca wynik ich dzielenia. Ponadto warto�� num1 powinna zawsze by� wi�ksza ni�
-- warto�� num2. Je�eli warto�� num1 jest mniejsza ni� num2, wygeneruj komunikat o b��dzie
-- �Niew�a�ciwie zdefiniowa�e� dane wej�ciowe�.CREATE OR ALTER PROCEDURE Dzielenie(	@num1 AS FLOAT,	@num2 AS FLOAT	)	AS 	BEGIN	DECLARE @result FLOAT	IF(@num1 < @num2 OR @num2 = 0)		BEGIN		PRINT 'Niew�a�ciwie zdefiniowa�e� dane wej�ciowe';		END	ELSE 		BEGIN		SET @result = @num1/@num2;		PRINT @result		ENDEND;	EXEC Dzielenie 12,3;	EXEC Dzielenie 17,4;	EXEC Dzielenie 1,9;