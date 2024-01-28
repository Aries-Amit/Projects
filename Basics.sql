USE sql_store;

-- SELECT name, unit_price, unit_price * 1.1 AS 'New price'
-- FROM products

-- LOGICAL operators
-- SELECT *
-- FROM order_items
-- WHERE order_id = 6 AND unit_price * quantity > 30

-- IN clause
-- SELECT *
-- FROM products
-- WHERE quantity_in_stock IN (49, 38, 72)

-- LIKE clause
-- SELECT *
-- FROM customers
-- WHERE address LIKE '%TRAIL%' OR
-- 	  address LIKE '%AVENUE%'

-- LIKE clause
-- SELECT *
-- FROM customers
-- WHERE phone LIKE '%9'

-- Regular Expression
-- SELECT *
-- FROM customers
-- WHERE first_name REGEXP 'ELKA|AMBUR'

-- SELECT * 
-- FROM customers
-- WHERE last_name REGEXP "EY$|ON$" 

-- SELECT * 
-- FROM customers
-- WHERE last_name REGEXP "^my|se"

-- SELECT * 
-- FROM customers
-- WHERE last_name REGEXP "b[ru]" 

-- ISNULL Operator
-- SELECT *
-- FROM orders
-- WHERE shipped_date IS NULL

-- ORDER BY clause
-- SELECT * 
-- FROM order_items
-- WHERE order_id = 2
-- 	  ORDER BY product_id

-- Limit Clause
-- SELECT * 
-- FROM customers
-- ORDER BY points DESC
-- LIMIT 3 

-- INNER join
SELECT order_id, oi.product_id, name, quantity, oi.unit_price 
FROM order_items oi
JOIN products p
	on oi.product_id = p.product_id