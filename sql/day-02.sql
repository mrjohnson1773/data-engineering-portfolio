-- Day 2: SQL Joins, Aggregations, and NULL Handling
-- Data Engineering Journey

-- 1. LEFT JOIN
-- Find customers and their orders, including customers without orders.
SELECT c.first_name, c.last_name, o.amount
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id;


-- 2. LEFT JOIN + IS NOT NULL
-- Find customers who have placed an order.
SELECT c.first_name, c.last_name, o.amount
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.amount IS NOT NULL;


-- 3. INNER JOIN + WHERE
-- Find customers with orders greater than $100.
SELECT c.first_name, c.last_name, o.amount
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.amount > 100;


-- 4. SUM + GROUP BY
-- Calculate the total amount spent by each customer.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(o.amount) AS total_amount_spent
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;


-- 5. HAVING + SUM
-- Find customers who have spent more than $200.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(o.amount) AS total_amount_spent
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.amount) > 200;


-- 6. COUNT + HAVING
-- Find customers who have placed at least 2 orders.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(o.order_id) AS num_orders
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) >= 2;


-- 7. Multiple aggregate conditions
-- Find customers with at least 2 orders AND more than $200 spent.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(o.order_id) AS num_orders,
       SUM(o.amount) AS total_amount_spent
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) >= 2
   AND SUM(o.amount) > 200;


-- 8. LEFT JOIN + COALESCE
-- Show every customer, including customers with no orders.
-- Customers with no orders should show $0 spent.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COALESCE(SUM(o.amount), 0) AS total_amount_spent
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;


-- 9. Customer spending report
-- Show every customer, their order count, and total spending.
-- Only customers spending more than $100 are included.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.amount), 0) AS total_amount_spent
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.amount) > 100;