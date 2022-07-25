

USE Northwind
-- 1.
--- Çalışan isim ve soyisimlerini yan yana yazdır 
SELECT Concat (firstname, ' ', lastname) AS FullName
FROM Employees



-- 2. unitprice 100 �zerinde olanlar, alt�nda olanlar ve 10-30 aras�nda olanlar --s�tun isimleri verilerek.
SELECT *
FROM Products
WHERE UnitPrice > 100;

SELECT *
FROM Products
WHERE UnitPrice < 100;

SELECT *
FROM Products
WHERE UnitPrice BETWEEN 10
		AND 30;

-- 3. stok 20 alt�nda ve �st�nde olanlar ayr� ayr� ve 10-30 aras�nda olan var m�? stok olmayan var m�?
SELECT *
FROM Products
WHERE UnitsInStock < 20;

SELECT *
FROM Products
WHERE UnitsInStock > 20;

SELECT *
FROM Products
WHERE UnitsInStock < 30
	AND UnitsInStock > 10;

-- 4. shipped date 1.11.97 �ncesinde olan sipari� idleri (tarihler beraber) ve shipped dateleri 23.09.97'den b�y�k olanlar�n employeeidleri?
SELECT *
FROM orders
WHERE ShippedDate BETWEEN '1997-09-23' AND '1997-11-01';

-- 5. title'lar� 'sales rep.' olanlar�n adresleri ve idleri?
SELECT *
FROM Employees
WHERE Title = 'Sales Representative';

-- 6. do�um g�n� mart ve nisanda olanlar�n say�s�?
SELECT count(*)
FROM Employees
WHERE datepart(month, BirthDate) = 3
	OR datepart(month, BirthDate) = 4;

-- 7. 28 ya��ndan b�y�k i�e girenler kimler?
SELECT datediff(Year, e.BirthDate, e.HireDate) AS ageDifference
	,CONCAT (
		FirstName
		,'-'
		,upper(e.LastName)
		) AS FullName
FROM Employees e
WHERE datediff(Year, e.BirthDate, e.HireDate) > 28;

-- 8. �u an 35 ya��ndan b�y�k olanlar kimler?
SELECT datediff(year, BirthDate, getdate()) AS age
	,FirstName
	,LastName
FROM Employees
WHERE datediff(year, BirthDate, getdate()) > 35;

-- 9. company name Q ile ba�layanlar?, do ge�enler ve i�inde hi� a olmayanlar
-- regex ile ��z�l�r.
-- 10. almanyan�n berlinden olanlar, USA olanlar�n regionlar�, regionlar� bo� olmayanlar?
SELECT *
FROM Customers
WHERE city = 'Berlin';

SELECT Region
FROM Customers
WHERE Country = 'USA';

SELECT *
FROM Customers
WHERE Region IS NOT NULL;

-- 1. toplam stok
SELECT sum(UnitsInStock)
FROM Products;

-- 2. Ka� adet �r�n var?
SELECT count(*) AS cnt
FROM Products;

-- 3. �r�n indirim ortalamas�
SELECT DISTINCT avg(OD.Discount)
FROM [Order Details] AS OD;

SELECT *
FROM products

-- 4. stoklar� 20 alt�nda olan productlar�n toplam� 
SELECT sum(UnitPrice)
FROM products
WHERE UnitsInStock < 20;

-- 5. stoklar� 20 alt�nda olan productlar�n ortalamas�
SELECT count(*)
FROM products
WHERE UnitsInStock < 20;

-- 6. Ka� adet farkl� contact title var*
SELECT count(DISTINCT ContactTitle)
FROM Customers;

-- 7 DISCONTINUED Yes (Y) olanlar�n stok toplam� 
SELECT sum(UnitsInStock)
FROM products
WHERE Discontinued = 1

-- 7.1 DISCONTINUED Yes (Y) olanlar�n order detail tablosunda yap�lan indirimlerinin ortalamas�
SELECT avg(Discount)
FROM [Order Details]
WHERE ProductID IN (
		SELECT ProductID
		FROM products
		WHERE Discontinued = 1
		)

-- 8 bir sipari� i�in �denen �cret?
SELECT sum(OD.Quantity * OD.UnitPrice) AS price
	,O.OrderID
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
GROUP BY O.OrderID

SELECT *
FROM [Order Details]

-- 9 Her sipari� i�in yap�lan indirim toplam�?
SELECT sum(OD.Discount * P.UnitPrice) AS discount
	,O.OrderID
FROM [Order Details] AS OD
LEFT JOIN Orders AS O ON OD.OrderID = O.OrderID
LEFT JOIN Products AS P ON OD.ProductID = P.ProductID
WHERE OD.Discount != 0
GROUP BY O.OrderID
HAVING sum(OD.Discount * P.UnitPrice) > 5

