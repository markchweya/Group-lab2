-- Sample Data Insertion for OLTP Database

-- Customers
INSERT INTO customers (name, email, registered_date) VALUES
('Alice Smith', 'alice@example.com', '2025-01-10'),
('Bob Brown', 'bob@example.com', '2025-02-01'),
('Charlie Davis', 'charlie@example.com', '2025-02-15'),
('Diana Evans', 'diana@example.com', '2025-03-01'),
('Edward Frank', 'edward@example.com', '2025-03-10'),
('Fiona Grant', 'fiona@example.com', '2025-03-22'),
('George Harris', 'george@example.com', '2025-04-05'),
('Hannah Irving', 'hannah@example.com', '2025-04-12'),
('Ian Johnson', 'ian@example.com', '2025-04-25'),
('Julia Knight', 'julia@example.com', '2025-05-01');

-- Products
INSERT INTO products (name, category, price) VALUES
('T-Shirt', 'Apparel', 19.99),
('Laptop', 'Electronics', 999.00),
('Coffee Maker', 'Home Appliances', 89.99),
('Running Shoes', 'Footwear', 79.95),
('Smartphone', 'Electronics', 699.99),
('Winter Jacket', 'Apparel', 149.95),
('Blender', 'Home Appliances', 49.99),
('Desk Chair', 'Furniture', 129.99),
('Gaming Console', 'Electronics', 349.99),
('Headphones', 'Electronics', 89.95);

-- Stores
INSERT INTO stores (name, region) VALUES
('Downtown Store', 'East'),
('Mall Outlet', 'West'),
('Plaza Shop', 'North'),
('Harbor Branch', 'South'),
('Central Megastore', 'Central');

-- Transactions
INSERT INTO transactions (customer_id, product_id, store_id, quantity, transaction_date) VALUES
(1, 1, 1, 2, '2025-05-01'),
(2, 2, 2, 1, '2025-05-03'),
(3, 3, 3, 1, '2025-05-04'),
(4, 4, 4, 2, '2025-05-05'),
(5, 5, 5, 1, '2025-05-06'),
(6, 6, 1, 1, '2025-05-07'),
(7, 7, 2, 2, '2025-05-08'),
(8, 8, 3, 1, '2025-05-09'),
(9, 9, 4, 1, '2025-05-10'),
(10, 10, 5, 3, '2025-05-11'),
(1, 3, 2, 1, '2025-05-12'),
(2, 5, 3, 1, '2025-05-13'),
(3, 7, 4, 2, '2025-05-14'),
(4, 9, 5, 1, '2025-05-15'),
(5, 2, 1, 1, '2025-05-16'),
(6, 4, 2, 2, '2025-05-17'),
(7, 6, 3, 1, '2025-05-18'),
(8, 8, 4, 1, '2025-05-19'),
(9, 10, 5, 2, '2025-05-20'),
(10, 1, 1, 3, '2025-05-21');
