1. Çalışan isim ve soyisimlerini yan yana yazdır

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT Concat (firstname, ' ', lastname) AS FullName
  FROM Employees
  ```
</details>

<details>
  <summary>Table</summary>
  
  | FullName         |
  |------------------|
  | Nancy Davolio    |
  | Andrew Fuller    |
  | Janet Leverling  |
  | ...              |
</details>

2. Adet fiyatı 10 ile 30 arasında olanları getir.

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT ProductID, ProductName, UnitPrice
  FROM products
  WHERE unitprice BETWEEN 10 AND 30;
  ```
</details>

<details>
  <summary>Results</summary>
  
  | ProductID | ProductName   | UnitPrice |
  | --------- | ------------- | --------- |
  | 1         | Chai          | 18,00     |
  | 2         | Chang         | 19,00     |
  | 3         | Aniseed Syrup | 10,00     |
  | ...       | ...           | ...       |
</details>

3. Stok adeti 50 nin üstünde olan ve varsa stoğu olmayan ürünleri getir.

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT ProductID,
      ProductName,
      UnitsInStock
  FROM Products
  WHERE UnitsInStock > 50
  OR UnitsInStock = 0;
  ```
</details>

<details>
  <summary>Results</summary>

| ProductID | ProductName                  | UnitsInStock |
| --------- | ---------------------------- | ------------ |
| 4         | Chef Anton's Cajun Seasoning | 53           |
| 5         | Chef Anton's Gumbo Mix       | 0            |
| 6         | Grandma's Boysenberry Spread | 120          |
| ...       | ...                          | ...          |

</details>

4. Sipariş kargolanma tarihi 1.11.97 öncesinde ve 23.09.97 tarihinden sonrasında olan çalışanlar

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT EmployeeID,
        ShippedDate
  FROM orders
  WHERE ShippedDate BETWEEN '1997-09-23' AND '1997-11-01';
  ```
</details>

<details>
  <summary>Results</summary>

| EmployeeID | ShippedDate             |
| ---------- | ----------------------- |
| 8          | 1997-10-15 00:00:00.000 |
| 2          | 1997-10-03 00:00:00.000 |
| 1          | 1997-09-23 00:00:00.000 |
| ...        | ...                     |

</details>

5. Title'laro 'Sales Representative' olan çalışanlar ve adresleri

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT EmployeeID,
        Title,
        Address
  FROM Employees
  WHERE Title = 'Sales Representative';
  ```
</details>

<details>
  <summary>Results</summary>

| EmployeeID | Title                | Address                    |
| ---------- | -------------------- | -------------------------- |
| 1          | Sales Representative | 507 - 20th Ave. E. Apt. 2A |
| 3          | Sales Representative | 722 Moss Bay Blvd.         |
| 4          | Sales Representative | 4110 Old Redmond Rd.       |
| ...        | ...                  | ...                        |

</details>

6. Doğum günü mart ve nisan olanların sayısı

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT count(*) AS EmployeeCount
  FROM Employees
  WHERE datepart(MONTH, BirthDate) = 3
    OR datepart(MONTH, BirthDate) = 4;
  ```
</details>

<details>
  <summary>Results</summary>

| EmployeeCount |
| ------------- |
| 1             |

</details>

7. 28 yaşından büyük iken işe giren kişiler

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT FirstName,
       datediff(YEAR, e.BirthDate, e.HireDate) AS AgeDifference
  FROM Employees e
  WHERE datediff(YEAR, e.BirthDate, e.HireDate) > 28;
  ```
</details>

8. 35 yaşından büyük olan çalışanlar

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT FirstName,
        datediff(YEAR, BirthDate, getdate()) AS Age
  FROM Employees
  WHERE datediff(YEAR, BirthDate, getdate()) > 35;
  ```
</details>

