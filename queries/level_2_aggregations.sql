-- ============================================================
-- LEVEL 2: Aggregations
-- ============================================================

-- Q1: What is the store's total revenue?
SELECT SUM(total) AS total_revenue FROM invoice;

-- Q2: Which countries generate the most revenue?
SELECT
    billing_country AS country,
    SUM(total) AS total_revenue
FROM invoice
GROUP BY country
ORDER BY total_revenue DESC;

-- Q3: How many invoices has each country placed?
SELECT
    billing_country AS country,
    COUNT(*) AS invoice_count
FROM invoice
GROUP BY country;

-- Q4: What is the average invoice value?
SELECT ROUND(AVG(total), 2) AS average_invoice_value FROM invoice;

-- Q5: Which customers place the most orders?
SELECT
    customer_id,
    COUNT(*) AS invoice_count
FROM invoice
GROUP BY customer_id
ORDER BY invoice_count DESC
LIMIT 5;
