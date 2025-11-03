--oracle server 
--oracle 

----GROUP BY, veri kümesini belirli bir sütuna göre gruplandırmak için kullanılır.
--SELECT FirstName, LastName Country FROM Employees; 

--SELECT Country, COUNT(*) AS KisiSayisi --select kısmına sadece group bydaki değişken kullanılır firstname yazamazsın
--FROM Employees 
--WHERE Country IS NOT NULL 
--GROUP BY Country; 

----çalışanların yapmış olduğu sipariş adedi
--SELECT EmployeeID, COUNT(*) 
--FROM Orders
--GROUP BY EmployeeID
--ORDER BY 2;

--SELECT EmployeeID, COUNT(*) AS SiparisAdedi
--FROM Orders
--GROUP BY EmployeeID
--ORDER BY SiparisAdedi;

----Ürün bedeli 35dolardan az olan ürünlerin kategorilerine göre grıplandırınız
--SELECT CategoryID, COUNT(*)
--FROM Products
--WHERE UnitPrice <= 35
--GROUP BY CategoryID

----Baş harfi A-K aralığında olan ve stok miktari 5 ile 50 olan ürünleri kategorilerine göre gruplayınız
--SELECT CategoryID, COUNT(*)
--FROM Products
--WHERE UnitsInStock BETWEEN 5 AND 50 AND ProductName LIKE '[A-K]%'
--GROUP BY CategoryID
--ORDER BY 2;


----Her bir siparişin tutarına göre listelenmesi
--SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) AS Tutar
--FROM [Order Details]
--GROUP BY OrderID

--SELECT * FROM [Order Details] WHERE OrderID = 10248

----Her bir siparişin tutarına göre listelenmesi
--SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) AS Tutar
--FROM [Order Details]
--GROUP BY OrderID


----HAVİNG: GRUPLAMA ÜZERİNDE BİR FİLTRELEME YAPMAK İSTEDİĞİMİZ ZAMAN KULLANILIR
----2500 İLE 3000 LİRA TUTARI GETİR
--SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) AS Tutar
--FROM [Order Details]
--GROUP BY OrderID
--HAVING SUM(UnitPrice * Quantity * (1 - Discount)) BETWEEN 2500 AND 3500 --ÇALIŞMA SIRASINDA DA YAPILDIĞI İÇİN FONKSİYON BURDA DA YAZILIR


----10DAN FAZLA SİPARİŞ VEREN MÜŞTERİLERİ BULUN
--SELECT CustomerID, COUNT(OrderID) AS ADET
--FROM Orders
--GROUP BY CustomerID
--HAVING COUNT(OrderID) > 10
--ORDER BY 2 DESC;


--SUB QUERY: 

----DEGİŞKEN TANIMLAMA
--DECLARE @Ad NVARCHAR(50)
--SET @Ad = 'BİLGEADAM' --BELLEĞE ALINMAZ İSTEK İÇİNDE GİDER SADECE. BU DEĞİŞKENİ KULLANMAK İÇİN AYNI QUERY İÇİNDE KULLANMAK LAZIM
--SELECT @Ad 

--DECLARE @AdSoyad NVARCHAR(50), @YAS INT
--SET @AdSoyad = 'FATİH'
--SET @YAS = '1'
--SELECT @AdSoyad = 'FATİH',@YAS = 1 --TOPLU ATAMA İŞLEMİ
--SELECT @AdSoyad ADI, @YAS YASI

--PRINT @AdSoyad -- STRİNG YAZAR

--DECLARE @UrunAdi  NVARCHAR(50)
--SET @UrunAdi = (SELECT ProductName FROM Products) --BİRDEN FAZLA DEĞİŞKENİ TEK DEĞİŞKENE ATAMADA HATA ALIRSIN
--SET @UrunAdi = (SELECT ProductName FROM Products WHERE ProductID = 10)


--DECLARE @UrunAdi1  NVARCHAR(50)
----SELECT  @UrunAdi1 = (SELECT ProductName FROM Products WHERE ProductID = 10) -- YİNE HATA ALIR
--SELECT  @UrunAdi1 = ProductName FROM Products
--SELECT  @UrunAdi1