-- 10 Sipari�in indirim �ncesi ve indirim sonras� �denen �creti 
SELECT sum(OD.Quantity * P.UnitPrice) AS beforeDiscount
	,sum((OD.Quantity * P.UnitPrice) - (OD.Discount * P.UnitPrice)) AS afterDiscount
	,O.OrderID
FROM [Order Details] AS OD
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE OD.Discount != 0
GROUP BY O.OrderID

-- 11. Sipari�te indirim y�zde ne kadar etkilemi�
SELECT * FROM [Order Details]

-- 12. Sipari�ler ka� g�nde gitmi�?
SELECT o.OrderID
	,datediff(day, OrderDate, ShippedDate) AS DayToShipAfterOrder
FROM orders o;

-- 10. kargolama s�releri g�ne g�re gruplama
SELECT datediff(day, OrderDate, ShippedDate) AS DayToShipAfterOrder
	,count(o.OrderID)
FROM orders o
WHERE datediff(day, OrderDate, ShippedDate) IS NOT NULL
GROUP BY datediff(day, OrderDate, ShippedDate)

-- having datediff(day, OrderDate, ShippedDate) is not null;
-- aggregate fonksiyonlar�n� �artl� ifade i�ersinde kullanmak istersen having ile yapmal�s�n.
-- shipregion'u RJ ve CA olmayan sipari�lerin Adedi
SELECT count(*)
FROM orders
WHERE ShipRegion NOT IN (
		'RJ'
		,'CA'
		);

-- ismi A ile ba�layanlar�n sat�� toplam� ve paras�
-- �smi A ile ba�layan �al��anlar�n toplam sat��lar�
SELECT sum(od.UnitPrice * od.Quantity) AS totalSale
FROM Orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE e.FirstName LIKE 'A%'

-- fax numaras� 8den b�y�k olanlar� getir
SELECT *
FROM customers
WHERE left(Fax, 1) > '8'

-- DESCRIPTIONLARI V�RG�LE G�RE AYIRARAK KATEGOR� �S�MLER�N� KAR�ISINA GET�R
-- String split �al��m�yor.
-- order_Date ile shipped_date aras�nda 30 g�nden fazla olan sipari�lere ortalama ne kadar indirim yap�ld�?
SELECT avg(od.UnitPrice * od.Discount) AS averageDiscount
	,o.OrderID
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 30
GROUP BY o.OrderID

-- employee baz�nda t�m sat��lar analizi 
SELECT e.EmployeeID
	,avg(od.Quantity * od.UnitPrice) AS averageSale
	,sum(od.Quantity * od.UnitPrice) AS totalSale
FROM orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID

-- order baz�nda en �ok quantitysi olanlar
SELECT e.EmployeeID
	,od.Quantity
FROM orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID
	,od.Quantity
ORDER BY od.Quantity

-- sipari� ve kargolanma aras�nda 7 g�nden fazla olan �r�nlerin ayl�k adet g�r�nt�s�
SELECT DATEPART(MONTH, OrderDate) AS months
	,count(*) AS total
FROM orders
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 7
GROUP BY DATEPART(MONTH, OrderDate)

-- toplam 7 g�nden fazla olan �r�n adetlerinin adedi
SELECT COUNT(DISTINCT od.ProductID)
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 7

-- ka� adet �r�n supply oldu�u �lke d���na gidiyor?
SELECT count(*)
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.Country != o.ShipCity

-- employenin ortalama kargo sipari� s�resini bul
SELECT e.EmployeeID
	,avg(datediff(day, OrderDate, ShippedDate)) AS average
FROM orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID

-- categori isimlerini yan yana yazd�r.
SELECT STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(CategoryName, 'N/A')), ', ')
FROM Categories

-- �al��anlara g�re satt�klar� �r�nler, ka� adet satm�� ve paras�
SELECT o.EmployeeID
	,count(od.ProductID) AS sellCount
	,sum(od.Quantity * od.UnitPrice) AS sellSum
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.EmployeeID

-- ismi A ile ba�layanlar�n sat�� toplam� ve paras�
SELECT o.EmployeeID
	,count(od.ProductID) AS sellCount
	,sum(od.Quantity * od.UnitPrice) AS sellSum
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.FirstName LIKE 'A%'
GROUP BY o.EmployeeID

-- order_Date ile shipped_date aras�nda 30 g�nden fazla olan sipari�lere ortalama ne kadar indirim yap�ld�?
SELECT o.OrderID
	,avg((od.Quantity * od.UnitPrice) - (od.UnitPrice * od.Discount)) AS averageDiscount
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 30
GROUP BY o.OrderID

-- t�m indirim toplam�
SELECT sum(od.UnitPrice * od.Discount) AS totalDiscount
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID

