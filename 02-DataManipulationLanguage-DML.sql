--Veri İşleme Dili (Data Manipulation Language - DML) Komutları

--Veri ekleme
INSERT INTO Employees (Name, Email, Salary)
VALUES ('Ahmet Yılmaz', 'ahmet.yilmaz@example.com', 5000.00);

--Toplu veri ekleme
INSERT INTO Employees (Name, Email, Salary)
VALUES 
('Ayşe Demir', 'ayse.demir@example.com', 6000.00),
('Mehmet Kaya', 'mehmet.kaya@example.com', 7000.00);

--Veri güncelleme
UPDATE Employees
SET Salary = Salary * 1.1 --Maaşı %10 artırır
WHERE EmployeeID = 1; --EmployeeID'si 1 olan çalışan için

--Veri silme
DELETE FROM Employees
WHERE EmployeeID = 2; --EmployeeID'si 2 olan çalışanı siler

--SELECT: sql dilinde verileri sorgulamak için kullanılan temel bir komuttur. Select bize sonuç kümesini döner.
SELECT * FROM Employees
SELECT FirstName, LastName, Title FROM Employees
SELECT Personel = TitleOfCourtesy + ' ' + FirstName + ' ' + LastName FROM Employees

SELECT ProductName, UnitPrice, ROUND(UnitPrice * 1.10,2) AS [Zamli Fiyat] FROM Products
SELECT ProductName, UnitPrice, ROUND(UnitPrice * 1.10,2) AS 'Zamli Fiyat' FROM Products

--Tekil kayıtları listeleme. tek bir kolon için DISTINCT kullanılır.
SELECT DISTINCT City FROM Employees

SELECT ProductName, UnitPrice FROM Products ORDER BY UnitPrice 
OFFSET 10 ROWS --Skip gibi 
FETCH NEXT 5 ROWS ONLY --Take gibi