9. Almanya Berlinden olan ve regionları boş olmayan çalışanlar?

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT *
  FROM Customers
  WHERE city = 'Berlin'
    AND Region IS NOT NULL;
  ```
</details>

10. Toplam ürün stoğu

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT sum(UnitsInStock)
  FROM Products;
  ```
</details>

11. Kaç adet ürün var?

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT count(*) AS ProductCount
  FROM Products;
  ```
</details>

12. Ürün indirim ortalaması

<details>
  <summary>SQL</summary>

  ```sql
  SELECT avg(Discount) AS AverageDiscount
  FROM [Order Details]
  ```
</details>

SELECT \*
FROM products

13. Stokları 20 altında olan ürünlerin toplam fiyatı

<details>
  <summary>SQL</summary>

  ```sql
  SELECT sum(UnitPrice) AS SumOfProduct
  FROM Products
  WHERE UnitsInStock < 20;
  ```
</details>

14. stokları 20 altında olan ürünlerin fiyat ortalaması

<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(*) AS CountOfProduct
  FROM products
  WHERE UnitsInStock < 20;
  ```
</details>


15. Kaç adet farklı contact title var

<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(DISTINCT ContactTitle)
  FROM Customers;
  ```
</details>


16. Satışta olmayan ürünlerin stok toplamı 

<details>
  <summary>SQL</summary>

  ```sql
  SELECT sum(UnitsInStock)
  FROM Products
  WHERE Discontinued = 1
  ```
</details>


17. Satışta olmayan ürünleri satın alan müşterilere geçmişte yapılan indirim toplamı nedir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT sum(Discount)
  FROM [Order Details]
  WHERE ProductID IN
      (
        SELECT ProductID
        FROM products
        WHERE Discontinued = 1 
      )
  ```
</details>


18. Her bir sipariş için indirimsiz ödenen ücret nedir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT  o.OrderID,
    sum(OD.Quantity * OD.UnitPrice) AS Price
  FROM [Order Details] od
  INNER JOIN Orders o ON od.OrderID = o.OrderID
  GROUP BY o.OrderID
  ```
</details>


19. Her sipariş için yapılan indirim toplamı?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT sum(od.Discount * p.UnitPrice) AS Discount,
       o.OrderID
  FROM [Order Details] od
  LEFT JOIN Orders o ON od.OrderID = o.OrderID
  LEFT JOIN Products p ON od.ProductID = p.ProductID
  WHERE od.Discount != 0
  GROUP BY o.OrderID
  HAVING sum(od.Discount * p.UnitPrice) > 5
  ```
</details>


20. Siparişin indirim öncesi ve indirim sonrası ödenen ücreti 

<details>
  <summary>SQL</summary>

  ```sql
  SELECT sum(od.Quantity * p.UnitPrice) AS BeforeDiscount,
        sum((od.Quantity * p.UnitPrice) - (od.Discount * p.UnitPrice * od.Quantity)) AS AfterDiscount,
        o.OrderID
  FROM [Order Details] od
  INNER JOIN Products p ON od.ProductID = p.ProductID
  INNER JOIN Orders o ON od.OrderID = o.OrderID
  WHERE od.Discount != 0
  GROUP BY o.OrderID
  ```
</details>

21. Siparişler kaç günde gitmiş?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT o.OrderID,
        datediff(DAY, OrderDate, ShippedDate) AS DayToShipAfterOrder
  FROM orders o;
  ```
</details>


22. Kargolama sürelerini güne göre grupla

<details>
  <summary>SQL</summary>

  ```sql
  SELECT datediff(DAY, OrderDate, ShippedDate) AS DayToShipAfterOrder,
        count(o.OrderID)
  FROM orders o
  WHERE datediff(DAY, OrderDate, ShippedDate) IS NOT NULL
  GROUP BY datediff(DAY, OrderDate, ShippedDate)
  ```
</details>


23. shipregion'u RJ ve CA olmayan sipariş adedi


<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(*)
  FROM orders
  WHERE ShipRegion NOT IN ('RJ','CA');
  ```