-- 1. employeenin bir sonraki sipari�ne kadar ge�en s�re ortalamas�
SELECT t.EmployeeID
	,avg(t.daydiff) AS daydifference
FROM (
	SELECT EmployeeID
		,orderDate
		,LEAD(OrderDate) OVER (
			PARTITION BY EmployeeID ORDER BY orderDate
			) AS dayy
		,datediff(day, OrderDate, LEAD(OrderDate) OVER (
				PARTITION BY EmployeeID ORDER BY orderDate
				)) AS daydiff
	FROM orders
	) AS t
GROUP BY EmployeeID

-- 2. employee baz�nda sonraki sipari� tahmini tarihi
SELECT t.EmployeeID
	,max(OrderDate) + avg(t.DayDifference) AS Guess
FROM (
	SELECT EmployeeID
		,OrderDate
		,LEAD(OrderDate) OVER (
			PARTITION BY EmployeeID ORDER BY orderDate
			) AS DayLead
		,datediff(day, OrderDate, LEAD(OrderDate) OVER (
				PARTITION BY EmployeeID ORDER BY orderDate
				)) AS DayDifference
	FROM orders
	) AS t
GROUP BY EmployeeID

-- 3. employeninh ortalama kargo sipari� s�resini bul 
SELECT EmployeeID
	,avg(DATEDIFF(day, OrderDate, ShippedDate)) AS AverageOrderShipDifference
FROM orders
GROUP BY EmployeeID

-- 4. soru 2 deki sipair�in hangi g�n kargoya ��kaca��n� bul
SELECT t.EmployeeID
	,max(OrderDate) + avg(t.DayDifference) + avg(DATEDIFF(day, OrderDate, ShippedDate)) AS Guess
FROM (
	SELECT EmployeeID
		,OrderDate
		,ShippedDate
		,LEAD(OrderDate) OVER (
			PARTITION BY EmployeeID ORDER BY orderDate
			) AS DayLead
		,datediff(day, OrderDate, LEAD(OrderDate) OVER (
				PARTITION BY EmployeeID ORDER BY orderDate
				)) AS DayDifference
	FROM orders
	) AS t
GROUP BY EmployeeID

--  5. hangi �lkeye gidecek tahmini 
-- �al��anlar en �ok hangi �lkeye sat�� yap�yorlar
-- Sat�� miktar�na g�re
SELECT t2.EmployeeID
	,t2.country
	,t2.total
FROM (
	SELECT row_number() OVER (
			PARTITION BY t1.EmployeeID ORDER BY t1.Total DESC
			) AS RowNumber
		,total
		,t1.EmployeeID
		,t1.country
	FROM (
		SELECT sum(ord.UnitPrice * ord.Quantity) AS Total
			,o.shipcountry AS country
			,o.EmployeeID
		FROM [Order Details] ord
		LEFT JOIN orders o ON ord.OrderID = o.OrderID
		GROUP BY o.shipcountry
			,o.EmployeeID
		) t1
	) t2
WHERE RowNumber = 1;

-- Sipari� say�s�na g�re
SELECT t2.EmployeeID
	,t2.country
	,t2.total
FROM (
	SELECT row_number() OVER (
			PARTITION BY t1.EmployeeID ORDER BY t1.Total DESC
			) AS RowNumber
		,total
		,t1.EmployeeID
		,t1.country
	FROM (
		SELECT 
			count(o.OrderID) AS Total
			,o.shipcountry AS country
			,o.EmployeeID
		FROM orders o
		GROUP BY o.shipcountry
			,o.EmployeeID
		) t1
	) t2
WHERE RowNumber = 1;

-- Az select ile
SELECT t2.EmployeeID
	,t2.country
	,t2.total
FROM (
	SELECT row_number() OVER (
			PARTITION BY o.EmployeeID ORDER BY count(o.OrderID) DESC
			) AS RowNumber
		,o.EmployeeID
		,count(o.OrderID) as total
		,o.ShipCountry as country
	FROM orders o
	GROUP BY o.shipcountry ,o.EmployeeID
	) t2
WHERE RowNumber = 1;

-- 6. customerin bir sonraki sipari�inde verece�i productlar
-- Customer'�n en �ok sipari� verdi�i product?
-- Fiyata g�re
SELECT t2.CustomerID
	,t2.ProductID
FROM (
	SELECT t1.CustomerID
		,t1.ProductID
		,ROW_NUMBER() OVER (
			PARTITION BY t1.CustomerID ORDER BY t1.total
			) AS RowNumber
	FROM (
		SELECT o.CustomerID
			,od.ProductID
			,sum(od.UnitPrice * od.Quantity) AS Total
		FROM orders o
		INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
		GROUP BY o.CustomerID
			,od.ProductID
		) t1
	) t2
WHERE t2.RowNumber = 1

-- Adete g�re
SELECT t2.CustomerID
	,t2.ProductID
