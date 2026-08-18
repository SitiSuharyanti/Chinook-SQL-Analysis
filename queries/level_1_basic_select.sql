-- ============================================================
-- LEVEL 1: Basic SELECT
-- ============================================================

-- Q1: Which customers are based in the USA?
SELECT * FROM customer WHERE country = 'USA';

-- Q2: What are the 10 highest-value invoices?
SELECT
    invoice_id,
    customer_id,
    total
FROM invoice
ORDER BY total DESC
LIMIT 10;

-- Q3: How many tracks are in the catalog?
SELECT COUNT(*) AS total_number_of_tracks FROM track;

-- Q4: Who are the Sales Support Agents?
SELECT * FROM employee WHERE title = 'Sales Support Agent';

-- Q5: What genres does the store offer?
SELECT * FROM genre ORDER BY name ASC;
