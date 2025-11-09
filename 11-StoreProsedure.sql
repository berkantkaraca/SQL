--Store Prosedure: Önceden derlenmiş ve saklanmış sql komutları topluluğudur

CREATE PROCEDURE SP_MusterileriGetir AS
BEGIN
   SELECT * FROM Customers
END;

--Data cachelendi. sonuç daha hızlı gelir.
EXEC SP_MusterileriGetir

CREATE PROCEDURE SP_GetCustomerById
   @ID NVARCHAR(5)
AS
BEGIN
   SELECT * FROM Customers WHERE CustomerID = @ID
END;

EXEC SP_GetCustomerById @ID = 'ALFKI'

CREATE PROCEDURE SP_GetOrdersByDate
   @StartDate Date,
   @EndDate Date
AS
BEGIN
   SELECT OrderID, OrderDate 
	FROM Orders 
	WHERE OrderDate BETWEEN @StartDate AND @EndDate
END;

EXEC SP_GetOrdersByDate @StartDate = '1996-08-01' , @EndDate = '1997-02-01'
