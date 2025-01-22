-- 1. Northwind’s inventory team needs a report of products that have unit prices above the average unit
-- price for all products, but units in stock below average. This helps them with restocking and purchasing     
-- decisions. Produce this report for them. Sort the results by the product name alphabetically.
WITH average AS
(SELECT productname, unitprice, AVG(unitprice) AS avg_unitprice, unitsinstock, AVG(unitsinstock) AS avg_unitsinstock
FROM products
GROUP BY productname, unitprice, unitsinstock)
SELECT productname FROM average
WHERE unitprice > (SELECT AVG(unitprice) FROM products)
AND unitsinstock < (SELECT AVG(unitsinstock) FROM products)
ORDER BY productname; 

-- 2. What is the average number of orders processed by a Northwind employee?
WITH order_num AS
(SELECT e.employeeid, COUNT(orderid) as num_orders FROM orders o
JOIN employees e
ON e.employeeid=o.employeeid
GROUP BY e.employeeid)
SELECT avg(num_orders) AS average_orders FROM order_num;

-- 3. Which product categories have average total discount (this is defined as discount * unitprice * quantity)
-- larger than the average discount across all product categories? Sort the results by the product category alphabetically.
WITH avg_total_discount AS
(SELECT c.categoryname, AVG(o.discount*o.unitprice*o.quantity) total_discount FROM orderdetails o
JOIN products p
ON o.productid = p.productid
JOIN categories c
ON p.categoryid = c.categoryid
GROUP BY c.categoryname)
SELECT categoryname, total_discount FROM avg_total_discount
WHERE total_discount > (SELECT AVG(discount*unitprice*quantity) FROM orderdetails)
ORDER BY categoryname;

-- 4. Produce a report containing the companyname, contactname, and num_orders (number of orders) that each
-- customer has made. Show the top five customers that have had the most orders. Do not use a subquery in this question.
SELECT c.companyname, c.contactname, COUNT(o.orderid) AS num_orders FROM customers c 
JOIN orders o 
ON o.customerid=c.customerid 
GROUP BY c.companyname, c.contactname
ORDER BY COUNT(o.orderid) DESC
LIMIT 5; 

-- 5. Using a correlated subquery, produce a report containing the companyname, contactname, and num_orders
-- (number of orders) that each company has made. Do not use a GROUP BY to produce this report. Show the top five
-- companies that have had the most orders.
SELECT c.companyname, c.contactname, 
(SELECT COUNT(o.orderid) FROM orders o 
WHERE o.customerid=c.customerid) AS num_orders
FROM customers c
ORDER BY num_orders DESC
LIMIT 5; 

-- 6. Northwind wants to ensure that all customers purchase at least one order. Produce a report showing a list
-- of countries where customers have not ordered, and how many customers there are in these countries.
WITH null_country AS
(SELECT c.country FROM customers c
LEFT JOIN orders o
ON c.customerid = o.customerid
WHERE o.orderid IS NULL)
SELECT c.country, COUNT(customerid) num_customers FROM customers c
WHERE c.country IN (SELECT c.country FROM customers c
LEFT JOIN orders o
ON c.customerid = o.customerid
WHERE o.orderid IS NULL)
GROUP BY c.country;

-- 7. Produce a report showing all customer IDs and number of orders per customer, only for customers who have
-- placed a number of orders higher than the average number of orders across all customers. Show the top 5
-- customers only, with the highest number of orders. 
WITH x AS 
(SELECT customerid, COUNT(orderid) num_orders FROM orders 
GROUP BY customerid)
SELECT customerid, num_orders FROM x 
WHERE num_orders > (SELECT AVG(num_orders) FROM x)
ORDER BY num_orders DESC
LIMIT 5; 

-- 8. Northwind always wants to ensure that the best selling products are in stock. There is a Tableau dashboard
-- that is connected to the enterprise data warehouse which displays the average unitsinstock for top products.      
-- Write the backend SQL query that will compute the average unitsinstock for the top 5 best selling products. We     
-- define best selling as the total order value of a product as computed using unitprice*quantity.      
WITH best_selling AS
(SELECT DISTINCT p.productname, p.unitsinstock, SUM(od.unitprice*od.quantity) total_value FROM orderdetails od
JOIN products p 
ON od.productid = p.productid
GROUP BY  p.productname,  p.unitsinstock
ORDER BY total_value DESC
LIMIT 5)
SELECT productname, ROUND(AVG(unitsinstock)::numeric, 2) avg_units_in_stock FROM best_selling
GROUP BY productname;

-- 9. The HR onboarding team wants to use the top employees' most recent order transactions as exemplars to show
-- to the newest batch of Northwind employees. Write a query that shows the order ID, customer ID, freight, and
-- order date for the 10 most recent orders processed by employees who have processed over 100,000 in
-- total value (unit price * quantity) for orders.
WITH cust_value AS
(SELECT SUM(od.unitprice * od.quantity) AS total_value 
FROM orderdetails od
JOIN orders o 
ON od.orderid=o.orderid
GROUP BY o.employeeid
HAVING SUM(od.unitprice * od.quantity) > 100000)
SELECT orderid, customerid, freight, orderdate FROM orders 
WHERE employeeid IN (SELECT employeeid FROM cust_value)
ORDER BY orderdate DESC
LIMIT 10; 

-- 10. Categorize each employee at Northwind by the number of orders they have processed.
-- If they have processed 75 or more orders, classify them as High Performer.
-- If they have between 50 and 74 orders, classify as Mid Tier.
-- Lower than 50 orders, classify as Low Performer. 
SELECT e.firstname, e.lastname, COUNT(o.orderid) AS num_orders,  
CASE
        WHEN COUNT(o.orderid) >= 75 THEN 'High Performer' 
        WHEN COUNT(o.orderid) BETWEEN 50 AND 74 THEN 'Mid Tier' 
        WHEN COUNT(o.orderid) < 50 THEN 'Low Performer'
END 
FROM employees e 
JOIN orders o 
ON e.employeeid=o.employeeid
GROUP BY e.firstname, e.lastname 
ORDER BY num_orders DESC; 