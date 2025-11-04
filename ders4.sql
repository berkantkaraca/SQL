---- her bir çalışan toplam ne kadarlık satış yaptı
--SELECT E.EmployeeID, SUM(UnitPrice * Quantity * (1 - Discount))
--FROM Orders O JOIN Employees E ON O.EmployeeID = E.EmployeeID
--JOIN [dbo].[Order Details] D ON D.OrderID = O.OrderID
--GROUP BY E.EmployeeID --(EmployeeID + FirstName + ' ' + Lastname) şeklinde yazabilirsin
--ORDER BY 2 DESC;


----Left Join
--SELECT CategoryName, ProductName
--FROM Categories C LEFT JOIN Products P ON C.CategoryID = P.CategoryID --baklagillerin porduct name null gelir



----Right Join
--SELECT CategoryName, ProductName
--FROM Categories C RIGHT JOIN Products P ON C.CategoryID = P.CategoryID --elma category name boş gelir

----Full join
--SELECT CategoryName, ProductName
--FROM Categories C FULL JOIN Products P ON C.CategoryID = P.CategoryID 



--Tüm çalışanların rapor verdiği kişiyle birlikte listeleyin
SELECT E2.FirstName + ' ' + E2.LastName AS Calisan, E.FirstName + ' ' + E.LastName As Raporladigi
FROM Employees E RIGHT JOIN Employees E2 ON E.EmployeeID = E2.ReportsTo

SELECT E2.FirstName + ' ' + E2.LastName AS Calisan, E.FirstName + ' ' + E.LastName As Raporladigi
FROM Employees E RIGHT JOIN Employees E2 ON E.EmployeeID = E2.ReportsTo -- müdürün altında çalışanlar

SELECT E1.FirstName + ' ' + E1.LastName as calisan, E2.FirstName + ' ' + E2.LastName as mudur
FROM Employees E1 left JOIN Employees E2 ON E1.ReportsTo = E2.EmployeeID 


--Cross Join
SELECT COUNT(*) FROM Categories --9
SELECT COUNT(*) FROM Products --78

SELECT CategoryName, ProductName FROM Categories CROSS JOIN Products 

SELECT COUNT(*) FROM Products CROSS JOIN Suppliers