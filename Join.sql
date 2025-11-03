--GROUP BY, verikümesini belirli bir sütuna göre gruplandýrmak için kullanýlýr.

SELECT FirstName, LastName, Country FROM Employees

SELECT Country, COUNT(*) AS KisiSayisi FROM Employees WHERE Country IS NOT NULL GROUP BY Country

--Çalýþanlarýn yapnmýþ olduðu sipariþ adeti
SELECT EmployeeID, COUNT(*) AS SiparisAdeti FROM Orders GROUP BY EmployeeID ORDER BY SiparisAdeti DESC

--Ürün bedeli 35$ dan az olan ürünlerin kategorilerine göre gruplanmasý.
SELECT CategoryID, COUNT(*) FROM Products WHERE UnitPrice <= 35 GROUP BY CategoryID

--Baþ harfi A-K aralýðýnda olan ve stok miktarý 5 ile 50 arasýnda olan ürünleri kategorilerine göre gruplayýnýz.
SELECT CategoryID, COUNT(*) FROM Products WHERE ProductName LIKE '[A-K]%' AND UnitsInStock BETWEEN 5 AND 50
GROUP BY CategoryID ORDER BY 2 DESC

--Her bir sipariþin tutarýna göre listelenmesi.

SELECT OrderID, SUM(UnitPrice * Quantity * (1-Discount)) AS Tutar FROM [Order Details] GROUP BY OrderID
ORDER BY 2 DESC

--HAVING, Gruplama üzerinde bir filtreleme yapmak istediðimiz zaman kullanýlýr.
SELECT OrderID, SUM(UnitPrice * Quantity * (1-Discount)) AS Tutar FROM [Order Details] GROUP BY OrderID
HAVING SUM(UnitPrice * Quantity * (1-Discount)) BETWEEN 2500 AND 3500

--10dan fazla sipariþ verilen müþterileri bulun.
SELECT CustomerID, COUNT(OrderID) FROM Orders GROUP BY CustomerID HAVING COUNT(OrderID) > 10 ORDER BY 2 DESC

--Subquery

--Deðiþken Tanýmlama
DECLARE @Ad NVARCHAR(50)
SET @Ad = 'BilgeAdam'
SELECT @Ad

DECLARE @AdSoyhad NVARCHAR(50), @Yas INT
SELECT @AdSoyhad='Fatih', @Yas = 38
SELECT @AdSoyhad Adi, @Yas Yasi

DECLARE @UrunAdi NVARCHAR(50)
SET @UrunAdi = (SELECT ProductName FROM Products WHERE ProductID=10)

DECLARE @UrunAdi1 NVARCHAR(50)
SELECT @UrunAdi1 = ProductName FROM Products
SELECT @UrunAdi1

SELECT * FROM Products WHERE ProductName = @UrunAdi1

DECLARE @OrtFiyat MONEY = (SELECT AVG(UnitPrice) FROM Products)
SELECT * FROM Products WHERE UnitPrice > @OrtFiyat

SELECT * FROM Products WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)

--Ürünler tablosudnaki satýlan ürünlerin listesi.
SELECT DISTINCT ProductID FROM [Order Details]

SELECT * FROM Products WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM [Order Details])

SELECT ProductName, UnitPrice, UnitsInStock, (SELECT CategoryName FROM Categories WHERE CategoryID = P.CategoryID)
FROM Products P

-- Kargo Þirketlerinin Taþýdýklarý sipariþ sayýlarý.

SELECT (SELECT CompanyName FROM Shippers WHERE ShipperID= ShipVia), COUNT(*) FROM Orders GROUP BY ShipVia

-- JOIN: iki veya daha fazla tabloyu birleþtirmek için kullanýlýr.

SELECT P.ProductName, C.CategoryName, P.CategoryID, S.CompanyName FROM Products P JOIN Categories C ON P.CategoryID = C.CategoryID
JOIN Suppliers S ON P.SupplierID = S.SupplierID

-- Hangi sipariþ, hangi çalýþan tarafýndan, hangi müþteriye yapýldý.
SELECT O.OrderID, E.FirstName + ' ' + E.LastName, C.CompanyName FROM Orders O JOIN Employees E ON O.EmployeeID = E.EmployeeID JOIN Customers C ON O.CustomerID = C.CustomerID


-- Suppliers tablosundan CompanyName, ContactName
-- Products tablosundan ProductName, UnitPrice
-- Categories tablosundan CategoryName
-- CompanyName sütununa göre artan sýrada sýralayýnýz.

SELECT S.CompanyName, S.ContactName, P.ProductName, P.UnitPrice, C.CategoryName FROM Products P JOIN Suppliers S ON P.SupplierID = S.SupplierID JOIN Categories C ON P.CategoryID = C.CategoryID ORDER BY S.CompanyName

-- Kategorilere göre toplam stok miktarýný bulunuz.
SELECT C.CategoryName, SUM(UnitsInStock) FROM Categories C JOIN Products P ON C.CategoryID = P.CategoryID GROUP BY C.CategoryName 
