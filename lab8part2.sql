--LAB8 PART 2

USE AdventureWorks2019;

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
		PRINT 'Niewłaściwie zdefiniowałeś dane wejściowe'
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
			WHERE [NationalIDNumber] = @ID
		END
	ELSE
		BEGIN
			PRINT 'Niepoprawne NationalIDNumber!'
		END
END

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
	END

	EXEC KalkulatorWalutowy 100, 'USD', 'EUR', '2011-05-31 00:00:00.000'
	EXEC KalkulatorWalutowy 100, 'GBP', 'USD', '2011-06-06 00:00:00.000' 
	EXEC KalkulatorWalutowy 100, 'USD', 'FRF', '2011-05-30 00:00:00.000' 