USE sql_invoicing;

-- USING clause - used in joins if both tables are joined on a column that has same column name in both tables...

SELECT
	p.date,
    c.name,
    p.amount,
    pm.name AS method
FROM payments p
JOIN clients c
	using (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id