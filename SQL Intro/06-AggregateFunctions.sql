--Aggregate Functions
SELECT COUNT(*) FROM Employees
SELECT COUNT(EmployeeId), FirstName FROM Employees WHERE EmployeeID >= 4
SELECT COUNT(Region) FROM Employees

SELECT SUM(UnitPrice) FROM Products
SELECT SUM(UnitPrice * Quantity) FROM [Order Details] WHERE OrderID = 10248

SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = 8

SELECT MIN(UnitPrice) FROM Products 
SELECT MAX(UnitPrice) FROM Products