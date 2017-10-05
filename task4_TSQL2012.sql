use TSQL2012;
--task 1
GO
SELECT 
orderid,
orderdate,
custid,
empid
FROM Sales.Orders
WHERE orderdate in (select max(O.orderdate) orderdate
from Sales.Orders as O)

-- task 2 (deeping)

GO
SELECT 
custid,
orderid,
orderdate,
empid
FROM Sales.Orders
WHERE custid IN 
(select TOP(1) O.custid

from Sales.Orders as O
GROUP BY O.custid
ORDER BY COUNT(*) DESC)

--task 3
select
empid,
firstname,
lastname
from HR.Employees 
where empid  not in
(select 
o.empid
from  Sales.Orders as o
where o.orderdate >= '20080501')

--task 4

select
distinct country
from Sales.Customers
where country not in 
(select
country
from HR.Employees )

--task 5
-- 1 solution
select 
c.custid,
c.orderid,
c.orderdate,
c.empid
from Sales.Orders as c
where orderid in
(select 
max(o.orderid) as orderid
from Sales.Orders o
--where o.custid = c.custid
group by custid
)
order by c.custid

-- 2 solution

select 
c.custid,
c.orderid,
c.orderdate,
c.empid
from Sales.Orders as c
where orderdate =
(select 
max(o.orderdate) as orderdate
from Sales.Orders o
where o.custid = c.custid
--group by custid
)
order by c.custid

-- task 6 
-- 1 solution

select 
custid,companyname
from Sales.Customers
where custid in
(select
distinct(custid)
from Sales.Orders
where orderdate>= '20070101' and orderdate < '20080101' )
and custid not in 
(select
distinct(custid)
from Sales.Orders
where orderdate>= '20080101' and orderdate < '20090101' )

-- 2 solution

select 
c.custid , c.companyname
from Sales.Customers as c
where exists
(select
*
from Sales.Orders as o
where o.custid = c.custid and
 o.orderdate>= '20070101' and o.orderdate < '20080101' )
and  not exists
(select
*
from Sales.Orders as o
where  o.custid = c.custid and
o.orderdate>= '20080101' and o.orderdate < '20090101' )