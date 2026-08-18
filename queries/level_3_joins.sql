-- ============================================================
-- LEVEL 3: Joins
-- ============================================================

-- Q1: Who are the highest-spending customers?
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(i.total) AS total_spending
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spending DESC;

-- Q2: Which tracks generate the most revenue?
SELECT
    t.track_id,
    t.name,
    SUM(il.unit_price * il.quantity) AS revenue_per_track
FROM track t
JOIN invoice_line il ON t.track_id = il.track_id
GROUP BY t.track_id
ORDER BY revenue_per_track DESC;

-- Q3: Which artists generate the most revenue?
SELECT
    a.artist_id,
    a.name,
    SUM(il.unit_price * il.quantity) AS artist_revenue
FROM artist a
JOIN album alb ON a.artist_id = alb.artist_id
JOIN track t ON alb.album_id = t.album_id
JOIN invoice_line il ON t.track_id = il.track_id
GROUP BY a.artist_id
ORDER BY artist_revenue DESC;

-- Q4: Which genres generate the most revenue?
SELECT
    g.genre_id,
    g.name,
    SUM(il.unit_price * il.quantity) AS genre_revenue
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
JOIN invoice_line il ON t.track_id = il.track_id
GROUP BY g.genre_id
ORDER BY genre_revenue DESC;

-- Q5: How much revenue does each sales agent generate?
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    SUM(i.total) AS revenue
FROM employee e
JOIN customer c ON e.employee_id = c.support_rep_id
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY e.employee_id
ORDER BY revenue DESC;
