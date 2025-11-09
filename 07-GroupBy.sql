--GROUP BY, veri kümesini belirli bir sütuna göre gruplandırmak için kullanılır.
SELECT FirstName, LastName, Country 
FROM Employees; 

SELECT Country, COUNT(*) AS KisiSayisi --select kısmına sadece group bydaki değişken kullanılır firstname yazamazsın
FROM Employees 
WHERE Country IS NOT NULL 
GROUP BY Country; 

--çalışanların yapmış olduğu sipariş adedi
SELECT EmployeeID, COUNT(*) 
FROM Orders
GROUP BY EmployeeID
ORDER BY 2;

SELECT EmployeeID, COUNT(*) AS SiparisAdedi
FROM Orders
GROUP BY EmployeeID
ORDER BY SiparisAdedi;

--Ürün bedeli 35dolardan az olan ürünlerin kategorilerine göre grıplandırınız
SELECT CategoryID, COUNT(*)
FROM Products
WHERE UnitPrice <= 35
GROUP BY CategoryID

--Baş harfi A-K aralığında olan ve stok miktari 5 ile 50 olan ürünleri kategorilerine göre gruplayınız
SELECT CategoryID, COUNT(*)
FROM Products
WHERE UnitsInStock BETWEEN 5 AND 50 AND ProductName LIKE '[A-K]%'
GROUP BY CategoryID
ORDER BY 2;


--Her bir siparişin tutarına göre listelenmesi
SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) AS Tutar
FROM [Order Details]
GROUP BY OrderID

SELECT * FROM [Order Details] 
WHERE OrderID = 10248

--Her bir siparişin tutarına göre listelenmesi
SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) AS Tutar
FROM [Order Details]
GROUP BY OrderID