--View: bir veya birden fazla tablodan seçilmiş verilerin sanal bir görünümünü sağlayan nesnedir.

CREATE VIEW CustomerCityView AS 
SELECT CompanyName, City FROM Customers

--joinli yapıların viewını oluşturmak daha performanslıdır

SELECT * FROM CustomerCityView

--tabloya insert yaptığında viewda görürsün
--viewa insert yapılabilir ama database uygun olmalı. mesela burda customerID hata verir eklerken. Bu viewa CustomerID eklenseydi hem viewa hemde ana tabloya eklenir
INSERT INTO CustomerCityView (CompanyName, City) VALUES ('DENEME','IST') --

ALTER VIEW CustomerCityView AS 
SELECT CustomerID, CompanyName, City FROM Customers

INSERT INTO CustomerCityView (CustomerID, CompanyName, City) VALUES ('ASDFG','DENEME','IST')

SELECT * FROM CustomerCityView

CREATE VIEW SiparisRaporlari AS 
SELECT 
	E.FirstName, E.LastName,
	C.CompanyName, C.ContactName,
	P.ProductName, P.UnitsInStock,
	CT.CategoryName,
	OD.UnitPrice, OD.Quantity
FROM Orders O
JOIN Employees E On O.EmployeeID = E.EmployeeID
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN [dbo].[Order Details] OD ON OD.OrderID = O.OrderID
JOIN Products P ON P.ProductID = OD.ProductID

JOIN Categories CT ON P.CategoryID = CT.CategoryID

SELECT * FROM SiparisRaporlari
