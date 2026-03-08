

-- How has total revenue and order volume evolved over time (monthly)?

SELECT DATE_FORMAT(order_date, '%Y-%m') order_month, SUM(total_amount) AS total_revenue, COUNT(order_id) AS total_order
FROM E_COMMERCE.orders 
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month
;




-- Which product categories contribute the most to total revenue?
SELECT p.category AS category, SUM(total_amount) AS total_revenue
FROM E_COMMERCE.products p
INNER JOIN E_COMMERCE.order_items oi
ON p.product_id = oi.product_id
INNER JOIN E_COMMERCE.orders o
ON oi.order_id = o.order_id
GROUP BY category
ORDER BY total_revenue DESC
;

-- Who are the top customers by total revenue contribution?
SELECT user_id, SUM(total_amount) AS total_revenue
FROM E_COMMERCE.orders
GROUP BY user_id
ORDER BY total_revenue DESC
LIMIT 10
;

-- How concentrated is revenue among customers (e.g., top 10% vs the rest)?


WITH customer_revenue AS(
SELECT user_id, 
	SUM(total_amount) AS total_revenue
FROM E_COMMERCE.orders
GROUP BY user_id
),
ranked AS(
SELECT user_id,
	total_revenue,
	PERCENT_RANK () OVER (ORDER BY total_revenue DESC) AS revenue_percentile
FROM customer_revenue
)

SELECT *
FROM ranked
WHERE revenue_percentile <= 0.1
;




WITH customer_revenue AS (
SELECT user_id,
	SUM(total_amount) AS total_revenue
FROM E_COMMERCE.orders
GROUP BY user_id
),

segmented AS (
SELECT user_id,
		total_revenue,
        NTILE(10) OVER (ORDER BY total_revenue DESC) AS revenue_group
	FROM customer_revenue
)

SELECT 
CASE 
    WHEN revenue_group = 1 THEN 'top-10%'
    ELSE 'bottom-90%'
    END AS customer_segment,
    SUM(total_revenue) AS segment_revenue
FROM segmented
GROUP BY customer_segment
;
-- Which sellers generate the highest revenue?
SELECT s.seller_id, SUM(total_amount) AS total_revenue
FROM E_COMMERCE.sellers s
INNER JOIN E_COMMERCE.products p
ON s.seller_id = p.seller_id
INNER JOIN E_COMMERCE.order_items oi
ON p.product_id = oi.product_id
INNER JOIN E_COMMERCE.orders o
ON oi.order_id =o.order_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10
;


-- Which products drive the highest sales volume and revenue?
SELECT p.product_id, SUM(quantity) AS quantity, SUM(total_amount) AS total_revenue,
	RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS volume_rank,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS revenue_rank
FROM E_COMMERCE.products p
INNER JOIN E_COMMERCE.order_items oi
ON p.product_id = oi.product_id
INNER JOIN E_COMMERCE.orders o
ON oi.order_id = o.order_id
GROUP BY p.product_id

;

-- Are sales driven more by repeat customers or one-time customers?



WITH customer_revenue AS (
SELECT user_id,
	COUNT(order_id) AS total_order,
    SUM(total_amount) AS total_revenue
FROM E_COMMERCE.orders
GROUP BY user_id
)

SELECT 
	CASE
		WHEN total_order = 1 THEN 'onetime-purchase'
        ELSE 'repeat-purchase'
        END AS customer_type,
        SUM(total_revenue) AS total_sales
FROM customer_revenue
GROUP BY customer_type
;



-- Which categories or sellers show volatile or declining performance over time?


WITH monthly_perf AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        p.category,
        SUM(o.total_amount) AS monthly_revenue
    FROM E_COMMERCE.orders o
    JOIN E_COMMERCE.order_items oi 
        ON o.order_id = oi.order_id
    JOIN E_COMMERCE.products p 
        ON oi.product_id = p.product_id
    GROUP BY month, p.category
)

SELECT
    category,
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (PARTITION BY category ORDER BY month) AS prev_month_revenue,
    (monthly_revenue - LAG(monthly_revenue) OVER (PARTITION BY category ORDER BY month)) 
    / LAG(monthly_revenue) OVER (PARTITION BY category ORDER BY month) 
    AS growth_rate
FROM monthly_perf;

-- define volatility

WITH monthly_perf AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        p.category,
        SUM(o.total_amount) AS monthly_revenue
    FROM E_COMMERCE.orders o
    JOIN E_COMMERCE.order_items oi 
        ON o.order_id = oi.order_id
    JOIN E_COMMERCE.products p 
        ON oi.product_id = p.product_id
    GROUP BY month, p.category
)



SELECT 
    category,
    STDDEV(monthly_revenue) AS volatility
FROM monthly_perf
GROUP BY category
ORDER BY volatility DESC;


-- BATAS


-- How has total revenue and order volume evolved over time (monthly)?

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS order_month, 
SUM(oi.quantity * oi.item_price) AS total_revenue, 
COUNT(DISTINCT oi.order_id) AS total_order
FROM E_COMMERCE.orders o
INNER JOIN E_COMMERCE.order_items oi
ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY order_month
;

