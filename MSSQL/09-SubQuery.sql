--SUB QUERY: ALT SORGULAR

--DEGİŞKEN TANIMLAMA
DECLARE @Ad NVARCHAR(50)
SET @Ad = 'BİLGEADAM' --BELLEĞE ALINMAZ İSTEK İÇİNDE GİDER SADECE. BU DEĞİŞKENİ KULLANMAK İÇİN AYNI QUERY İÇİNDE KULLANMAK LAZIM
SELECT @Ad 

DECLARE @AdSoyad NVARCHAR(50), @YAS INT
SET @AdSoyad = 'FATİH'
SET @YAS = '1'
SELECT @AdSoyad = 'FATİH',@YAS = 1 --TOPLU ATAMA İŞLEMİ
SELECT @AdSoyad ADI, @YAS YASI

PRINT @AdSoyad -- STRİNG YAZAR

DECLARE @UrunAdi  NVARCHAR(50)
SET @UrunAdi = (SELECT ProductName FROM Products) --BİRDEN FAZLA DEĞİŞKENİ TEK DEĞİŞKENE ATAMADA HATA ALIRSIN
SET @UrunAdi = (SELECT ProductName FROM Products WHERE ProductID = 10)

DECLARE @UrunAdi1  NVARCHAR(50)
--SELECT  @UrunAdi1 = (SELECT ProductName FROM Products WHERE ProductID = 10) -- YİNE HATA ALIR
SELECT  @UrunAdi1 = ProductName FROM Products
SELECT  @UrunAdi1

SELECT * FROM Products WHERE ProductName = @UrunAdi1 --İŞLEM YAPTIĞIMIZ KOLONU SIRALAR VE SONUNCUSUNU ATAR

--ORTALAMA FİYATIN ÜSTÜNÜ GETİR (SUBQUERY)
DECLARE @OrtFiyat MONEY = (SELECT AVG(UnitPrice) FROM Products)
SELECT * FROM Products WHERE UnitPrice >  @OrtFiyat

SELECT * FROM Products WHERE UnitPrice >  (SELECT AVG(UnitPrice) FROM Products)

--ÜRÜNLER TABLASINDAKİ SATILAN ÜRÜNLERİN LİSTESİ (SUBBQUERY LİSTE DÖNERSE İN KULLAN)
SELECT * FROM Products WHERE ProductID IN (SELECT ProductID FROM [Order Details])
SELECT * FROM Products WHERE ProductID IN (SELECT DISTINCT ProductID FROM [Order Details]) --DISTINCT İLE TEKRARLI KAYITLARI ENGELLE VE PERFORMANSI ARTTIR

--ÜRÜNLER TABLASINDAKİ SATILMAYAN ÜRÜNLERİN LİSTESİ
SELECT * 
FROM Products 
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM [Order Details])

--subquerylerde her zaman tek bir sutün çağırılır. 
--Yapamazsın => (SELECT CategoryName, Description FROM Categories WHERE CategoryID = P.CategoryID )
--aynı tipleri birleştirmede sıkıntı yok: (SELECT CategoryName + ' ' + ' Deneme'  FROM Categories WHERE CategoryID = P.CategoryID )
SELECT ProductName, UnitPrice, UnitsInStock, (SELECT CategoryName FROM Categories WHERE CategoryID = P.CategoryID )
FROM Products P

--Kargo şirketlerinin taşıdıkları sipariş sayıları.
SELECT CompanyName, (SELECT COUNT(*) FROM Orders WHERE ShipVia = ShipperID GROUP BY ShipVia) 
FROM Shippers
Select (Select CompanyName From Shippers Where .ShipperID=ShipVia) as KargoSirketi, COUNT(*)
From Orders
Group By ShipVia