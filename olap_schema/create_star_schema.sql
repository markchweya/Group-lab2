-- OLAP Star Schema: Dimensional model for analytical processing

-- Date Dimension
CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- Product Dimension
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Store Dimension
CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL
);

-- Customer Dimension (additional dimension for customer analysis)
CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    registered_date DATE NOT NULL
);

-- Sales Fact Table
CREATE TABLE fact_sales (
    sales_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES dim_product(product_id),
    store_id INT REFERENCES dim_store(store_id),
    customer_id INT REFERENCES dim_customer(customer_id),
    date_id INT REFERENCES dim_date(date_id),
    quantity_sold INT NOT NULL,
    revenue DECIMAL(10,2) NOT NULL
);

-- Comments explaining the OLAP design choices:
-- 1. Denormalized structure optimized for analytical queries
-- 2. Dimension tables provide descriptive attributes
-- 3. Fact table contains measures (quantity sold, revenue)
-- 4. Star schema design with fact table at center connected to dimensions
-- 5. Pre-calculated revenue measure to improve query performance
