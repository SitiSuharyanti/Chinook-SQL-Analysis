-- ============================================================
-- LEVEL 4: CTEs & Advanced Filtering
-- ============================================================

-- Q1: What percentage of total revenue comes from the top 10 customers?
WITH top_10_customer AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spending_10
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
    ORDER BY total_spending_10 DESC
    LIMIT 10
),
customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spending_all
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
),
top_10_revenue AS (
    SELECT SUM(total_spending_10) AS ten_customer FROM top_10_customer
),
total_revenue AS (
    SELECT SUM(total_spending_all) AS all_customer FROM customer_spending
)
SELECT
    ROUND(((ten_customer / all_customer) * 100), 2) AS percentage_top_10_customer
FROM top_10_revenue
CROSS JOIN total_revenue;

-- Q2: Which countries have the highest average customer spending?
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.country,
        SUM(i.total) AS total_spending
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
)
SELECT
    country,
    ROUND(AVG(total_spending), 2) AS avg_spending_per_customer
FROM customer_spending
GROUP BY country
ORDER BY avg_spending_per_customer DESC;

-- Q3: How does revenue trend month by month?
SELECT
    DATE_TRUNC('month', invoice_date) AS invoice_month,
    SUM(total) AS revenue_per_month
FROM invoice
GROUP BY invoice_month
ORDER BY invoice_month;

-- Q4: Which genres are most popular in the USA?
SELECT
    g.genre_id,
    g.name,
    i.billing_country AS country,
    SUM(il.unit_price * il.quantity) AS genre_revenue
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
JOIN invoice_line il ON t.track_id = il.track_id
JOIN invoice i ON il.invoice_id = i.invoice_id
WHERE i.billing_country = 'USA'
GROUP BY g.genre_id, i.billing_country
ORDER BY genre_revenue DESC;

-- Q5: Who is the top-earning artist in each country?
SELECT DISTINCT ON (i.billing_country)
    a.artist_id,
    a.name,
    i.billing_country AS country,
    SUM(il.unit_price * il.quantity) AS artist_revenue
FROM artist a
JOIN album alb ON a.artist_id = alb.artist_id
JOIN track t ON alb.album_id = t.album_id
JOIN invoice_line il ON t.track_id = il.track_id
JOIN invoice i ON il.invoice_id = i.invoice_id
GROUP BY a.artist_id, i.billing_country
ORDER BY country ASC, artist_revenue DESC;
