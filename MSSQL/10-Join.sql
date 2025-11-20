--JOIN: 2 VEYA DAHA FAZLA TABLOYU BİRLEŞTİRMEK İÇİN KULLANILIR
SELECT P.ProductName, C.CategoryName, P.CategoryID
FROM Products P 
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
--INNER yazmayadabilirsin. defaultu inner ztn
--ikisinde de olan sütünlarda tablo isminden git
--Alias kullandıysan Products.CategoryID = Category.CategoryID şeklinde yazamazsın
JOIN Suppliers S ON P.SuppliersID = S.SuppliersID -- bu kısım P ve C'den birleşmiş tabloyla işlem yapar.

--Hangi siparişi hangi çalışan tarafından, hangi müşteriye yapıldı
SELECT O.OrderID, E.FirstName + ' ' + E.LastName, C.CustomerID
FROM Orders O JOIN Employees E ON O.EmployeeID = E.EmployeeID
JOIN Customers C ON C.CustomerID = O.CustomerID

--supp tablosundan CompanyName,ContactName
--product ProductName, UnitPrice
--Categories CategoryName
--CompanyName sutununa göre artan sırada sırala
SELECT S.CompanyName, S.ContactName, P.ProductName, P.UnitPrice, C.CategoryName
FROM Suppliers S JOIN Products P ON S.SupplierID = P.SupplierID
JOIN Categories C ON C.CategoryID = P.CategoryID
ORDER BY S.CompanyName ASC;

--kategorilere göre toplam stok miktarlarını bul
SELECT C.CategoryName, SUM(P.UnitsInStock) AS Stock
FROM Products P JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName

-- her bir çalışan toplam ne kadarlık satış yaptı
SELECT E.EmployeeID, SUM(UnitPrice * Quantity * (1 - Discount))
FROM Orders O JOIN Employees E ON O.EmployeeID = E.EmployeeID
JOIN [dbo].[Order Details] D ON D.OrderID = O.OrderID
GROUP BY E.EmployeeID --(EmployeeID + FirstName + ' ' + Lastname) şeklinde yazabilirsin
ORDER BY 2 DESC;

--Left Join
SELECT CategoryName, ProductName
FROM Categories C LEFT JOIN Products P ON C.CategoryID = P.CategoryID --baklagillerin porduct name null gelir

--Right Join
SELECT CategoryName, ProductName
FROM Categories C RIGHT JOIN Products P ON C.CategoryID = P.CategoryID --elma category name boş gelir

--Full join
SELECT CategoryName, ProductName
FROM Categories C FULL JOIN Products P ON C.CategoryID = P.CategoryID 

--Tüm çalışanların rapor verdiği kişiyle birlikte listeleyin
SELECT E2.FirstName + ' ' + E2.LastName AS Calisan, E.FirstName + ' ' + E.LastName As Raporladigi
FROM Employees E 
RIGHT JOIN Employees E2 ON E.EmployeeID = E2.ReportsTo

SELECT E2.FirstName + ' ' + E2.LastName AS Calisan, E.FirstName + ' ' + E.LastName As Raporladigi
FROM Employees E 
RIGHT JOIN Employees E2 ON E.EmployeeID = E2.ReportsTo -- müdürün altında çalışanlar

SELECT E1.FirstName + ' ' + E1.LastName as calisan, E2.FirstName + ' ' + E2.LastName as mudur
FROM Employees E1 
LEFT JOIN Employees E2 ON E1.ReportsTo = E2.EmployeeID 

--Cross Join
SELECT COUNT(*) FROM Categories --9
SELECT COUNT(*) FROM Products --78

SELECT CategoryName, ProductName FROM Categories CROSS JOIN Products 

SELECT COUNT(*) FROM Products CROSS JOIN Suppliers