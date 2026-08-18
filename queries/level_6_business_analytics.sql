-- ============================================================
-- LEVEL 6: Business Analytics
-- ============================================================

-- Q1: Who are the top 10 customers by lifetime value?
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(i.total) AS lifetime_value
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_value DESC
LIMIT 10;

-- Q2: What is the best-selling genre in each country?
WITH genre_sales AS (
    SELECT
        g.genre_id,
        g.name,
        i.billing_country,
        SUM(il.unit_price * il.quantity) AS total_sales
    FROM genre g
    JOIN track t ON g.genre_id = t.genre_id
    JOIN invoice_line il ON t.track_id = il.track_id
    JOIN invoice i ON il.invoice_id = i.invoice_id
    GROUP BY g.genre_id, g.name, i.billing_country
),
ranked_genre AS (
    SELECT
        genre_id,
        name,
        billing_country,
        total_sales,
        RANK() OVER (PARTITION BY billing_country ORDER BY total_sales DESC) AS ranking
    FROM genre_sales
)
SELECT
    genre_id,
    name,
    billing_country,
    total_sales
FROM ranked_genre
WHERE ranking = 1
ORDER BY billing_country;

-- Q3: Which customers have been active across multiple years?
WITH customer_years AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        EXTRACT(YEAR FROM i.invoice_date) AS purchase_year
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, purchase_year
)
SELECT
    customer_id,
    first_name,
    last_name,
    COUNT(purchase_year) AS active_year
FROM customer_years
GROUP BY customer_id, first_name, last_name
HAVING COUNT(purchase_year) > 1
ORDER BY active_year DESC;

-- Q4: What is the month-over-month revenue growth rate?
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', invoice_date) AS invoice_month,
        SUM(total) AS revenue
    FROM invoice
    GROUP BY invoice_month
),
revenue_with_previous AS (
    SELECT
        invoice_month,
        revenue,
        LAG(revenue) OVER (ORDER BY invoice_month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    invoice_month,
    revenue,
    previous_month_revenue,
    ROUND(((revenue - previous_month_revenue) / previous_month_revenue) * 100, 2) AS growth_rate
FROM revenue_with_previous
ORDER BY invoice_month;

-- Q5: How can customers be segmented by purchase frequency?
WITH customer_purchase AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(i.invoice_id) AS purchase_count
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    first_name,
    last_name,
    purchase_count,
    CASE
        WHEN purchase_count = 1 THEN 'One-time'
        WHEN purchase_count BETWEEN 2 AND 4 THEN 'Occasional'
        WHEN purchase_count BETWEEN 5 AND 9 THEN 'Regular'
        ELSE 'Frequent'
    END AS customer_segment
FROM customer_purchase
ORDER BY purchase_count DESC;
