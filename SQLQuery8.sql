

-- use Northwind
-- 1. isim ve soyisimleri yanyana yazdýralým. -employee
SELECT CONCAT (
		FirstName
		,' '
		,LastName
		) AS FullName
FROM Employees

-- 2. unitprice 100 üzerinde olanlar, altýnda olanlar ve 10-30 arasýnda olanlar --sütun isimleri verilerek.
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

-- 3. stok 20 altýnda ve üstünde olanlar ayrý ayrý ve 10-30 arasýnda olan var mý? stok olmayan var mý?
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

-- 4. shipped date 1.11.97 öncesinde olan sipariþ idleri (tarihler beraber) ve shipped dateleri 23.09.97'den büyük olanlarýn employeeidleri?
SELECT EmployeeID
FROM orders
WHERE ShippedDate BETWEEN '1997-09-23'
		AND '1997-11-01';

-- 5. title'larý 'sales rep.' olanlarýn adresleri ve idleri?
SELECT *
FROM Employees
WHERE Title = 'Sales Representative';

-- 6. doðum günü mart ve nisanda olanlarýn sayýsý?
SELECT count(*)
FROM Employees
WHERE datepart(month, BirthDate) = 3
	OR datepart(month, BirthDate) = 4;

-- 7. 28 yaþýndan büyük iþe girenler kimler?
SELECT datediff(Year, e.BirthDate, e.HireDate) AS ageDifference
	,CONCAT (
		FirstName
		,'-'
		,upper(e.LastName)
		) AS FullName
FROM Employees e
WHERE datediff(Year, e.BirthDate, e.HireDate) > 28;

-- 8. þu an 35 yaþýndan büyük olanlar kimler?
SELECT datediff(year, BirthDate, getdate()) AS age
	,FirstName
	,LastName
FROM Employees
WHERE datediff(year, BirthDate, getdate()) > 35;

-- 9. company name Q ile baþlayanlar?, do geçenler ve içinde hiç a olmayanlar
-- regex ile çözülür.
-- 10. almanyanýn berlinden olanlar, USA olanlarýn regionlarý, regionlarý boþ olmayanlar?
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

-- 2. Kaç adet ürün var?
SELECT count(*) AS cnt
FROM Products;

-- 3. Ürün indirim ortalamasý
SELECT DISTINCT avg(OD.Discount)
FROM [Order Details] AS OD;

SELECT *
FROM products

-- 4. stoklarý 20 altýnda olan productlarýn toplamý 
SELECT sum(UnitPrice)
FROM products
WHERE UnitsInStock < 20;

-- 5. stoklarý 20 altýnda olan productlarýn ortalamasý
SELECT count(*)
FROM products
WHERE UnitsInStock < 20;

-- 6. Kaç adet farklý contact title var*
SELECT count(DISTINCT ContactTitle)
FROM Customers;

-- 7 DISCONTINUED Yes (Y) olanlarýn stok toplamý 
SELECT sum(UnitsInStock)
FROM products
WHERE Discontinued = 1

-- 7.1 DISCONTINUED Yes (Y) olanlarýn order detail tablosunda yapýlan indirimlerinin ortalamasý
SELECT avg(Discount)
FROM [Order Details]
WHERE ProductID IN (
		SELECT ProductID
		FROM products
		WHERE Discontinued = 1
		)

-- 8 bir sipariþ için ödenen ücret?
SELECT sum(OD.Quantity * OD.UnitPrice) AS price
	,O.OrderID
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
GROUP BY O.OrderID

SELECT *
FROM [Order Details]

-- 9 Her sipariþ için yapýlan indirim toplamý?
SELECT sum(OD.Discount * P.UnitPrice) AS discount
	,O.OrderID
FROM [Order Details] AS OD
LEFT JOIN Orders AS O ON OD.OrderID = O.OrderID
LEFT JOIN Products AS P ON OD.ProductID = P.ProductID
WHERE OD.Discount != 0
GROUP BY O.OrderID
HAVING sum(OD.Discount * P.UnitPrice) > 5

-- 10 Sipariþin indirim öncesi ve indirim sonrasý ödenen ücreti 
SELECT sum(OD.Quantity * P.UnitPrice) AS beforeDiscount
	,sum((OD.Quantity * P.UnitPrice) - (OD.Discount * P.UnitPrice)) AS afterDiscount
	,O.OrderID
FROM [Order Details] AS OD
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE OD.Discount != 0
GROUP BY O.OrderID

-- 11. Sipariþte indirim yüzde ne kadar etkilemiþ
SELECT *
FROM [Order Details]

-- 12. Sipariþler kaç günde gitmiþ?
SELECT o.OrderID
	,datediff(day, OrderDate, ShippedDate) AS DayToShipAfterOrder
FROM orders o;

-- 10. kargolama süreleri güne göre gruplama
SELECT datediff(day, OrderDate, ShippedDate) AS DayToShipAfterOrder
	,count(o.OrderID)
FROM orders o
WHERE datediff(day, OrderDate, ShippedDate) IS NOT NULL
GROUP BY datediff(day, OrderDate, ShippedDate)

