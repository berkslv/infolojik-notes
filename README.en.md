1. Print employee names and surnames side by side

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT Concat (firstname, ' ', lastname) AS FullName
  FROM Employees
  ```
</details>


2. Which ones are between 10 and 30 pieces?

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT ProductID, ProductName, UnitPrice
  FROM products
  WHERE unitprice BETWEEN 10 AND 30;
  ```
</details>


3. What are the products that have more than 50 stocks and have no stock, if any?

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


4. Who are the employees whose order shipping date is before 1.11.97 and after 23.09.97

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT EmployeeID,
        ShippedDate
  FROM orders
  WHERE ShippedDate BETWEEN '1997-09-23' AND '1997-11-01';
  ```
</details>


5. What are the employees whose title is 'Sales Representative' and what are their addresses

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


6. What is the number of employees whose birthdays are in March and April?

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT count(*) AS EmployeeCount
  FROM Employees
  WHERE datepart(MONTH, BirthDate) = 3
    OR datepart(MONTH, BirthDate) = 4;
  ```
</details>


7. Who are the people who started working when they were over 28 years old?

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT FirstName,
       datediff(YEAR, e.BirthDate, e.HireDate) AS AgeDifference
  FROM Employees e
  WHERE datediff(YEAR, e.BirthDate, e.HireDate) > 28;
  ```
</details>


8. Who are employees over 35 years old?

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT FirstName,
        datediff(YEAR, BirthDate, getdate()) AS Age
  FROM Employees
  WHERE datediff(YEAR, BirthDate, getdate()) > 35;
  ```
</details>


9. Who are the employees from Berlin - Germany or regions are not empty?

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT *
  FROM Customers
  WHERE city = 'Berlin'
    AND Region IS NOT NULL;
  ```
</details>


10. What is the total stock of products

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT sum(UnitsInStock)
  FROM Products;
  ```
</details>


11. How many products are there?

<details>
  <summary>SQL</summary>
  
  ```sql
  SELECT count(*) AS ProductCount
  FROM Products;
  ```
</details>


12. Product discount average

<details>
  <summary>SQL</summary>

  ```sql
  SELECT avg(Discount) AS AverageDiscount
  FROM [Order Details]
  ```
</details>


13. Total price of products with less than 20 stocks

<details>
  <summary>SQL</summary>

  ```sql
  SELECT sum(UnitPrice) AS SumOfProduct
  FROM Products
  WHERE UnitsInStock < 20;
  ```
</details>


14. Average price of products with stocks below 20

<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(*) AS CountOfProduct
  FROM products
  WHERE UnitsInStock < 20;
  ```
</details>


15. How many different contact titles are there?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(DISTINCT ContactTitle)
  FROM Customers;
  ```
</details>


16. What is the stock total of products that are not on sale?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT sum(UnitsInStock)
  FROM Products
  WHERE Discontinued = 1
  ```
</details>


17. What is the sum of the past discounts to customers who purchased products that are not on sale?

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


18. What is the non-discounted fee for each order?

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


19. What is the total discount for each order?

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


20. What is the price of the order before and after the discount?

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

21. In how many days are orders shipped?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT o.OrderID,
        datediff(DAY, OrderDate, ShippedDate) AS DayToShipAfterOrder
  FROM orders o;
  ```
</details>


22. Group shipping times by day

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


23. Order quantity without shipregion RJ and CA

<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(*)
  FROM orders
  WHERE ShipRegion NOT IN ('RJ','CA');
  ```
</details>


24. Sales total of sellers whose names start with A

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


25. What are the first digits of the fax number greater than 8?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT *
  FROM customers
  WHERE left(Fax, 1) > '8'
  ```
</details>


26. What is the average discount for orders with more than 30 days between the order date and the shipping date?

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


27. What are the total and average sales of employees

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


28. Who are the top selling employees?

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



29. Monthly number of products with more than 7 days between order and shipping

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


30. What are the products with more than 7 days between order and shipping?

<details>
  <summary>SQL</summary>

  ```sql
  SELECT count(DISTINCT od.ProductID)
  FROM orders o
  INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
  WHERE datediff(day, OrderDate, ShippedDate) > 7
  ```
</details>


31. How many products ships to the outside the country of supply?
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

32. What is the average shipping order time of employees

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

33. Print category names side by side, separated by commas.

<details>
  <summary>SQL</summary>

  ```sql
  SELECT STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(CategoryName, 'N/A')), ', ')
  FROM Categories
  ```
</details>



34. What is the average time until the employee's next order?

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


35. Next order forecast date based on Employee

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


36. What is the average shipping time for an employee after receiving an order?

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


37. When will the next order estimate ship date based on Employee?

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


38. Which country will the next order go to, based on the estimated sales amount?

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



38. Which country will the next order go to, based on the estimated number of orders?

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

  - Less subquery

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

39. What product will the customer order in their next order, based on the price estimate.

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

40. What product will the customer order in their next order, based on the quantity.

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


41. Do customer analysis. In this analysis, show the total number of products ordered by the customer, the number of individual products ordered by the customer, the average number of products ordered in an order, which product he ordered the most, and from which country the products he ordered most came from?

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


