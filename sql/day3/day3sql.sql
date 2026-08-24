-- ============================================
-- Data Engineering Portfolio
-- Day 3: Advanced SQL
-- ============================================

-- 1. Customer spending totals
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(SUM(o.amount), 0) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;


-- 2. Customer spending and order count
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(SUM(o.amount), 0) AS total_spent,
    COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;


-- 3. CTE: Average customer spending
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COALESCE(SUM(o.amount), 0) AS total_spent
    FROM customers AS c
    LEFT JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)
SELECT
    AVG(total_spent) AS average_customer_spend
FROM customer_totals;


-- 4. Window Function: Total spending by customer
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.amount,
    SUM(o.amount) OVER (
        PARTITION BY o.customer_id
    ) AS customer_total
FROM orders AS o
ORDER BY
    o.customer_id,
    o.order_date;


-- 5. Window Function: Number each customer's orders
SELECT
    order_id,
    customer_id,
    order_date,
    amount,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS order_number
FROM orders
ORDER BY
    customer_id,
    order_date;


-- 6. CTE + ROW_NUMBER(): Most recent order per customer
WITH ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS order_rank
    FROM orders
)
SELECT *
FROM ranked_orders
WHERE order_rank = 1;


-- 7. Customer spending ranks
WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    t.total_spent,
    RANK() OVER (
        ORDER BY t.total_spent DESC
    ) AS spending_rank
FROM customers AS c
JOIN customer_totals AS t
    ON c.customer_id = t.customer_id
ORDER BY spending_rank;


-- 8. Top 3 spending positions, including customers with $0
WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COALESCE(t.total_spent, 0) AS total_spent,
        RANK() OVER (
            ORDER BY COALESCE(t.total_spent, 0) DESC
        ) AS spending_rank
    FROM customers AS c
    LEFT JOIN customer_totals AS t
        ON c.customer_id = t.customer_id
)
SELECT *
FROM ranked_customers
WHERE spending_rank <= 3
ORDER BY spending_rank;