</details>


24. İsmi A ile başlayan satıcıların satış toplamı

<details>
  <summary>SQL</summary>

  ```sql
  SELECT sum(od.UnitPrice * od.Quantity) AS TotalSale
  FROM Orders o
  LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
  LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
  WHERE e.FirstName LIKE 'A%'
  ```
</details>


25. Fax numarasının ilk basamağı 8 den büyük olanlar nelerdir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT *
  FROM customers
  WHERE left(Fax, 1) > '8'
  ```
</details>


26. Sipariş tarihi ile Kargolama tarihi arasında 30 günden fazla olan siparişlere ortalama ne kadar indirim yapıldı?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT o.OrderID, 
    avg(od.UnitPrice * od.Discount) AS averageDiscount       
  FROM Orders o
  INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
  WHERE DATEDIFF(DAY, OrderDate, ShippedDate) > 30
  GROUP BY o.OrderID
  ```
</details>

27. Çalışanların toplam ve ortalama satışları nedir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT e.EmployeeID,
        avg(od.Quantity _ od.UnitPrice) AS averageSale,
        sum(od.Quantity _ od.UnitPrice) AS totalSale
  FROM orders o
  LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
  LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
  GROUP BY e.EmployeeID
  ```
</details>


28. En çok ürün satan çalışanlar kimlerdir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT e.EmployeeID,
        od.Quantity
  FROM orders o
  LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
  LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
  GROUP BY e.EmployeeID,
          od.Quantity
  ORDER BY od.Quantity DESC
  ```
</details>



29. Sipariş ve kargolanma arasında 7 günden fazla olan ürünlerin ay bazında adetleri

<details>
  <summary>SQL</summary>

  ```sql
  SELECT DATEPART(MONTH, OrderDate) AS months,
        count(*) AS total
  FROM orders
  WHERE DATEDIFF(DAY, OrderDate, ShippedDate) > 7
  GROUP BY DATEPART(MONTH, OrderDate)
  ```
</details>


30. Sipariş ve kargolama tarihleri arasında 7 günden fazla olan ürünlerin adeti nedir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(DISTINCT od.ProductID)
  FROM orders o
  INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
  WHERE datediff(day, OrderDate, ShippedDate) > 7
  ```
</details>


31. kaç adet ürün tedarik edildiği ülke dışına gidiyor?
<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(*)
  FROM orders o
  INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
  INNER JOIN Products p ON od.ProductID = p.ProductID
  INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
  WHERE s.Country != o.ShipCity
  ```
</details>

32. Çalışanların ortalama kargo sipariş süresi nedir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT e.EmployeeID
  ,avg(datediff(day, OrderDate, ShippedDate)) AS average
  FROM orders o
  INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
  GROUP BY e.EmployeeID
  ```
</details>

33. Kategori isimlerini virgülle ayırarak yan yana yazdır.

<details>
  <summary>SQL</summary>

  ```sql
  SELECT STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(CategoryName, 'N/A')), ', ')
  FROM Categories
  ```
</details>



34. Çalışanın bir sonraki siparişine kadar geçen süre ortalaması nedir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    t.EmployeeID, 
    avg(t.DayDiff) AS AvgDayDiff 
  FROM 
    (
      SELECT 
        EmployeeID, 
        orderDate, 
        datediff(
          day, 
          OrderDate, 
          LEAD(OrderDate) OVER (
            PARTITION BY EmployeeID ORDER BY OrderDate
          )
        ) AS DayDiff 
      FROM orders
    ) AS t 
  GROUP BY EmployeeID
  ```
</details>


