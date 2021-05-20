--LAB8

USE AdventureWorks2019;

-- 1. Przygotuj blok anonimowy, który:
-- - znajdzie œredni¹ stawkê wynagrodzenia pracowników,
-- - wyœwietli szczegó³y pracowników, których stawka wynagrodzenia jest ni¿sza ni¿ œrednia.

BEGIN

SELECT AVG([Rate]) AS 'Œrednia'
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


-- 2. Utwórz funkcjê, która zwróci datê wysy³ki okreœlonego zamówienia.

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

	SELECT dbo.OrderDate(43659) AS 'Data zamówienia'
	SELECT dbo.OrderDate(436591) AS 'Data zamówienia'

-- 3. Utwórz procedurê sk³adowan¹, która jako parametr przyjmujê nazwê produktu, a jako
--rezultat wyœwietla jego identyfikator, numer i dostêpnoœæ.

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

-- 4. Utwórz funkcjê, która zwraca numer karty kredytowej dla konkretnego zamówienia

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



-- 5. Utwórz procedurę składowaną, która jako parametry wejściowe przyjmuje dwie liczby, num1
-- i num2, a zwraca wynik ich dzielenia. Ponadto wartość num1 powinna zawsze być większa niż
-- wartość num2. Jeżeli wartość num1 jest mniejsza niż num2, wygeneruj komunikat o błędzie
-- „Niewłaściwie zdefiniowałeś dane wejściowe”.

CREATE OR ALTER PROCEDURE Dzielenie(
	@num1 AS FLOAT,
	@num2 AS FLOAT
	)
	AS 
	BEGIN
	DECLARE @result FLOAT
	IF(@num1 < @num2 OR @num2 = 0)
		BEGIN
		PRINT 'Niewlasciwie zdefiniowales dane wejsciowe'
		END
	ELSE 
		BEGIN
		SET @result = @num1/@num2
		PRINT @result
		END
END;

	EXEC Dzielenie 12,3
	EXEC Dzielenie 17,4
	EXEC Dzielenie 1,9


-- 6. Napisz procedurę, która jako parametr przyjmie NationalIDNumber danej osoby, a zwróci
-- stanowisko oraz liczbę dni urlopowych i chorobowych.

CREATE OR ALTER PROCEDURE JobTitle(@ID AS NVARCHAR(15))
	AS
	BEGIN
	IF EXISTS (SELECT [NationalIDNumber] FROM [AdventureWorks2019].[HumanResources].[Employee] WHERE [NationalIDNumber] = @ID)
		BEGIN
			SELECT [JobTitle],[VacationHours],[SickLeaveHours]
			FROM [AdventureWorks2019].[HumanResources].[Employee]
			WHERE [NationalIDNumber] = @ID;
		END
	ELSE
		BEGIN
			PRINT 'Niepoprawne NationalIDNumber!'
		END
END;

EXEC JobTitle 295847284;
EXEC JobTitle 2958472841;


-- 7. Napisz procedurę będącą kalkulatorem walutowym. Wykorzystaj dwie tabele: Sales.Currency
--  oraz Sales.CurrencyRate. Parametrami wejściowymi mają być: kwota, waluty oraz data
--  (CurrencyRateDate). Przyjmij, iż zawsze jedną ze stron jest dolar amerykański (USD).
--  Zaimplementuj kalkulację obustronną, tj: 1400 USD → PLN lub PLN → USD

CREATE OR ALTER PROCEDURE KalkulatorWalutowy(
	@kwota MONEY, 
	@walutaIN NCHAR(3),
	@walutaOUT NCHAR(3),
	@data DATETIME
	)
	AS 
	BEGIN
	DECLARE @result MONEY
		IF EXISTS (SELECT [CurrencyCode] FROM [AdventureWorks2019].[Sales].[Currency] WHERE [CurrencyCode] = @walutaIN)
		AND EXISTS ( SELECT [CurrencyCode] FROM [AdventureWorks2019].[Sales].[Currency] WHERE [CurrencyCode] = @walutaOUT)
			BEGIN
				IF(@walutaIN = 'USD')
					BEGIN
						IF EXISTS(SELECT [AverageRate] FROM [AdventureWorks2019].[Sales].[CurrencyRate] 
						WHERE [CurrencyRateDate] = @data AND [ToCurrencyCode] = @walutaOUT)
							BEGIN
								SET @result = @kwota*(SELECT [AverageRate] FROM [AdventureWorks2019].[Sales].[CurrencyRate] 
								WHERE [CurrencyRateDate] = @data AND [ToCurrencyCode] = @walutaOUT)
								PRINT(@walutaIN + ' -> ' + @walutaOUT)
								PRINT(@result)
							END
						ELSE
							BEGIN
								PRINT 'Niepoprawna data'
							END
					END
				ELSE
					BEGIN
						IF EXISTS(SELECT [AverageRate] FROM [AdventureWorks2019].[Sales].[CurrencyRate] 
						WHERE [CurrencyRateDate] = @data AND [ToCurrencyCode] = @walutaOUT)
							BEGIN
								SET @result = @kwota/(SELECT [AverageRate] FROM [AdventureWorks2019].[Sales].[CurrencyRate] 
								WHERE [CurrencyRateDate] = @data AND [ToCurrencyCode] = @walutaIN)
								PRINT(@walutaIN + ' -> ' + @walutaOUT ) 
								PRINT(@result)
							END
						ELSE
							BEGIN
								PRINT 'Niepoprawna data'
							END
					END
			END
		ELSE
			BEGIN
				PRINT 'Niepoprawny kod waluty'
			END
	END;

	EXEC KalkulatorWalutowy 100, 'USD', 'EUR', '2011-05-31 00:00:00.000'
	EXEC KalkulatorWalutowy 100, 'GBP', 'USD', '2011-06-06 00:00:00.000' 
	EXEC KalkulatorWalutowy 100, 'USD', 'FRF', '2011-05-30 00:00:00.000' 

