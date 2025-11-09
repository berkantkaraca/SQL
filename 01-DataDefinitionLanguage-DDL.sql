--Veri Tanımlama Dili (Data Definition Language - DDL) Komutları

--Create Database: Yeni bir veritabanı oluşturur.
CREATE DATABASE OrnekVeritabani;

--Özelleşmiş bir veritabanı oluşturma
CREATE DATABASE OrnekVeritabani2
ON PRIMARY
(
    NAME = OrnekVeritabani2, --veritabanı dosyasının adı
    FILENAME = 'C:\SQLData\OrnekVeritabani2.mdf', --veritabanı dosyasının fiziksel yolu
    SIZE = 10MB, -- mb cinsinden başlangıç boyutu
    MAXSIZE = 100MB, -- mb cinsinden maksimum boyut sınırı (UNLIMITED olarak ayarlanabilir)
    FILEGROWTH = 5MB -- mb cinsinden dosya büyüme boyutu
)

--Log dosyası ekleme (Otomatik oluşturul)
LOG ON
(
    NAME = OrnekVeritabani2_Log, --log dosyasının adı
    FILENAME = 'C:\SQLData\OrnekVeritabani2_Log.ldf', --log dosyasının fiziksel yolu
    SIZE = 5MB, -- mb cinsinden başlangıç boyutu
    MAXSIZE = 50MB, -- mb cinsinden maksimum boyut sınırı (UNLIMITED olarak ayarlanabilir)
    FILEGROWTH = 5MB -- mb cinsinden dosya büyüme boyutu
);

--Database Silme: Mevcut bir veritabanını siler.
ALTER DATABASE OrnekVeritabani SET SINGLE_USER WITH ROLLBACK IMMEDIATE; --Veritabanını tek kullanıcı moduna alır ve mevcut işlemleri sonlandırır.
DROP DATABASE OrnekVeritabani;

-------------------------------------------------------------------------------------------------------------------------

CREATE DATABASE PersonelDB;

--Database seçme: Belirli bir veritabanını kullanmak için seçer.
USE PersonelDB;

--Tablo olşturma
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY, --Birincil anahtar olarak tanımlanan çalışan kimlik numarası
    Name NVARCHAR(50) NOT NULL, --Çalışanın adı (boş geçilemez)
    HireDate DATE DEFAULT GETDATE(), --Çalışanın işe başlama tarihi (varsayılan olarak mevcut tarih)
    Salary DECIMAL(18, 2) CHECK (Salary >= 0) --Çalışanın maaşı (negatif olamaz)
);

--Tablo silme
DROP TABLE Employees;

-- Tablo Güncelleme
ALTER TABLE Employees 
ADD BirthDate DATETIME; --Yeni bir sütun ekler

ALTER TABLE Employees 
ALTER COLUMN BirthDate DATE; --Sütun veri tipini değiştirir

ALTER TABLE Employees 
DROP COLUMN BirthDate; --Sütunu siler

-- Kısıtlamalar ekleme
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY IDENTITY(1,1), --Birincil anahtar, IDENTITY(1,1) 1den başlayarak 1 artar 
    Name NVARCHAR(50) NOT NULL, --Boş geçilemez
    Email NVARCHAR(100) UNIQUE, --E-posta adresi (benzersiz olmalı), sadece 1 satır null olabilir
    HireDate DATE DEFAULT GETDATE(), --Çalışanın işe başlama tarihi (varsayılan olarak mevcut tarih)
    Salary DECIMAL(18, 2) CHECK (Salary >= 0) --Çalışanın maaşı (negatif olamaz)
    City NVARCHAR(50) DEFAULT 'Istanbul' --Eğer değer girilmezse varsayılan olarak 'Istanbul' atanır
);

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY ,
    EmployeeID INT,
    PRICE DECIMAL(18,2) CHECK (PRICE >= 0), --Fiyat negatif olamaz
    OrderDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) --Yabancı anahtar kısıtlaması
);


ALTER TABLE Employees 
ADD CONSTRAINT Email NOT NULL; --Mevcut sütuna NOT NULL kısıtlaması ekler

ALTER TABLE Employees 
DROP CONSTRAINT Email; --Mevcut sütundan NOT NULL kısıtlamasını kaldırır