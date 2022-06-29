-- use Northwind;

/*
	select * from Customers where PostalCode = 12209 and city = 'Berlin'
*/

/*
	select top 1 * from Customers order by PostalCode desc
*/

/*
	select top 30 * from Customers where PostalCode in('05021','WA1 1DP')
*/

/*
	select top 30 * from Customers where CompanyName like '%An%'
*/

/*
	select distinct top 10  * from Customers order by City desc
*/

/*
	insert into customers values ('ALFTI',	'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin', NULL,	'12209', 'Germany',	'030-0074321', '030-0076545')
*/


/*
	select count(distinct PostalCode) from Customers
	select count( PostalCode) from Customers
*/

/*
	select top 30
		ProductName as name, 
		UnitPrice as price, 
		UnitPrice * 2 as doublePrice 
	from Products where UnitPrice < 10
*/

-- select * from orders;

/*
	select Orders.OrderID, Customers.CustomerID, Customers.ContactName, Orders.OrderDate, Orders.ShipVia, Orders.OrderDate
	from orders 
	inner join 
		customers on orders.CustomerID = Customers.CustomerID 
		where ShipVia = 2 and OrderDate < '1999' and OrderDate > '1998';
*/

/*
	select floor(21.4) as '21'
*/

/*
	select top 30 
		Left(ShipName, 3) as ThreeLeft, 
		Right(ShipName, 3) as ThreeLeft,
		Upper(Left(ShipName, 3)) as ThreeLeftUpper,
		len(Shipname) as ShipNameLen
	from orders
*/

/*
	select top 30 
		Left(ShipName, 3) as ThreeLeft, 
		replace(Left(ShipName, 3), 'Vin', 'Niv')
	from orders
*/

/*
	select floor(avg(UnitPrice)) from Products
*/

/*
	select datepart(Month, GETDATE()) as month, datepart(year, GETDATE()) as year, datepart(QUARTER, getdate()) as quarter
*/

/*
	select 
		datediff(day, '2000', '2022') as myDay, 
		datediff(month, '2000-09-19','2022-06-27') as genel, 
		datediff(day, '2000-09-19',getdate()) as genelgetdate,
		dateadd(day,10,getdate()) as added
*/


select * from orders
group by ShipCountry