--SELECT * FROM Products WHERE ProductName = @UrunAdi1 --İŞLEM YAPTIĞIMIZ KOLONU SIRALAR VE SONUNCUSUNU ATAR

----ORTALAMA FİYATIN ÜSTÜNÜ GETİR (SUBQUERY)
--DECLARE @OrtFiyat MONEY = (SELECT AVG(UnitPrice) FROM Products)
--SELECT * FROM Products WHERE UnitPrice >  @OrtFiyat

--SELECT * FROM Products WHERE UnitPrice >  (SELECT AVG(UnitPrice) FROM Products)

----ÜRÜNLER TABLASINDAKİ SATILAN ÜRÜNLERİN LİSTESİ (SUBBQUERY LİSTE DÖNERSE İN KULLAN)
--SELECT ProductID
--FROM [Order Details]

--SELECT * FROM Products WHERE ProductID IN (SELECT ProductID FROM [Order Details])
--SELECT * FROM Products WHERE ProductID IN (SELECT DISTINCT ProductID FROM [Order Details]) --DISTINCT İLE TEKRARLI KAYITLARI ENGELLE VE PERFORMANSI ARTTIR

----ÜRÜNLER TABLASINDAKİ SATILMAYAN ÜRÜNLERİN LİSTESİ
--SELECT * 
--FROM Products 
--WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM [Order Details])


----subquerylerde her zaman tek bir sutün çağırılır. Yapamazsın => (SELECT CategoryName, Description FROM Categories WHERE CategoryID = P.CategoryID )
--aynı tipleri birleştirmede sıkıntı yok: (SELECT CategoryName + ' ' + ' Deneme'  FROM Categories WHERE CategoryID = P.CategoryID )
--SELECT ProductName, UnitPrice, UnitsInStock, (SELECT CategoryName FROM Categories WHERE CategoryID = P.CategoryID )
--FROM Products P

----Kargo şirketlerinin taşıdıkları sipariş sayıları.
--SELECT CompanyName, (SELECT COUNT(*) FROM Orders WHERE ShipVia = ShipperID GROUP BY ShipVia) 
--FROM Shippers
--Select (Select CompanyName From Shippers Where .ShipperID=ShipVia) as KargoSirketi, COUNT(*)
--From Orders
--Group By ShipVia



----JOIN: 2 VEYA DAHA FAZLA TABLOYU BİRLEŞTİRMEK İÇİN KULLANILIR
--SELECT P.ProductName, C.CategoryName, P.CategoryID
--FROM Products P INNER JOIN Categories C ON P.CategoryID = C.CategoryID
----INNER yazmayadabilirsin. defaultu inner ztn
----ikisinde de olan sütünlarda tablo isminden git
----Alias kullandıysan Products.CategoryID = Category.CategoryID şeklinde yazamazsın
--JOIN Suppliers S ON P.SuppliersID = S.SuppliersID -- bu kısım P ve C'den birleşmiş tabloyla işlem yapar.


----Hangi siparişi hangi çalışan tarafından, hangi müşteriye yapıldı
--SELECT O.OrderID, E.FirstName + ' ' + E.LastName, C.CustomerID
--FROM Orders O JOIN Employees E ON O.EmployeeID = E.EmployeeID
--JOIN Customers C ON C.CustomerID = O.CustomerID


---- supp tablosundan CompanyName,ContactName
---- prodyct ProductName, UnitPrice
---- Categories CategoryName
----CompanuName sutununa göre artan sırada sırala
--SELECT S.CompanyName, S.ContactName, P.ProductName, P.UnitPrice, C.CategoryName
--FROM Suppliers S JOIN Products P ON S.SupplierID = P.SupplierID
--JOIN Categories C ON C.CategoryID = P.CategoryID
--ORDER BY S.CompanyName ASC;

--kategorilere göre toplam stok miktarlarını bul
SELECT C.CategoryName, SUM(P.UnitsInStock) AS Stock
FROM Products P JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName
