35. Employee bazında sonraki sipariş tahmini tarihi

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    t.EmployeeID, 
    max(OrderDate) + avg(t.DayDifference) AS Guess 
  FROM 
    (
      SELECT 
        EmployeeID, 
        OrderDate, 
        datediff(
          day, 
          OrderDate, 
          LEAD(OrderDate) OVER (
            PARTITION BY EmployeeID ORDER BY OrderDate
          )
        ) AS DayDifference 
      FROM Orders
    ) AS t 
  GROUP BY EmployeeID
  ```
</details>


36. Çalışanın sipariş aldıktan sonra ortalama kargolama süresi nedir

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    EmployeeID, 
    avg(
      DATEDIFF(day, OrderDate, ShippedDate)
    ) AS AverageOrderShipDifference 
  FROM Orders 
  GROUP BY EmployeeID
  ```
</details>


37. Employee bazında sonraki sipariş tahmini tarihi ne zaman kargoya çıkacaktır?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    t.EmployeeID, 
    max(OrderDate) + avg(t.DayDifference) + avg(
      datediff(day, OrderDate, ShippedDate)
    ) AS Guess 
  FROM (
      SELECT 
        EmployeeID, 
        OrderDate, 
        ShippedDate, 
        datediff(
          day, 
          OrderDate, 
          lead(OrderDate) OVER (
            PARTITION BY EmployeeID ORDER BY OrderDate
          )
        ) AS DayDifference 
      FROM Orders
    ) AS t 
  GROUP BY EmployeeID
  ```
</details>


38. Bir sonraki sipariş, satış miktarına göre tahmini olarak hangi ülkeye gidecek

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    t2.EmployeeID, 
    t2.country, 
    t2.total 
  FROM 
    (
      SELECT 
        row_number() OVER (
          PARTITION BY t1.EmployeeID 
          ORDER BY t1.Total DESC
        ) AS RowNumber, 
        total, 
        t1.EmployeeID, 
        t1.country 
      FROM (
          SELECT 
            sum(od.UnitPrice * od.Quantity) AS Total, 
            o.shipcountry AS country, 
            o.EmployeeID 
          FROM [Order Details] od 
          LEFT JOIN orders o ON od.OrderID = o.OrderID 
          GROUP BY 
            o.shipcountry, 
            o.EmployeeID
        ) t1
    ) t2 
  WHERE RowNumber = 1;
  ```
</details>



38. Bir sonraki sipariş, sipariş sayısına göre tahmini olarak hangi ülkeye gidecek

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    EmployeeID, 
    Country, 
    Total 
  FROM 
    (
      SELECT 
        row_number() OVER (
          PARTITION BY t1.EmployeeID ORDER BY t1.Total DESC
        ) AS RowNumber, 
        Total, 
        EmployeeID, 
        Country 
      FROM 
        (
          SELECT 
            count(o.OrderID) AS Total, 
            o.shipcountry AS Country, 
            o.EmployeeID 
          FROM orders o 
          GROUP BY 
            o.shipcountry, 
            o.EmployeeID
        ) t1
    ) t2 
  WHERE RowNumber = 1;
  ```

  - Daha az select ile

  ```sql
  SELECT 
    EmployeeID, 
    Country, 
    Total 
  FROM 
    (
      SELECT 
        row_number() OVER (
          PARTITION BY o.EmployeeID ORDER BY count(o.OrderID) DESC
        ) AS RowNumber, 
        o.EmployeeID, 
        count(o.OrderID) as total, 
        o.ShipCountry as country 
      FROM orders o 
      GROUP BY 
        o.shipcountry, 
        o.EmployeeID
    ) t 
  WHERE RowNumber = 1;
  ```
</details>

39. Müşteri bir sonraki siparişinde, fiyata göre tahmini olarak hangi ürünü sipariş edecektir.

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    t2.CustomerID, 
    t2.ProductID 
  FROM 
    (
      SELECT 
        t1.CustomerID, 
        t1.ProductID, 
        ROW_NUMBER() OVER (
          PARTITION BY t1.CustomerID ORDER BY  t1.total
        ) AS RowNumber 
      FROM 
        (
          SELECT 
            o.CustomerID, 
            od.ProductID, 
            sum(od.UnitPrice  * od.Quantity) AS Total 
          FROM 
            orders o 
            INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
          GROUP BY 
            o.CustomerID, 
            od.ProductID
        ) t1
    ) t2 
  WHERE t2.RowNumber = 1
  ```
