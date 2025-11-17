--WHERE:
SELECT FirstName, LastName FROM Employees WHERE EmployeeID > 5
SELECT FirstName, LastName, TitleOfCourtesy FROM Employees WHERE TitleOfCourtesy != 'Mr.' AND TitleOfCourtesy != 'Dr.'
SELECT FirstName, LastName, BirthDate FROM Employees WHERE YEAR(BirthDate) >= 1950 AND YEAR(BirthDate) <= 1961

-- İngiltere'de oturan bayanların adı, soyadı, mesleği, ünvanı, ülkesi ve doğum tarihini listeleyiniz.
SELECT (TitleOfCourtesy + ' ' +  FirstName + ' ' + LastName) AS Name, Title AS Ocupation, BirthDate FROM Employees
WHERE Country = 'UK' AND (TitleOfCourtesy='Mrs.' OR TitleOfCourtesy='Ms.') 

SELECT Region FROM Employees WHERE Region IS NOT NULL
SELECT Region FROM Employees WHERE Region IS NULL

--BETWEEN
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice >= 10 AND UnitPrice <= 20 
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 10 AND 20
SELECT OrderId, OrderDate FROM Orders WHERE OrderDate BETWEEN '1996-07-04' AND '1996-08-04'
SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID BETWEEN 'A' AND 'F'

--IN
SELECT ProductName, CategoryID FROM Products WHERE CategoryID=1 OR CategoryID=3 OR CategoryID=5
SELECT ProductName, CategoryID FROM Products WHERE CategoryID IN (1,3,5)
SELECT CustomerID, CompanyName, Country FROM Customers WHERE Country IN ('USA', 'Canada', 'Mexico') 

--LIKE 
SELECT FirstName, LastName FROM Employees WHERE FirstName = 'Michael'
SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE 'Michael'

SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE 'a%' --Adının ilk harfi a ile başlayanlar.
SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE '%n' --Adının son harfi n ile bitenler.
SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE '%e%' --Adının içerisinde e harfi geçenler. 

SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE 'a%' OR FirstName LIKE 'L%'
SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE '[al]%' -- A veya L olanlar
SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE '[a-l]%' --A ile L aralığında 

SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE '%A_E%' --Karakter
SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE '%A__E%' --Karakter

--Adının ilk harfi m olmayanlar.
SELECT FirstName, LastName FROM Employees WHERE FirstName NOT LIKE 'M%'
SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE '[^M]%'

--ProductName değeri C ile başlayıp 2 karakterli bir kelimeye sahip olan ürünler.
SELECT ProductName FROM Products WHERE ProductName LIKE '%C__%'

--A ile başlayıp B,C veya D ile devam edenler.
SELECT ProductName FROM Products WHERE ProductName LIKE '%A[BCD]%'

--Adının ilk iki harfi LA, LN, AA veya AN olanlar. Employee - FirstName
SELECT FirstName, LastName, Title FROM Employees WHERE FirstName LIKE '[LA][AN]%'