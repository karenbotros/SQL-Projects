-- 1. Which companies do Northwind Traders use for shipping their products? 
SELECT shipperid, companyname FROM shippers; 

-- 2.  Find the first name, last name, and the hiring date of all employees with 
-- the title “Sales Representative” or “Inside Sales Coordinator”.
SELECT firstname, lastname, hiredate FROM employees
WHERE title IN ('Sales Representative', 'Inside Sales Coordinator'); 

-- 3. Create a report showing the first name, last name, and country of all employees 
-- not in the United States. Order result alphabetically, by last name.
SELECT firstname, lastname, country FROM employees
WHERE country != 'USA'
ORDER BY lastname; 

-- 4.  Query all employee names (first and last) who are hired before Jan 1, 1994. 
-- Sort your results to find out who is the newest hire.
SELECT firstname, lastname, hiredate FROM employees 
WHERE hiredate < '1994-01-01'
ORDER BY hiredate DESC; 

-- 5. Show all orders (and return all columns) that happened in Madrid in year 1996.
SELECT * FROM orders 
WHERE shipcity = 'Madrid'
AND EXTRACT(YEAR FROM shippeddate) = '1996'; 

-- 6. Find and return only the product id and name for all “queso” products 
-- that have a unit price greater than 30
SELECT productid, productname FROM products
WHERE productname ILIKE '%queso%'
AND unitprice > 30; 

-- 7. Query all the orders (order id, customer id, and shipcountry) shipping to the following countries 
-- in Latin America (Brazil, Mexico, Argentina, Venezuela). 
-- Sort by freight value, with the heaviest freight first. 
-- Show the first 10 results only.
SELECT orderid, customerid, shipcountry FROM orders 
WHERE shipcountry in ('Brazil', 'Mexico', 'Argentina', 'Venezuela')
ORDER BY freight DESC 
LIMIT 10; 

-- 8. Create a report that shows the company name, contact title, city and country of all customers 
-- in Mexico, Brazil, or in any city in Spain except Madrid.
SELECT companyname, contacttitle, city, country FROM customers 
WHERE country IN ('Mexico', 'Brazil', 'Spain')
AND city != 'Madrid'; 

-- 9. What is the most expensive discontinued product that currently has units in stock? 
-- Show all columns and order your results from most expensive to least expensive.
SELECT * FROM products
WHERE discontinued = 1 
AND unitsinstock > 0 
ORDER BY unitprice DESC; 


-- 10. Which order (order id) has the highest total value after the discount? 
-- Return the orderid, productid, unitprice, quantity, discount, and total value 
-- of the order (in a column called totalvalue). 
-- Order the results in descending order of total value. 
-- Return only one result.
SELECT *, ((unitprice*quantity)*(1-discount)) AS totalvalue FROM orderdetails 
ORDER BY ((unitprice*quantity)*(1-discount)) DESC 
LIMIT 1; 