</details>

40. Müşteri bir sonraki siparişinde, adete göre tahmini olarak hangi ürünü sipariş edecektir.

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    t2.CustomerID, 
    t2.ProductID 
  FROM 
    (
      SELECT 
        t1.CustomerID, 
        t1.ProductID, 
        ROW_NUMBER() OVER (
          PARTITION BY t1.CustomerID ORDER BY t1.total
        ) AS RowNumber 
      FROM 
        (
          SELECT 
            o.CustomerID, 
            od.ProductID, 
            sum(od.Quantity) AS Total 
          FROM 
            orders o 
            INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
          GROUP BY 
            o.CustomerID, 
            od.ProductID
        ) t1
    ) t2 
  WHERE t2.RowNumber = 1

  ```
</details>


41. Müşteri analizi yapınız. Bu analizde müşterinin sipariş ettiği toplam ürün sayısı, müşterinin sipariş ettiği tekil ürün sayısı, bir siparişinde ortalama kaç adet ürün sipariş ettiği, en çok hangi ürünü sipariş ettiği, sipariş ettiği ürünlerin en çok hangi ülkeden geldiğini gösteriniz.

<details>
  <summary>SQL</summary>

  ```sql
  SELECT 
    f1.CustomerID, 
    t3.ProductID AS MostBuyedItemID, 
    c1.Country AS WhereItsComeFrom, 
    avg(f1.HowManyOrdered) AS ProductPerAverageOrder, 
    sum(f1.HowManyOrdered) AS HowManyOrdered, 
    count(f1.HowManyDistinctOrdered) AS HowManyDistinctOrdered 
  FROM 
    (
      SELECT 
        o.OrderID, 
        o.CustomerID, 
        sum(Quantity) AS HowManyOrdered, 
        count(ProductID) AS HowManyDistinctOrdered 
      FROM 
        orders o 
        INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
      GROUP BY 
        o.OrderID, 
        o.CustomerID
    ) f1 
    INNER JOIN (
      SELECT 
        t2.CustomerID, 
        t2.ProductID 
      FROM 
        (
          SELECT 
            t1.CustomerID, 
            t1.ProductID, 
            ROW_NUMBER() OVER (
              PARTITION BY t1.CustomerID ORDER BY t1.total
            ) AS RowNumber 
          FROM 
            (
              SELECT 
                o.CustomerID, 
                od.ProductID, 
                sum(od.UnitPrice * od.Quantity) AS Total 
              FROM 
                orders o 
                INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
              GROUP BY 
                o.CustomerID, 
                od.ProductID
            ) t1
        ) t2 
      WHERE 
        t2.RowNumber = 1
    ) t3 ON f1.CustomerID = t3.CustomerID 
    INNER JOIN (
      SELECT 
        t2.Country, 
        t2.CustomerID 
      FROM 
        (
          SELECT 
            t1.Country, 
            t1.CustomerID, 
            ROW_NUMBER() OVER (
              PARTITION BY t1.CustomerId ORDER BY t1.Country
            ) AS RowNumber 
          FROM 
            (
              SELECT 
                s.Country, 
                o.CustomerID 
              FROM 
                orders o 
                INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
                INNER JOIN Products p ON od.ProductID = p.ProductID 
                INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID 
              GROUP BY 
                s.Country, 
                o.CustomerID
            ) t1
        ) t2 
      WHERE 
        RowNumber = 1
    ) c1 ON f1.CustomerID = c1.CustomerID 
  GROUP BY 
    f1.CustomerID, 
    t3.ProductID, 
    c1.Country
  ```
</details>


