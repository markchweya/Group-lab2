-- OLTP Schema: Transactional Database for Retail Operations

-- customers table - Stores customer information
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    registered_date DATE
);

-- products table - Holds product catalog
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- stores table - Contains store details
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(50)
);

-- transactions table - Records sales activity
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    store_id INT REFERENCES stores(store_id),
    quantity INT NOT NULL,
    transaction_date DATE NOT NULL
);

-- Comments explaining the OLTP design choices:
-- 1. Normalized structure to minimize redundancy
-- 2. Foreign key constraints to maintain referential integrity
-- 3. Primary keys for efficient indexing and lookups
-- 4. Appropriate data types chosen for each column
