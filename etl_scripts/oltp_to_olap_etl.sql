-- ETL Scripts: Moving data from OLTP to OLAP star schema

-- 1. Populate Date Dimension
-- This script generates a date dimension table with dates from 2025-01-01 to 2025-12-31
INSERT INTO dim_date (full_date, day, month, month_name, quarter, year, day_of_week, day_name, is_weekend)
SELECT
  date::date AS full_date,
  EXTRACT(DAY FROM date) AS day,
  EXTRACT(MONTH FROM date) AS month,
  TO_CHAR(date, 'Month') AS month_name,
  EXTRACT(QUARTER FROM date) AS quarter,
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(DOW FROM date) AS day_of_week,
  TO_CHAR(date, 'Day') AS day_name,
  CASE WHEN EXTRACT(DOW FROM date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
FROM generate_series(
  '2025-01-01'::timestamp,
  '2025-12-31'::timestamp,
  '1 day'::interval
) AS date;

-- 2. Populate Product Dimension
INSERT INTO dim_product (product_id, name, category, price)
SELECT product_id, name, category, price
FROM products;

-- 3. Populate Store Dimension
INSERT INTO dim_store (store_id, name, region)
SELECT store_id, name, region
FROM stores;

-- 4. Populate Customer Dimension
INSERT INTO dim_customer (customer_id, name, registered_date)
SELECT customer_id, name, registered_date
FROM customers;

-- 5. Populate Sales Fact Table
INSERT INTO fact_sales (product_id, store_id, customer_id, date_id, quantity_sold, revenue)
SELECT 
  t.product_id,
  t.store_id,
  t.customer_id,
  d.date_id,
  t.quantity AS quantity_sold,
  t.quantity * p.price AS revenue
FROM 
  transactions t
JOIN 
  products p ON t.product_id = p.product_id
JOIN 
  dim_date d ON t.transaction_date = d.full_date;

-- Comments explaining the ETL process:
-- 1. Dimensional tables are populated first
-- 2. Date dimension is pre-populated with all dates for the year
-- 3. Product, store, and customer dimensions are direct copies of OLTP tables
-- 4. Fact table joins transactions with products to calculate revenue
-- 5. Date dimension is joined to transaction_date to link to date_id
-- 6. This ETL script would typically be scheduled to run periodically
