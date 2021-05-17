--trigger1 - lab7

USE AdventureWorks2019;
--Napisz trigger DML, który po wprowadzeniu danych do tabeli Persons zmodyfikuje nazwisko
--tak, aby by³o napisane du¿ymi literami.

CREATE OR ALTER TRIGGER nazwiska
ON [AdventureWorks2019].[Person].[Person]
AFTER INSERT, UPDATE
AS
BEGIN
	SELECT [BusinessEntityID]
      ,[PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,UPPER([LastName]) AS 'LastName'
      ,[Suffix]
      ,[EmailPromotion]
      ,[AdditionalContactInfo]
      ,[Demographics]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks2019].[Person].[Person]
END;

DECLARE @MiddName NVARCHAR(50) = 'X'
UPDATE [AdventureWorks2019].[Person].[Person]
SET [Person].[Person].MiddleName = @MiddName
WHERE [Person].[Person].BusinessEntityID = 1;




