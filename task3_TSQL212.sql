use TSQL2012;


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


GO 
SELECT C.custid, C.companyname FROM Sales.Customers as C
left join Sales.Orders as O
ON C.custid = O.custid
Where O.orderid  is null
 

GO 

SELECT C.Custid, C.companyname, o.orderid, O.orderdate FROM Sales.Customers as C
left join Sales.Orders as O
ON C.custid = O.custid
Where  O.orderdate ='20070212'








  