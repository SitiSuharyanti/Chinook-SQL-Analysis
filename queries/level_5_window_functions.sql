-- ============================================================
-- LEVEL 5: Window Functions
-- ============================================================

-- Q1: How does each customer rank by total spending?
WITH count_customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS customer_spending
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    first_name,
    last_name,
    customer_spending,
    RANK() OVER (ORDER BY customer_spending DESC) AS customer_rank
FROM count_customer_spending;

-- Q2: Which track earns the most within each genre?
WITH track_revenue AS (
    SELECT
        t.name AS track_name,
        g.name AS genre_name,
        SUM(il.unit_price * il.quantity) AS revenue
    FROM genre g
    JOIN track t ON g.genre_id = t.genre_id
    JOIN invoice_line il ON t.track_id = il.track_id
    GROUP BY t.name, g.name
)
SELECT
    track_name,
    genre_name,
    revenue,
    RANK() OVER (
        PARTITION BY genre_name
        ORDER BY revenue DESC
    ) AS track_rank
FROM track_revenue;

-- Q3: What is the cumulative revenue over time?
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', invoice_date) AS invoice_month,
        SUM(total) AS revenue_per_month
    FROM invoice
    GROUP BY invoice_month
)
SELECT
    invoice_month,
    revenue_per_month,
    SUM(revenue_per_month) OVER (ORDER BY invoice_month) AS running_total
FROM monthly_revenue;

-- Q4: How can customers be segmented by total spending value?
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS spending
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    first_name,
    last_name,
    spending,
    CASE
        WHEN spending > 40 THEN 'High'
        WHEN spending BETWEEN 20 AND 40 THEN 'Medium'
        ELSE 'Low'
    END AS customer_segment
FROM customer_spending;

-- Q5: What share of total revenue do the top 12 customers account for?
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS spending,
        ROW_NUMBER() OVER (ORDER BY SUM(i.total) DESC) AS spending_rank
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
),
total_revenue AS (
    SELECT SUM(spending) AS total_revenue_all_customer FROM customer_spending
),
top_12_customer AS (
    SELECT SUM(spending) AS top_12_revenue
    FROM customer_spending
    WHERE spending_rank <= 12
)
SELECT
    ROUND((top_12_revenue / total_revenue_all_customer) * 100, 2) AS revenue_percentage
FROM top_12_customer
CROSS JOIN total_revenue;
