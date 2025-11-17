USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'BerkantKaraca')
BEGIN
    ALTER DATABASE BerkantKaraca SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BerkantKaraca;
END
GO

CREATE DATABASE BerkantKaraca;
GO

USE BerkantKaraca;
GO

-- Customers
CREATE TABLE Customers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NULL,
    Address NVARCHAR(255) NULL,
    RegisterDate DATETIME DEFAULT GETDATE()
);

-- Products
CREATE TABLE Products (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Stock INT NOT NULL,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Orders
CREATE TABLE Orders (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    Status NVARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);

-- OrderDetails
CREATE TABLE OrderDetails (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES Orders(Id),
    FOREIGN KEY (ProductId) REFERENCES Products(Id)
);

-- Payments
CREATE TABLE Payments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL UNIQUE,
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(50) NOT NULL CHECK (PaymentMethod IN ('Kredi Kartı', 'PayPal', 'Havale/EFT')),
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    FOREIGN KEY (OrderId) REFERENCES Orders(Id)
);

-- Shipping
CREATE TABLE Shipping (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL UNIQUE,
    CargoCompany NVARCHAR(100) NOT NULL,
    TrackingNumber NVARCHAR(50) NOT NULL,
    CargoStatus NVARCHAR(20) NULL CHECK (CargoStatus IN ('Dağıtımda', 'Hazırlanıyor', 'Paketlendi', 'Teslim Edildi')),
    FOREIGN KEY (OrderId) REFERENCES Orders(Id)
);

-- Discounts
CREATE TABLE Discounts (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CouponCode NVARCHAR(50) NOT NULL UNIQUE,
    DiscountRate DECIMAL(5,2) NOT NULL,
    ValidUntil DATETIME NOT NULL
);

-- ProductReviews
CREATE TABLE ProductReviews (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    CustomerId INT NOT NULL,
    Rating TINYINT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(1000) NULL,
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);

-- UserRoles
CREATE TABLE UserRoles (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL UNIQUE,
    UserRole NVARCHAR(20) NOT NULL CHECK (UserRole IN ('Admin', 'Customer')),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);

-- Örnek veriler
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
VALUES 
('Berkant', 'Karaca', 'berkant@example.com', '5551112233', 'İstanbul'),
('Ayşe', 'Yılmaz', 'ayse@example.com', '5552223344', 'Ankara'),
('Mehmet', 'Demir', 'mehmet@example.com', '5553334455', 'İzmir'),
('Elif', 'Çelik', 'elif@example.com', '5554445566', 'Bursa'),
('Ahmet', 'Kaya', 'ahmet@example.com', '5555556677', 'Antalya');

INSERT INTO Products (ProductName, Category, Price, Stock, Description)
VALUES
('Laptop', 'Elektronik', 15000.00, 10, 'Gaming laptop'),
('Telefon', 'Elektronik', 8000.00, 20, 'Akıllı telefon'),
('Kulaklık', 'Elektronik', 500.00, 50, 'Kablosuz kulaklık'),
('Masa', 'Mobilya', 1200.00, 15, 'Çalışma masası'),
('Sandalye', 'Mobilya', 600.00, 30, 'Ofis sandalyesi');

INSERT INTO Orders (CustomerId, TotalAmount, Status)
VALUES
(1, 15500.00, 'Pending'),
(2, 8000.00, 'Completed'),
(3, 1200.00, 'Pending'),
(4, 650.00, 'Cancelled'),
(5, 2100.00, 'Completed');

INSERT INTO OrderDetails (OrderId, ProductId, Quantity, UnitPrice)
VALUES
(1, 1, 1, 15000.00),
(1, 3, 1, 500.00),
(2, 2, 1, 8000.00),
(3, 4, 1, 1200.00),
(5, 4, 1, 1200.00),
(5, 5, 1, 900.00);

INSERT INTO Payments (OrderId, PaymentMethod, Amount)
VALUES
(1, 'Kredi Kartı', 15500.00),
(2, 'PayPal', 8000.00),
(3, 'Havale/EFT', 1200.00),
(4, 'Kredi Kartı', 650.00),
(5, 'PayPal', 2100.00);

INSERT INTO Shipping (OrderId, CargoCompany, TrackingNumber, CargoStatus)
VALUES
(1, 'Yurtiçi Kargo', '33515456456', 'Hazırlanıyor'),
(2, 'MNG Kargo', '24562464654', 'Teslim Edildi'),
(3, 'Sürat Kargo', '32424325456', 'Dağıtımda'),
(4, 'Aras Kargo', '12446366857', 'Paketlendi'),
(5, 'Yurtiçi Kargo', '35345735638', 'Teslim Edildi');

INSERT INTO Discounts (CouponCode, DiscountRate, ValidUntil)
VALUES
('VAKIF', 10.00, '2025-12-31'),
('BANK', 15.00, '2025-09-30'),
('C#', 20.00, '2025-11-29'),
('SQL', 5.00, '2025-06-30'),
('ANGULAR', 25.00, '2025-12-31');

INSERT INTO ProductReviews (ProductId, CustomerId, Rating, Comment)
VALUES
(1, 1, 5, 'Harika laptop'),
(2, 2, 4, 'Telefon iyi'),
(3, 3, 3, 'Kalitesi orta'),
(4, 4, 5, 'Tam istediğim gibi'),
(5, 5, 4, 'Rahat');

INSERT INTO UserRoles (CustomerId, UserRole)
VALUES
(1, 'Admin'),
(2, 'Customer'),
(3, 'Customer'),
(4, 'Customer'),
(5, 'Customer');
