#Creating a Database
CREATE DATABASE `sql_invoicing`; 

#To use the created database
USE `sql_invoicing`;

#Creating Table
CREATE TABLE `payment_methods` (
  `payment_method_id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`payment_method_id`)
);

#Insert Data into Table
INSERT INTO `payment_methods` VALUES (1,'Credit Card');
INSERT INTO `payment_methods` VALUES (2,'Cash');
INSERT INTO `payment_methods` VALUES (3,'PayPal');
INSERT INTO `payment_methods` VALUES (4,'Wire Transfer');

#Inserting values into customer tables
INSERT INTO customers (first_name, last_name, birth_date, address, city, state) 
VALUES (DEFAULT, 'John', 'Smith', '1990-01-01', NULL, 'address', 'city', 'CA', DEFAULT);

#Inserting Multiple Rows
INSERT INTO shippers (name) 
VALUES ('Shippers1'), ('Shippers2'), ('Shippers3');

#Inserting 3 rows in products table
INSERT INTO products(name, quantity_in_stock, unit_price)
VALUES ('Product1', 10, 1.95),
	   ('Product2', 20, 3.95),
       ('Product3', 30, 5.95);

#Inserting Hierarchical Rows
INSERT INTO orders (customer_id, order_date, status)
VALUES (1,'2019-01-01',1);
SELECT LAST_INSERT_ID();

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 2.98),
	   (LAST_INSERT_ID(), 1, 1, 2.98);

#Creating a copy of a table
USE sql_store;
CREATE TABLE orders_archived AS
SELECT * FROM orders;

#SubQuery
INSERT INTO orders_archived 
SELECT * FROM orders WHERE order_date < '2019-01-01';

#Retrieve all the data from the table payment methods
SELECT * FROM payment_methods;

--  Example
USE sql_invoicing;
CREATE TABLE invoices_archived AS 
SELECT 
	i.invoice_id,
    i.number,
    c.name AS clients,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.payment_date,
    i.due_date
FROM invoices i JOIN clients c
USING(client_id)
WHERE payment_date IS NOT NULL;

#Updating a particular row
UPDATE invoices SET payment_total=10, payment_date='2019-03-01' WHERE invoice_id=1;

UPDATE invoices SET payment_total=invoice_total*0.5, payment_date=due_date WHERE invoice_id=3;

#Updating Mutiple Rows
UPDATE invoices SET payment_total=invoice_total*0.5, payment_date=due_date WHERE client_id=3;
UPDATE invoices SET payment_total=invoice_total*0.5, payment_date=due_date WHERE client_id IN (3,4);

#Sql statenment that gives gives the customers 50 extra points who are born before 1990
UPDATE customers 
SET points=points+50
WHERE birth_date < '1990-01-01';

#Subquering in update statements
UPDATE invoices 
SET payment_total=invoice_total*0.5, payment_date=due_date 
WHERE client_id=(SELECT client_id FROM clients WHERE name='Myworks');

#Delete Statements
DELETE FROM invoices WHERE invoices_id =1;
DELETE FROM invoices WHERE client_id=( SELECT * FROM clients WHERE name='Myworks');

#Retrieve the customer data whose id=1
USE sql_store;
SELECT * FROM customers WHERE customer_id=1 ;

#Sort the customer by first name 
SELECT * FROM customers ORDER BY first_name;
SELECT * FROM customers ORDER BY first_name DESC;

#Below line will select first two cols from customers and it's filled with value 1 in 1st rows and value 2 in second rows
SELECT 1, 2 FROM customers;

SELECT 
	last_name,
    first_name,
    points,
    (points+10) * 100 AS 'discount factor'
FROM customers;

#Remove duplicate values by using DISTINCT keyword
SELECT DISTINCT state from customers;

#Returns all the products with name, unit price and add new column which calculate the new price (unitprice * 1.1)
USE sql_inventory;
SELECT name, unit_price, unit_price*1.1 AS new_price from products;

###### WHERE CLAUSE ###########3
SELECT * FROM customers WHERE state='VA';

# Not equal to has two signs != or you can write <>
SELECT * FROM customers WHERE state!='VA';
SELECT * FROM customers WHERE state<>'VA';

SELECT * FROM customers WHERE birth_date > '1990-01-01';

#Get the orders placed this year
USE sql_store;
SELECT * FROM orders WHERE order_date>= '2020-01-01' ;


########### AND, OR and NOT Conditions ############
SELECT * FROM customers
	WHERE birth_date > '1990-01-01' 
    AND points > 1000;
    
SELECT * FROM customers
	WHERE birth_date > '1990-01-01'
    OR points > 1000;

SELECT * FROM customers
	WHERE birth_date > '1990-01-01' OR 
    (points > 1000 AND state = 'VA');
    
########## IN Operator #############
SELECT * FROM customers WHERE state='VA' OR state='GA' OR state='FL';
SELECT * FROM customers WHERE state='VA' OR 'GA' OR 'FL';
SELECT * FROM customers WHERE state IN ('VA','FL','GA');

SELECT * FROM customers WHERE state NOT IN ('VA','FL','GA');

######### BETWEEN Operator #################
SELECT * FROM customers WHERE points BETWEEN 1000 AND 3000;

#Return a customers born between 1/1/1990 and 1/1/2000
SELECT * FROM customers WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

############ LIKE Operator ###################

#Retrieve a last name starts with letter b
SELECT * FROM customers WHERE last_name LIKE 'b%' ;

#Retrieve a last name starts with letter brush
SELECT * FROM customers WHERE last_name LIKE 'brush%';

#Retrive a customer who has a letter b somewhere in lastname 
SELECT * FROM customers WHERE last_name LIKE '%b%';

#Retrive a customer whose lastname ends with letter y
SELECT * FROM customers WHERE last_name LIKE 'y%';


#Retrive a customer whose lastname has two character, we don't whether first character matches or not in _ but last character should be y
SELECT * FROM customers WHERE last_name LIKE '_y';
SELECT * FROM customers WHERE last_name LIKE '_____y';
SELECT * FROM customers WHERE last_name LIKE 'b____y';

#Get a customer whose addresses contains TRAIL or AVENUE and phone numbers end with 9
SELECT * FROM customers WHERE address LIKE '%trail%' OR '%avenue%';
SELECT * FROM customers WHERE phone LIKE '%9';

######## REGEXP Operator ################ 
SELECT * FROM customers WHERE last_name LIKE '%field%';
SELECT * FROM customers WHERE last_name REGEXP 'field';

#Lastname starts with field
SELECT * FROM customers WHERE last_name REGEXP '^field';
#Lastname ends with fields
SELECT * FROM customers WHERE last_name REGEXP '^field';
#lastname should either starts with field or contains mac or rose
SELECT * FROM customers WHERE last_name REGEXP '^field|mac|rose';
# lastname that contains a word ef or em or eq
SELECT * FROM customers WHERE last_name REGEXP 'e[fmq]';
# lastname that contains a word fe or me or qe
SELECT * FROM customers WHERE last_name REGEXP '[fmq]e';

SELECT * FROM customers WHERE last_name REGEXP '[abcdef]e';
SELECT * FROM customers WHERE last_name REGEXP '[a-f]e';

-- Get the customers whose 
	-- first names are ELKA or AMBUR
SELECT * FROM customers WHERE last_name REGEXP 'ekla|ambur';
    -- last names ends with EY or ON
SELECT * FROM customers WHERE last_name REGEXP 'ey$|on$';
    -- last names starts with EY or contains ON
SELECT * FROM customers WHERE last_name REGEXP '^ey|on';
    -- last names contains B followed by R or U
SELECT * FROM customers WHERE last_name REGEXP 'b[ru]';

################ Is Null Operators ################
SELECT * FROM customers WHERE phone IS NOT NULL;

#Get  the orders that are not shipped
SELECT * FROM orders WHERE shipper_id IS NULL;

############# Limit Clause #####################
-- It retrieves a first 3 rows of customers tables
SELECT * FROM customers LIMIT 3;
-- It skipped the first 6 records and retrieve the next 3 i.e row 7,8,9
SELECT * FROM customers LIMIT 6, 3;

-- Get the top three loyal customers
SELECT * FROM customers ORDER BY points DESC LIMIT 3;

################## Inner Joins ####################
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c 
ON o.customer_id = c.customer_id;

################## Join Across Database ##########
USE sql_store;
SELECT * FROM order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id;
    
############ Self Joins ##########################
USE sql_hr;
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id;
    
#### JOINING MULTIPLE TABLES #############

-- Example 1
USE sql_store;
SELECT 
	o.order_id,
	o.order_date,
	c.first_name,
    c.last_name,
    os.name AS status
FROM orders 
JOIN customers c
	ON o.customer_id=c.customer_id
JOIN order_statuses os
	ON o.status= os.order_status_id;

-- Example 2
USE sql_invoicing;

SELECT c.client_id,p.payment_id, pm.name
FROM payments p
JOIN clients c
	ON p.client_id=c.client_id
JOIN payment_methods pm
	ON p.payment_method=pm.payment_method_id;


################ COMPOUND JOIN CONDITION ###########
USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id=oin.order_id
    AND oi.product_id=oin.product_id;

######## IMPLICIT JOIN SYNTAX ####################
USE sql_store;
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id=c.customer_id;
    
# Above query gives same results. In below query if we forget to write WHERE clause then it will be cross join    
SELECT *
FROM orders o, customers c
WHERE o.customer_id=c.customer_id;

########## OUTER JOIN #####################
USE sql_store;

SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o
	ON o.customer_id=c.customer_id
ORDER BY c.customer_id;

-- Example:

USE sql_store;

SELECT p.product_id, p.name, oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id=oi.product_id
ORDER BY p.product_id;

########## OUTER JOINS BETWEEN MULTIPLE TABLES #####

SELECT c.customer_id, c.first_name, o.order_id, sh.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON o.customer_id=c.customer_id
LEFT JOIN shippers sh
	ON sh.shipper_id=o.shipper_id
ORDER BY c.customer_id;

-- Example:

SELECT o.order_date, o.order_id, c.first_name AS customer, sh.name AS shipper, os.name
FROM customers c
JOIN orders o
	ON o.customer_id=c.customer_id
LEFT JOIN shippers sh
	ON sh.shipper_id=o.shipper_id
JOIN order_statuses os 
	ON o.status=os.order_status_id;

######## SELF OUTER JOIN ######################
USE sql_hr;
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to=m.employee_id;

######### USING CLAUSE ###################
USE sql_store;

SELECT o.order_id, c.first_name
FROM orders o
JOIN customers c
	-- ON o.customer_id=c.customer_id
    USING(customer_id);

-- Example:

SELECT * 
FROM order_items oi
JOIN order_item_notes oin
	-- ON oi.order_id=oin.order_id AND
	   -- oi.product_id=oin.product_id
	USING(order_id, product_id);

-- Example:
USE sql_invoicing;

SELECT p.date, c.name AS client, p.amount,pm.name AS payment_method
FROM payments p
JOIN clients c USING (client_id)
JOIN payment_methods pm
	ON p.payment_method=pm.payment_method_id;

############# NATURAL JOIN #####################
USE sql_store;

SELECT o.order_id, c.first_name
FROM orders o
NATURAL JOIN customers c;

############ CROSS JOIN ####################
USE sql_store;

SELECT c.first_name AS customer, p.name AS product
FROM customers c, orders o
CROSS JOIN products p
ORDER BY c.first_name;

-- Do a cross join between shippers and products using the implicit syntax and then using the explicit syntax
-- Example using implicit syntax:
USE sql_store;
SELECT sh.name AS shipper, p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

###Same result as above
-- Using Explicit Syntax
USE sql_store;
SELECT sh.name AS shipper, p.name AS product
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;

######### UNIONS ############
USE sql_store;

SELECT order_id, order_date, 'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT order_id, order_date, 'Archieved' AS status
FROM orders
WHERE order_date < '2019-01-01';

-- Example:

USE sql_store;

SELECT first_name FROM customers
UNION
SELECT name FROM shippers;

-- Example:

USE sql_store;
SELECT customer_id, first_name,points,'Bronze' AS type
FROM customers
WHERE points<2000
UNION
SELECT customer_id, first_name,points,'Silver' AS type
FROM customers
WHERE points>=2000 AND points<3000;




