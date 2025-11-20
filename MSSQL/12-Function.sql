--Function
--Scalar Valued Func: değer döner
CREATE FUNCTION CalculateAge(@BirthDate DATE)
RETURNS INT
AS
BEGIN 
	DECLARE @Age INT
	SET @Age = DATEDIFF(YEAR, @BirthDate, GETDATE())
	RETURN @Age
END

SELECT FirstName, [dbo].[CalculateAge](BirthDate) FROM Employees

CREATE FUNCTION KdvHesapla(@Fiyat MONEY, @CategoryID INT)
RETURNS MONEY
AS
BEGIN 
	IF (@CategoryID = 5)
	BEGIN 
		RETURN @Fiyat * 1.10
	END
	
	RETURN @Fiyat * 1.20
END

SELECT ProductName, UnitPrice, [dbo].[KdvHesapla](UnitPrice, CategoryID)  FROM Products

--Table Valued Func: tablo döner
CREATE FUNCTION GetCustomersByCity(@City NVARCHAR(50))
RETURNS TABLE
AS
RETURN (SELECT CustomerID, CompanyName, City FROM Customers WHERE City = @City)

SELECT * FROM [dbo].[GetCustomersByCity]('Berlin')