-- Which product categories contribute the most to total revenue?
SELECT p.category AS product_category, SUM(oi.item_price * oi.quantity) AS total_revenue
FROM E_COMMERCE.products p
INNER JOIN E_COMMERCE.order_items oi
ON p.product_id = oi.product_id
INNER JOIN E_COMMERCE.orders o
ON oi.order_id = o.order_id
GROUP BY product_category
ORDER BY total_revenue DESC
;

-- Who are the top customers by total revenue contribution?
SELECT user_id, SUM(total_amount) AS total_revenue
FROM E_COMMERCE.orders o
INNER JOIN E_COMMERCE.order_items oi
ON o.order_id = oi.order_id
GROUP BY user_id
ORDER BY total_revenue DESC
LIMIT 10
;


-- How concentrated is revenue among customers (e.g., top 10% vs the rest)?

WITH customer_revenue AS (
SELECT user_id,
	SUM(total_amount) AS total_revenue
FROM E_COMMERCE.orders o
INNER JOIN E_COMMERCE.order_items oi
ON o.order_id = oi.order_id
GROUP BY user_id
),
ranked AS (
SELECT user_id,
total_revenue,
	NTILE(10) OVER (ORDER BY total_revenue DESC) AS revenue_decile
FROM customer_revenue
)

SELECT 
CASE
	WHEN revenue_decile = 1 THEN 'top-10%'
    ELSE 'bottom-90%'
    END AS customer_category,
    ROUND(SUM(total_revenue), 2) AS revenue
FROM ranked
GROUP BY customer_category
;


-- who are the customers who contributed to top 10%?

WITH customer_revenue AS (
SELECT user_id,
SUM(total_amount) AS total_revenue
FROM E_COMMERCE.orders o
INNER JOIN E_COMMERCE.order_items oi
ON o.order_id = oi.order_id
GROUP BY user_id
),
ranked as (
SELECT user_id,
total_revenue,
PERCENT_RANK() OVER(ORDER BY total_revenue DESC) AS percentile
FROM customer_revenue)

SELECT *
FROM ranked
WHERE percentile <= 0.1
;

-- Which sellers generate the highest revenue?

SELECT s.seller_id AS seller, SUM(oi.item_price * oi.quantity) AS total_revenue
FROM E_COMMERCE.sellers s
INNER JOIN E_COMMERCE.products p
ON s.seller_id = p.seller_id
INNER JOIN E_COMMERCE.order_items oi
ON p.product_id = oi.product_id
INNER JOIN E_COMMERCE.orders o
ON oi.order_id = o.order_id
GROUP BY seller
ORDER BY total_revenue DESC
LIMIT 10
;

-- Which products drive the highest sales volume and revenue?
WITH product_revenue AS(
SELECT oi.product_id, 
SUM(oi.quantity) AS quantity, 
SUM(oi.item_price * oi.quantity) AS total_revenue
FROM E_COMMERCE.orders o
INNER JOIN E_COMMERCE.order_items oi
ON o.order_id = oi.order_id
GROUP BY oi.product_id
)
SELECT *,
RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
RANK() OVER (ORDER BY quantity DESC) AS sales_rank
FROM product_revenue
;

-- Are sales driven more by repeat customers or one-time customers?

WITH customers AS (
SELECT user_id, SUM(oi.item_price * oi.quantity) AS total_revenue, COUNT(DISTINCT oi.order_id) AS total_order
FROM E_COMMERCE.orders o
INNER JOIN E_COMMERCE.order_items oi
ON o.order_id = oi.order_id
GROUP BY user_id
)

SELECT 
CASE 
	WHEN total_order < 2 THEN 'one-time-customer'
	ELSE 'repeat-customer'
	END AS customer_category,
SUM(total_revenue) AS revenue
FROM customers
GROUP BY customer_category
;

-- Which categories or sellers show volatile or declining performance over time?

WITH monthly_revenue AS(
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
	p.category,
    SUM(oi.item_price * oi.quantity) AS total_revenue
FROM E_COMMERCE.products p
INNER JOIN E_COMMERCE.order_items oi
ON p.product_id = oi.product_id
INNER JOIN E_COMMERCE.orders o
ON oi.order_id = o.order_id
GROUP BY month, p.category
),
revenue_with_lag AS (
SELECT month,
category,
total_revenue,
LAG(total_revenue) OVER (PARTITION BY category ORDER BY month) AS prev_month_revenue
FROM monthly_revenue
)

SELECT category,
	month,
    total_revenue,
    (total_revenue - prev_month_revenue) / NULLIF(prev_month_revenue, 0) AS growth_rate
FROM revenue_with_lag
;


-- Volatility

WITH monthly_revenue AS(
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
	p.category,
    SUM(oi.item_price * oi.quantity) AS total_revenue
FROM E_COMMERCE.products p
INNER JOIN E_COMMERCE.order_items oi
ON p.product_id = oi.product_id
INNER JOIN E_COMMERCE.orders o
ON oi.order_id = o.order_id
GROUP BY month, p.category
)

SELECT category,
	STDDEV(total_revenue) AS volatility
FROM monthly_revenue
GROUP BY category
ORDER BY volatility DESC
;