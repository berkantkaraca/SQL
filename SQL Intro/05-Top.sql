--TOP 
SELECT TOP (50) ProductName FROM Products ORDER BY ProductName DESC
SELECT TOP 25 PERCENT ProductName FROM Products ORDER BY ProductName

SELECT TOP 12 WITH TIES ProductName, UnitPrice FROM Products ORDER BY UnitPrice --TIES: Eğer 12. sıradaki fiyatla aynı fiyata sahip ürünler varsa onları da getirir.
