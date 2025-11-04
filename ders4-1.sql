----Store Prosedure: Önceden deerlenmiş ve saklanmış sql komutları toplulupudur

--CREATE PROCEDURE SP_MusterileriGetir AS
--BEGIN
--    SELECT * FROM Customers
--END;

----Data cachelendi. sonuç daha hızlı gelir.
--EXEC SP_MusterileriGetir


--CREATE PROCEDURE SP_GetCustomerById
--    @ID NVARCHAR(5)
--AS
--BEGIN
--    SELECT * FROM Customers WHERE CustomerID = @ID
--END;

--EXEC SP_GetCustomerById @ID = 'ALFKI'


--CREATE PROCEDURE SP_GetOrdersByDate
--    @StartDate Date,
--    @EndDate Date
--AS
--BEGIN
--    SELECT OrderID, OrderDate 
--	FROM Orders 
--	WHERE OrderDate BETWEEN @StartDate AND @EndDate
--END;

--EXEC SP_GetOrdersByDate @StartDate = '1996-08-01' , @EndDate = '1997-02-01'

----Function


----Scalar Valued Func: değer döner
--CREATE FUNCTION CalculateAge(@BirthDate DATE)
--RETURNS INT
--AS
--BEGIN 
--	DECLARE @Age INT
--	SET @Age = DATEDIFF(YEAR, @BirthDate, GETDATE())
--	RETURN @Age
--END

--SELECT FirstName, [dbo].[CalculateAge](BirthDate) FROM Employees


--CREATE FUNCTION KdvHesapla(@Fiyat MONEY, @CategoryID INT)
--RETURNS MONEY
--AS
--BEGIN 
--	IF (@CategoryID = 5)
--	BEGIN 
--		RETURN @Fiyat * 1.10
--	END
	
--	RETURN @Fiyat * 1.20
--END

--SELECT ProductName, UnitPrice, [dbo].[KdvHesapla](UnitPrice, CategoryID)  FROM Products


----Table Valued Func: tablo döner
--CREATE FUNCTION GetCustomersByCity(@City NVARCHAR(50))
--RETURNS TABLE
--AS
--RETURN (SELECT CustomerID, CompanyName, City FROM Customers WHERE City = @City)


--SELECT * FROM [dbo].[GetCustomersByCity]('Berlin')