FROM (
	SELECT t1.CustomerID
		,t1.ProductID
		,ROW_NUMBER() OVER (
			PARTITION BY t1.CustomerID ORDER BY t1.total
			) AS RowNumber
	FROM (
		SELECT o.CustomerID
			,od.ProductID
			,sum(od.Quantity) AS Total
		FROM orders o
		INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
		GROUP BY o.CustomerID
			,od.ProductID
		) t1
	) t2
WHERE t2.RowNumber = 1

-- 7- customer �lke profili(ka� adet, ka� farkl� �r�n, ortalama �r�n adedi, sipari�teki genelde hangi
--		�r�n, hangi �lkeden hangi emplyee, yanlar�na %ler gelsin employee baz�nda)
--
-- A��klama: Her bir customer i�in:
--		- ka� adet �r�n sipari� etti�i, 
--		- ka� farkl� �r�n sipari� etti�i, 
--		- Bir sipari�inde ortalama olarak ka� adet �r�n sipari� etti�i, 
--		- En �ok hangi �r�n� sipari� etti�i,
--		- �r�nleri en �ok hangi �lkeden gelir
SELECT f1.CustomerID
	,t3.ProductID AS MostBuyedItemID
	,c1.Country AS WhereItsComeFrom
	,avg(f1.HowManyOrdered) AS ProductPerAverageOrder
	,sum(f1.HowManyOrdered) AS HowManyOrdered
	,count(f1.HowManyDistinctOrdered) AS HowManyDistinctOrdered
FROM (
	SELECT o.OrderID
		,o.CustomerID
		,sum(Quantity) AS HowManyOrdered
		,count(ProductID) AS HowManyDistinctOrdered
	FROM orders o
	INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
	GROUP BY o.OrderID
		,o.CustomerID
	) f1
INNER JOIN (
	SELECT t2.CustomerID
		,t2.ProductID
	FROM (
		SELECT t1.CustomerID
			,t1.ProductID
			,ROW_NUMBER() OVER (
				PARTITION BY t1.CustomerID ORDER BY t1.total
				) AS RowNumber
		FROM (
			SELECT o.CustomerID
				,od.ProductID
				,sum(od.UnitPrice * od.Quantity) AS Total
			FROM orders o
			INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
			GROUP BY o.CustomerID
				,od.ProductID
			) t1
		) t2
	WHERE t2.RowNumber = 1
	) t3 ON f1.CustomerID = t3.CustomerID
INNER JOIN (
	SELECT t2.Country
		,t2.CustomerID
	FROM (
		SELECT t1.Country
			,t1.CustomerID
			,ROW_NUMBER() OVER (
				PARTITION BY t1.CustomerId ORDER BY t1.Country
				) AS RowNumber
		FROM (
			SELECT s.Country
				,o.CustomerID
			FROM orders o
			INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
			INNER JOIN Products p ON od.ProductID = p.ProductID
			INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
			GROUP BY s.Country
				,o.CustomerID
			) t1
		) t2
	WHERE RowNumber = 1
	) c1 ON f1.CustomerID = c1.CustomerID
GROUP BY f1.CustomerID
	,t3.ProductID
	,c1.Country

-- Employee analizi yap. 1. sat�r, 1. sut�n bo� kals�n, ilk sut�nda employee isimleri, di�er
-- sut�nlarda employee'ye ait sat��, memleket, kar gibi m�mk�n olan t�m analizleri yap.

USE Northwind
GO

select * from [Order Details]
select * from orders

SELECT 
	e.EmployeeID, 
	SUM(od.UnitPrice * od.Quantity) AS TotalSale,
	COUNT(od.ProductID) AS TotalProductSale
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID
ORDER BY e.EmployeeID

SELECT 'TotalSale' AS TotalSaleSorted, [1], [2], [3], [4], [5], [6], [7], [8], [9]
FROM 
(
	SELECT 
		e.EmployeeID AS EmployeeID,
		od.UnitPrice AS UnitPrice, 
		od.Quantity AS Quantity, 
		od.ProductID AS ProductID
	FROM Orders o
	INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
	INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
) AS SourceTable
PIVOT
(
	SUM(UnitPrice)
	FOR EmployeeID IN ([1], [2], [3], [4], [5], [6], [7], [8], [9])
) AS PivotTable

select CategoryID, AVG(UnitPrice) AS AverageUnitPrice 
from Products
group by CategoryID


SELECT 'AverageUnitPrice' AS AverageUnitPriceSorted, [1], [2], [3], [4], [5], [6], [7], [8]
FROM
(
	SELECT UnitPrice, CategoryID
	FROM Products
) AS SourceTable
PIVOT
(
	AVG(UnitPrice)
	FOR CategoryID IN ([1], [2], [3], [4], [5], [6], [7], [8])
) AS PivotTable




