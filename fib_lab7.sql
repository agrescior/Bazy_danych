--Napisz procedur� wypisuj�c� do konsoli ci�g Fibonacciego. Procedura musi przyjmowa� jako
--argument wej�ciowy liczb� n. Generowanie ci�gu Fibonacciego musi zosta�
--zaimplementowane jako osobna funkcja, wywo�ywana przez procedur�.

USE AdventureWorksLT2019;

CREATE OR ALTER FUNCTION dbo.fibo(@end INT)
	RETURNS VARCHAR(255)
	AS
	BEGIN
		DECLARE @a INT,@b INT, @fib INT,@counter INT
		DECLARE @str VARCHAR(255)
		SET @end = @end - 2
		SET @a = 0
		SET @B = 1
		SET @fib = 0
		SET @counter = 0
		SELECT @str = CAST(@a AS VARCHAR(10)) + ',' + ' '
		SELECT @str = @str + CAST(@b AS VARCHAR(10))
		WHILE @counter < @end
		BEGIN
			SELECT @str = @str + ',' + ' '
			SET @fib = @a + @B
			SET @a = @B
			SET @B = @fib
			SELECT @str = @str + ' ' +CAST(@fib AS VARCHAR(20))
			SET @counter = @counter + 1
		END
		RETURN @str
	END;

CREATE OR ALTER PROCEDURE dbo.fibonacci 
	@n INT
	AS
	BEGIN
		SELECT dbo.fibo(@n) AS 'ciag fibonacciego';
	END;

EXEC dbo.fibonacci 20;
