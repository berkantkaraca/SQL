--ORDER BY: sonuç kümesini sıralar
SELECT FirstName, LastName FROM Employees ORDER BY FirstName ASC -- ASC: artan sıralama, default
SELECT FirstName, LastName FROM Employees ORDER BY FirstName DESC -- DESC: azalan sıralama
SELECT TitleOfCourtesy + ' ' + FirstName + ' ' + LastName AS PersonName FROM Employees ORDER BY PersonName
SELECT FirstName AS Adi, LastName AS Soyadi, Title AS Unvan FROM Employees ORDER BY 3 DESC
SELECT OrderID, OrderDate, CustomerID FROM Orders ORDER BY OrderDate ASC, CustomerID DESC