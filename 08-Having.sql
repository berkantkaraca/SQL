--HAVİNG: GRUPLAMA ÜZERİNDE BİR FİLTRELEME YAPMAK İSTEDİĞİMİZ ZAMAN KULLANILIR
--2500 İLE 3000 LİRA TUTARI GETİR
SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) AS Tutar
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(UnitPrice * Quantity * (1 - Discount)) BETWEEN 2500 AND 3500 --Çalışma sırasında da yapıldığı için fonksiyon burda da yazılır

--10DAN FAZLA SİPARİŞ VEREN MÜŞTERİLERİ BULUN
SELECT CustomerID, COUNT(OrderID) AS ADET
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 10
ORDER BY 2 DESC;