-- having datediff(day, OrderDate, ShippedDate) is not null;
-- aggregate fonksiyonlarýný þartlý ifade içersinde kullanmak istersen having ile yapmalýsýn.
-- shipregion'u RJ ve CA olmayan sipariþlerin Adedi
SELECT count(*)
FROM orders
WHERE ShipRegion NOT IN (
		'RJ'
		,'CA'
		);

-- ismi A ile baþlayanlarýn satýþ toplamý ve parasý
-- Ýsmi A ile baþlayan çalýþanlarýn toplam satýþlarý
SELECT sum(od.UnitPrice * od.Quantity) AS totalSale
FROM Orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE e.FirstName LIKE 'A%'

-- fax numarasý 8den büyük olanlarý getir
SELECT *
FROM customers
WHERE left(Fax, 1) > '8'

-- DESCRIPTIONLARI VÝRGÜLE GÖRE AYIRARAK KATEGORÝ ÝSÝMLERÝNÝ KARÞISINA GETÝR
-- String split çalýþmýyor.
-- order_Date ile shipped_date arasýnda 30 günden fazla olan sipariþlere ortalama ne kadar indirim yapýldý?
SELECT avg(od.UnitPrice * od.Discount) AS averageDiscount
	,o.OrderID
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 30
GROUP BY o.OrderID

-- employee bazýnda tüm satýþlar analizi 
SELECT e.EmployeeID
	,avg(od.Quantity * od.UnitPrice) AS averageSale
	,sum(od.Quantity * od.UnitPrice) AS totalSale
FROM orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID

-- order bazýnda en çok quantitysi olanlar
SELECT e.EmployeeID
	,od.Quantity
FROM orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID
	,od.Quantity
ORDER BY od.Quantity

-- sipariþ ve kargolanma arasýnda 7 günden fazla olan ürünlerin aylýk adet görüntüsü
SELECT DATEPART(MONTH, OrderDate) AS months
	,count(*) AS total
FROM orders
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 7
GROUP BY DATEPART(MONTH, OrderDate)

-- toplam 7 günden fazla olan ürün adetlerinin adedi
SELECT COUNT(DISTINCT od.ProductID)
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 7

-- kaç adet ürün supply olduðu ülke dýþýna gidiyor?
SELECT count(*)
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.Country != o.ShipCity

-- employenin ortalama kargo sipariþ süresini bul
SELECT e.EmployeeID
	,avg(datediff(day, OrderDate, ShippedDate)) AS average
FROM orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID

-- categori isimlerini yan yana yazdýr.
SELECT STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(CategoryName, 'N/A')), ',')
	,CHAR(13)
FROM Categories

-- çalýþanlara göre sattýklarý ürünler, kaç adet satmýþ ve parasý
SELECT o.EmployeeID
	,count(od.ProductID) AS sellCount
	,sum(od.Quantity * od.UnitPrice) AS sellSum
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.EmployeeID

-- ismi A ile baþlayanlarýn satýþ toplamý ve parasý
SELECT o.EmployeeID
	,count(od.ProductID) AS sellCount
	,sum(od.Quantity * od.UnitPrice) AS sellSum
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.FirstName LIKE 'A%'
GROUP BY o.EmployeeID

-- order_Date ile shipped_date arasýnda 30 günden fazla olan sipariþlere ortalama ne kadar indirim yapýldý?
SELECT o.OrderID
	,avg((od.Quantity * od.UnitPrice) - (od.UnitPrice * od.Discount)) AS averageDiscount
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 30
GROUP BY o.OrderID

-- tüm indirim toplamý
SELECT sum(od.UnitPrice * od.Discount) AS totalDiscount
FROM orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID

-- 1. employeenin bir sonraki sipariþne kadar geçen süre ortalamasý
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

-- 2. employee bazýnda sonraki sipariþ tahmini tarihi
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

-- 3. employeninh ortalama kargo sipariþ süresini bul 
SELECT EmployeeID
	,avg(DATEDIFF(day, OrderDate, ShippedDate)) AS AverageOrderShipDifference
FROM orders
GROUP BY EmployeeID

-- 4. soru 2 deki sipairþin hangi gün kargoya çýkacaðýný bul
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

--  5. hangi ülkeye gidecek tahmini 
-- Çalýþanlar en çok hangi ülkeye satýþ yapýyorlar
-- Satýþ miktarýna göre
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

-- Sipariþ sayýsýna göre
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

-- 6. customerin bir sonraki sipariþinde vereceði productlar
-- Customer'ýn en çok sipariþ verdiði product?
-- Fiyata göre
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

-- Adete göre
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

-- 7- customer ülke profili(kaç adet, kaç farklý ürün, ortalama ürün adedi, sipariþteki genelde hangi
--		ürün, hangi ülkeden hangi emplyee, yanlarýna %ler gelsin employee bazýnda)
--
-- Açýklama: Her bir customer için:
--		- kaç adet ürün sipariþ ettiði, 
--		- kaç farklý ürün sipariþ ettiði, 
--		- Bir sipariþinde ortalama olarak kaç adet ürün sipariþ ettiði, 
--		- En çok hangi ürünü sipariþ ettiði,
--		- Ürünleri en çok hangi ülkeden gelir
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

