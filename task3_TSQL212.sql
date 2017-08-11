use TSQL2012;

SELECT HR.empid, HR.firstname, HR.lastname, n FROM HR.Employees HR
cross join dbo.Nums N
Where n <= 5 and HR.empid < 10


GO -- 1-2

SELECT  HR.empid, DATEADD(day, N.n-1, '20090612' )  dt FROM HR.Employees HR
cross join dbo.Nums N
WHERE N.n <=  DATEDIFF(day, '20090612','20090616') +1
order by HR.empid, dt


GO --2
-- 1 variant
SELECT A.custid, count(orderid), sum (qty)
FROM (SELECT  O.custid custid , O.orderid orderid , sum(OD.qty) qty
FROM Sales.OrderDetails  as OD
join Sales.Orders as O
ON O.orderid = OD.orderid
 join Sales.Customers as C
on C.custid = O.custid
WHERE  C.country = 'usa'
GROUP BY  O.custid, O.orderid )  A
GROUP BY  A.custid


-- 2 variant

SELECT  O.custid custid , count(distinct O.orderid) orderid , sum(OD.qty) qty
FROM Sales.OrderDetails  as OD
join Sales.Orders as O
ON O.orderid = OD.orderid
 join Sales.Customers as C
on C.custid = O.custid
WHERE  C.country = 'usa'
GROUP BY  O.custid


GO --3
SELECT C.custid, C.companyname, O.orderid, O.orderdate FROM Sales.Customers as C
left join  Sales.Orders O
on C.custid  = O.custid


GO --4
SELECT C.custid, C.companyname FROM Sales.Customers as C
left join Sales.Orders as O
ON C.custid = O.custid
Where O.orderid  is null
 

GO -- 6

SELECT C.Custid, C.companyname, o.orderid, O.orderdate 
FROM Sales.Customers as C
left join Sales.Orders as O
ON C.custid = O.custid and O.orderdate ='20070212'


GO -- 7

SELECT C.Custid custid, C.companyname companyname , case when o.orderid IS NOT NULL  then 'Yes' else 'No' end as hasorderOn20070212
FROM Sales.Customers as C
left join Sales.Orders as O
ON C.custid = O.custid  and O.orderdate ='20070212'
order by custid












  