-- USE sql_hr;

-- Self Join

-- SELECT 
--    e.employee_id, e.first_name, e.last_name,
--    m.first_name AS manager
-- FROM employees e
-- JOIN employees m
-- 	  ON e.reports_to = m.employee_id;
    
-- USE sql_invoicing;

-- INNER JOIN(MORE THAN 2 TABLES)

-- SELECT
-- 	   p.payment_id, p.date, p.invoice_id,
--     c.name, c.phone,
--     p.amount,
--     pm.name as Payment_method
-- FROM payments p
-- JOIN clients c
	-- on p.client_id = c.client_id
-- JOIN payment_methods pm
	-- on p.payment_method = pm.payment_method_id

USE sql_store;

-- OUTERJOIN(2-tables)

-- SELECT 
	-- p.product_id, p.name,
    -- oi.quantity
-- FROM products p
-- LEFT JOIN order_items oi
	-- ON p.product_id = oi.product_id
    
-- OUTERJOINS (MORE THAN 2 TABLES)

-- SELECT
	-- o.order_date, o.order_id, 
    -- c.first_name,
    -- sh.name as shipper,
    -- os.name as status
-- FROM orders o
-- LEFT JOIN customers c
	-- on o.customer_id = c.customer_id
-- LEFT JOIN shippers sh
	-- on sh.shipper_id = o.shipper_id
-- LEFT JOIN order_statuses os
	-- on o.status = os.order_status_id
-- ORDER BY status

-- CROSSJOINS

-- SELECT 
	-- p.name AS product_name,
    -- s.name AS shipper_name
-- FROM products p
-- CROSS JOIN shippers s