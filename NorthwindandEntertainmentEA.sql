-- 1. Show a list of entertainers based in Bellevue,Redmond, or Woodinville
-- who do not have a registered email address.   
-- Please  include entertainers stage name, phone number and the city they live in.
SELECT entstagename, entphonenumber, entcity FROM entertainers 
WHERE entcity IN ('Bellevue', 'Redmond', 'Woodinville')
AND entemailaddress IS NULL;

-- 2. Show all the engagements that started in September 2017 and ran for four days.
-- Consider the enddate as inclusive. 
SELECT * FROM engagements
WHERE EXTRACT(YEAR FROM startdate) = '2017' 
AND enddate-startdate = 3; 

-- 3. Find the  entertainers who played engagements for customers Berg or Hallmark. 
-- Sort the results by entertainer’s stage name alphabetically.
SELECT DISTINCT ent.stagename FROM entertainers ent 
JOIN engagements eng 
ON ent.entertainerid=eng.entertainerid
JOIN customers c 
ON eng.customerid=c.customerid
WHERE custlastname IN ('Berg', 'Hallmark')
ORDER BY ent.entstagename; 

-- 4. List entertainers who have either never been booked  or do not have a webpage or email address.
-- Sort the results by entertainer’s ID in ascending order
SELECT DISTINCT ent.entertainerid, ent.entstagename FROM entertainers ent 
LEFT JOIN engagements eng 
ON ent.entertainerid=eng.entertainerid
WHERE eng.engagementnumber IS NULL
OR ent.entwebpage IS NULL
OR ent.entemailaddress IS NULL 
ORDER BY ent.entertainerid; 

-- 5. Northwind Traders will prioritize re-ordering a certain product if:
-- (1) UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel,  
-- (2) the product is discontinuted (Discontinued = 0), and
-- (3) the product has been ordered more than 1 time. Which products need to be prioritized for    
-- reordering? Sort results by product ID in ascending order
SELECT DISTINCT p.productid, p.productname FROM products p 
JOIN orderdetails od 
ON p.productid=od.productid
WHERE p.unitsinstock + p.unitsonorder <= p.reorderlevel
AND p.discontinued = 0 
AND od.quantity > 1 
ORDER BY p.productid; 

-- 6. Northwind’s  operations team has noted the high cost of freight charges for Speedy Express
-- shipments. For 1996, return the three ship countries with the highest average freight, in descending
-- order by average freight, for orders fulfilled by Speedy  Express.
SELECT o.shipcountry, AVG(o.freight) avg_freight FROM orders o 
JOIN shippers s 
ON o.shipvia=s.shipperid
WHERE s.companyname = 'Speedy Express'
AND EXTRACT(YEAR FROM o.shippeddate) = '1996'
GROUP BY o.shipcountry
ORDER BY AVG(o.freight) DESC
LIMIT 3; 

-- 7. Some sales people have more orders arriving late than other salespeople
-- (defined as RequiredDate <= ShippedDate). Which salespeople have at least 5 orders arriving late?
-- Do not show any employees with less than 5 late orders. Sort the results by total late orders in
-- descending order.
SELECT e.firstname, e.lastname, COUNT(o.orderid) AS totallateorders FROM employees e 
JOIN orders o 
ON e.employeeid=o.employeeid
WHERE o.requireddate <= o.shippeddate 
GROUP BY e.firstname, e.lastname 
HAVING COUNT(o.orderid) >= 5 
ORDER BY COUNT(o.orderid) DESC; 

-- 8. Suppose that the company wants to send all of the high-value customers a special VIP gift.  
-- A high-value customer is anyone who’ve made at least 1 order with a total value
-- (quantity x unit price) equal to $10,000 or more. Query all of these high-value customer in 1996.
SELECT c.companyname, o.orderid, SUM(od.quantity*od.unitprice) AS totalvalue FROM orderdetails od  
JOIN orders o 
ON od.orderid=o.orderid
JOIN customers c 
ON o.customerid=c.customerid 
WHERE EXTRACT(YEAR FROM o.shippeddate) = '1996'
GROUP BY c.companyname, o.orderid
HAVING SUM(od.quantity*od.unitprice) >= 10000
ORDER BY totalvalue DESC; 

-- 9. Which are the customers that did not place any order?
SELECT c.companyname FROM customers c 
LEFT JOIN orders o 
ON c.customerid=o.customerid
WHERE o.orderid IS NULL; 

-- 10. What are the shippers that Northwind collaborated with?
SELECT DISTINCT s.companyname FROM shippers s
JOIN orders o
ON o.shipvia = s.shipperid;

-- 11. What are the shippers that Northwind did not work with?
SELECT DISTINCT s.companyname FROM shippers s
LEFT JOIN orders o
ON o.shipvia = s.shipperid
WHERE o.shipvia IS NULL OR s.shipperid IS NULL;

-- 12. Which employees and which territories are not assigned yet (to territories and employees
-- respectively), if any
SELECT e.employeeid, t.territoryid, t.territorydescription FROM employees e 
LEFT JOIN employeeterritories et 
ON e.employeeid=et.employeeid
RIGHT JOIN territories t 
ON et.territoryid=t.territoryid 
WHERE e.employeeid IS NULL OR et.territoryid IS NULL; 