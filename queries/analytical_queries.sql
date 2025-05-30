-- Analytical Queries for Business Intelligence

-- 1. Monthly Sales Trends
-- This query shows total revenue by month to identify sales patterns
SELECT 
    d.month, 
    d.month_name, 
    SUM(fs.revenue) AS total_revenue,
    COUNT(fs.sales_id) AS transaction_count
FROM 
    fact_sales fs
JOIN 
    dim_date d ON fs.date_id = d.date_id
GROUP BY 
    d.month, d.month_name
ORDER BY 
    d.month;

-- 2. Top Selling Products by Quantity
-- Identifies the most popular products by quantity sold
SELECT 
    dp.name, 
    dp.category, 
    SUM(fs.quantity_sold) AS total_units_sold,
    SUM(fs.revenue) AS total_revenue
FROM 
    fact_sales fs
JOIN 
    dim_product dp ON fs.product_id = dp.product_id
GROUP BY 
    dp.name, dp.category
ORDER BY 
    total_units_sold DESC
LIMIT 5;

-- 3. Regional Performance Analysis
-- Compares sales performance across different regions
SELECT 
    ds.region, 
    SUM(fs.revenue) AS total_revenue,
    COUNT(DISTINCT fs.customer_id) AS unique_customers,
    SUM(fs.quantity_sold) AS units_sold
FROM 
    fact_sales fs
JOIN 
    dim_store ds ON fs.store_id = ds.store_id
GROUP BY 
    ds.region
ORDER BY 
    total_revenue DESC;

-- 4. Product Category Analysis
-- Analyzes sales performance by product category
SELECT 
    dp.category, 
    COUNT(DISTINCT fs.product_id) AS unique_products,
    SUM(fs.quantity_sold) AS total_units_sold,
    SUM(fs.revenue) AS total_revenue,
    AVG(fs.revenue / fs.quantity_sold) AS average_unit_price
FROM 
    fact_sales fs
JOIN 
    dim_product dp ON fs.product_id = dp.product_id
GROUP BY 
    dp.category
ORDER BY 
    total_revenue DESC;

-- 5. Customer Purchase Patterns by Day of Week
-- Identifies which days of the week generate the most sales
SELECT 
    d.day_name, 
    COUNT(fs.sales_id) AS transaction_count,
    SUM(fs.quantity_sold) AS total_units_sold,
    SUM(fs.revenue) AS total_revenue,
    AVG(fs.quantity_sold) AS avg_basket_size
FROM 
    fact_sales fs
JOIN 
    dim_date d ON fs.date_id = d.date_id
GROUP BY 
    d.day_name, d.day_of_week
ORDER BY 
    d.day_of_week;

-- 6. Customer Segmentation by Purchase Value
-- Segments customers based on their total spending
WITH customer_spending AS (
    SELECT 
        fs.customer_id, 
        SUM(fs.revenue) AS total_spent
    FROM 
        fact_sales fs
    GROUP BY 
        fs.customer_id
)
SELECT 
    CASE 
        WHEN cs.total_spent >= 1000 THEN 'High Value' 
        WHEN cs.total_spent >= 500 THEN 'Medium Value' 
        ELSE 'Low Value' 
    END AS customer_segment,
    COUNT(cs.customer_id) AS customer_count,
    AVG(cs.total_spent) AS avg_spending,
    SUM(cs.total_spent) AS total_revenue
FROM 
    customer_spending cs
JOIN 
    dim_customer dc ON cs.customer_id = dc.customer_id
GROUP BY 
    customer_segment
ORDER BY 
    avg_spending DESC;

-- 7. Sales Trend Analysis by Quarter
-- Examines quarterly sales trends
SELECT 
    d.year,
    d.quarter, 
    SUM(fs.revenue) AS quarterly_revenue,
    COUNT(fs.sales_id) AS transaction_count,
    SUM(fs.quantity_sold) AS total_units_sold
FROM 
    fact_sales fs
JOIN 
    dim_date d ON fs.date_id = d.date_id
GROUP BY 
    d.year, d.quarter
ORDER BY 
    d.year, d.quarter;
