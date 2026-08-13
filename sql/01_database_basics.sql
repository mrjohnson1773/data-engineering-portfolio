-- ============================================
-- Data Engineering Journey
-- PostgreSQL & SQL Fundamentals
-- ============================================

-- Create database
CREATE DATABASE de_journey;


-- ============================================
-- Customers Table
-- ============================================

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    state VARCHAR(2)
);


-- ============================================
-- Insert Customer Data
-- ============================================

INSERT INTO customers (
    first_name,
    last_name,
    email,
    state
)
VALUES
    ('John', 'Smith', 'john@example.com', 'NM'),
    ('Sarah', 'Jones', 'sarah@example.com', 'CO'),
    ('Mike', 'Davis', 'mike@example.com', 'TX'),
    ('Jessica', 'Brown', 'jessica@example.com', 'NM'),
    ('David', 'Wilson', 'david@example.com', 'AZ');


-- ============================================
-- Orders Table
-- ============================================

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);


-- ============================================
-- Insert Order Data
-- ============================================

INSERT INTO orders (
    customer_id,
    order_date,
    amount
)
VALUES
    (1, '2026-08-01', 45.99),
    (1, '2026-08-05', 72.50),
    (2, '2026-08-02', 125.00),
    (3, '2026-08-03', 38.75),
    (4, '2026-08-06', 210.25),
    (5, '2026-08-07', 89.99);


-- ============================================
-- Basic Queries
-- ============================================

SELECT *
FROM customers;


SELECT
    first_name,
    last_name
FROM customers;


SELECT
    first_name,
    last_name,
    state
FROM customers
WHERE state = 'NM';


SELECT
    first_name,
    last_name,
    state
FROM customers
WHERE state <> 'NM'
ORDER BY last_name DESC;


-- ============================================
-- JOIN
-- ============================================

SELECT
    c.first_name,
    c.last_name,
    o.order_date,
    o.amount
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id;


-- ============================================
-- Aggregation
-- ============================================

SELECT
    c.first_name,
    c.last_name,
    SUM(o.amount) AS total_spent
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.first_name,
    c.last_name;


SELECT
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS order_count
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.first_name,
    c.last_name;