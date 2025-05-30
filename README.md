# DSA 2040A US 2025 LAB 2: OLTP + OLAP Integration - Progress Report

This document details the steps taken to implement and verify the OLTP and OLAP systems as per the lab requirements.

## Lab Manual Reference
The original lab manual and project overview can be found in `PROJECT_OVERVIEW.md`.

## Step 1: OLTP – Design the Transactional Database

**Objective:** Create `customers`, `products`, `stores`, and `transactions` tables.

**Verification:**
- Used `mcp0_list_tables` to confirm the existence and schema of all four OLTP tables.
- **Customers Table:**
  - Schema: `customer_id SERIAL PRIMARY KEY, name VARCHAR(100), email VARCHAR(100) UNIQUE, registered_date DATE`
  - Status: Matches lab manual.
- **Products Table:**
  - Schema: `product_id SERIAL PRIMARY KEY, name VARCHAR(100), category VARCHAR(50), price DECIMAL(10,2)`
  - Status: Matches lab manual.
- **Stores Table:**
  - Schema: `store_id SERIAL PRIMARY KEY, name VARCHAR(100), region VARCHAR(50)`
  - Status: Matches lab manual.
- **Transactions Table:**
  - Schema: `transaction_id SERIAL PRIMARY KEY, customer_id INT REFERENCES customers(customer_id), product_id INT REFERENCES products(product_id), store_id INT REFERENCES stores(store_id), quantity INT NOT NULL, transaction_date DATE NOT NULL`
  - Status: Matches lab manual.

**Conclusion:** Step 1 is COMPLETE.

## Step 2: Insert Sample Data

**Objective:** Populate OLTP tables with sample data.

**Verification:**
- Used `mcp0_execute_sql` with `SELECT COUNT(*)` for each OLTP table.
- Results:
  - `customers`: 10 rows
  - `products`: 10 rows
  - `stores`: 10 rows
  - `transactions`: 10 rows
- Lab manual specified 2 rows for each as minimal sample. Current data indicates more comprehensive data was inserted.

**Conclusion:** Step 2 is COMPLETE.

## Step 3: OLAP – Build the Data Warehouse (Star Schema)

**Objective:** Create `dim_date`, `dim_product`, `dim_store`, and `fact_sales` tables. A `dim_customer` table was also implemented.

**Verification:**
- Used `mcp0_list_tables` to confirm existence and schema of OLAP tables.
- **`dim_date`:** Contains `date_id` (PK), `full_date`, `day_of_week`, `day_of_month`, `month`, `quarter`, `year`.
- **`dim_product`:** Contains `product_id` (PK), `name`, `category`, `price`.
- **`dim_store`:** Contains `store_id` (PK), `name`, `region`.
- **`dim_customer`:** Contains `customer_id` (PK), `name`, `email`, `registered_date`. (Useful addition)
- **`fact_sales` Table:**
  - Lab Manual Schema: `product_id INT, store_id INT, date_id INT, quantity_sold INT, revenue DECIMAL(10,2)`
  - Actual Schema: `sales_id` (PK), `product_id` (FK), `store_id` (FK), `customer_id` (FK), `date_id` (FK), `quantity_sold INT`, `revenue NUMERIC`.
  - Status: Actual schema is more detailed (includes `sales_id`, `customer_id`) and aligns with best practices. Foreign keys are established.

**Conclusion:** Step 3 is COMPLETE.

## Step 4: ETL Process: From OLTP to OLAP

**Objective:** Populate OLAP tables using an ETL script.

**ETL Script (`etl_scripts/oltp_to_olap_etl.sql`):**

```sql
-- 1. Populate Date Dimension
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
```

**Verification:**
- Executed the ETL script using `mcp0_execute_sql`.
- Checked row counts for OLAP tables:
  - `dim_date`: 365 rows
  - `dim_product`: 10 rows
  - `dim_store`: 10 rows
  - `dim_customer`: 10 rows
  - `fact_sales`: 10 rows
- All counts align with OLTP data and ETL logic.

**Conclusion:** Step 4 is COMPLETE.

## Step 5: Run OLAP Analytical Queries

**Objective:** Generate insights from the data warehouse. Queries are stored in the `/queries/` directory.

**1. Monthly Sales Trends (`queries/monthly_sales_trends.sql`)**
   - **Query:**

```sql
     SELECT d.month, SUM(fs.revenue) AS total_revenue
     FROM fact_sales fs
     JOIN dim_date d ON fs.date_id = d.date_id
     GROUP BY d.month
     ORDER BY d.month;
```

- **Result:**

```json
     [{"month":5,"total_revenue":"3215.88"}]
```

- **Explanation:** All sales occurred in Month 5 (May) with a total revenue of 3215.88.

**2. Top Selling Products (`queries/top_selling_products.sql`)**
   - **Query:**

```sql
     SELECT dp.name, SUM(fs.quantity_sold) AS total_units
     FROM fact_sales fs
     JOIN dim_product dp ON fs.product_id = dp.product_id
     GROUP BY dp.name
     ORDER BY total_units DESC
     LIMIT 5;
```

- **Result:**

```json
     [{"name":"Backpack","total_units":3},{"name":"Jeans","total_units":2},{"name":"Watch","total_units":2},{"name":"Coffee Maker","total_units":2},{"name":"T-Shirt","total_units":2}]
```

- **Explanation:** "Backpack" is the top-selling product with 3 units. Other products follow with 2 units each.

**3. Regional Performance Analysis (`queries/regional_performance.sql`)**
   - **Query:**

```sql
     SELECT
         ds.region,
         SUM(fs.revenue) AS total_revenue,
         SUM(fs.quantity_sold) AS total_quantity_sold
     FROM
         fact_sales fs
     JOIN
         dim_store ds ON fs.store_id = ds.store_id
     GROUP BY
         ds.region
     ORDER BY
         total_revenue DESC;
```

- **Result:**

```json
     [{"region":"West","total_revenue":"1298.96","total_quantity_sold":5},{"region":"South","total_revenue":"1098.98","total_quantity_sold":3},{"region":"East","total_revenue":"588.95","total_quantity_sold":6},{"region":"North","total_revenue":"228.99","total_quantity_sold":2}]
```

- **Explanation:** The "West" region has the highest revenue. The "East" region sold the most units but generated less revenue, suggesting sales of lower-priced items.

**Conclusion:** Step 5 is COMPLETE.

## Step 6: Final Discussion

This step involves reflecting on the OLTP/OLAP differences, challenges, and automation.

**Reflection Questions:**
1. Why is the OLTP system normalized and the OLAP system denormalized?

   *   **OLTP (Online Transaction Processing) systems are normalized (typically to 3NF) for several key reasons:**
       *   **Data Integrity and Consistency:** Normalization reduces data redundancy by ensuring that each piece of data is stored in only one place. This minimizes the risk of inconsistencies that can arise when updating or deleting data. For example, a customer's address is stored once in the `customers` table, not repeated for every transaction they make.
       *   **Efficient Data Modification:** Operations like `INSERT`, `UPDATE`, and `DELETE` are faster and simpler on normalized tables. Changes to a piece of data (e.g., updating a customer's email) only need to happen in one location.
       *   **Space Optimization:** By reducing redundancy, normalization can save storage space, although this is less of a concern with modern storage costs.
       *   **Focus on Transactions:** OLTP systems are designed for a high volume of short, fast transactions (e.g., recording a sale, updating inventory). Normalization supports this by making these atomic operations efficient.

   *   **OLAP (Online Analytical Processing) systems are denormalized (often using a star or snowflake schema) primarily for:**
       *   **Query Performance:** Analytical queries often involve joining many tables to aggregate and summarize large volumes of data (e.g., "total sales by product category and region over the last quarter"). Denormalization pre-joins some of this data into wider dimension tables and fact tables. This reduces the number of complex joins needed at query time, making queries significantly faster.
       *   **Simplicity for Reporting and Analysis:** Denormalized structures are often more intuitive for business users and analysts to understand and query. Attributes are grouped together in dimensions (e.g., all product details in `dim_product`), making it easier to slice and dice data.
       *   **Read-Heavy Workloads:** OLAP systems are optimized for read-heavy workloads (complex queries) rather than frequent writes. The overhead of updating denormalized data (which might involve updating redundant data) is acceptable because updates (ETL loads) are typically done in batches during off-peak hours.
2. What challenges would you face if you ran analytical queries directly on the OLTP system?

   *   **Performance Degradation:** OLTP systems are optimized for quick, transactional operations, not for complex analytical queries that scan and aggregate large datasets. Running resource-intensive analytical queries directly on an OLTP system can severely degrade its performance, slowing down critical business operations (e.g., processing sales, customer lookups). This can lead to a poor user experience and even lost revenue.
   *   **Complex Query Writing:** Due to the normalized structure of OLTP databases, analytical queries would require numerous complex joins across many tables. This makes the queries difficult to write, debug, and maintain. It also increases the chance of errors in the query logic.
   *   **Contention and Locking:** Analytical queries often require long-running read locks on tables. These locks can conflict with the short-lived write locks needed by ongoing transactions, leading to deadlocks or increased transaction latency. This contention can bring operational processes to a halt.
   *   **Data Structure Not Optimized for Analysis:** Normalized tables are not structured for the typical "slice and dice" or drill-down operations common in analytics. OLTP schemas lack pre-aggregated data or a dimensional structure, making it harder to get summarized views or historical trends efficiently.
   *   **Impact on System Stability:** The heavy load from analytical queries can strain the OLTP database server's resources (CPU, memory, I/O), potentially leading to system instability or crashes, which is unacceptable for an operational system.
   *   **Limited Historical Data:** OLTP systems often store only current or recent operational data to maintain performance. They might not retain the extensive historical data typically required for trend analysis and other analytical tasks. Data warehouses (OLAP systems) are specifically designed to accumulate and store this historical data.
3. How can automation (e.g., scheduled ETL jobs) help in a real-world data pipeline?

   Automation, particularly through scheduled ETL (Extract, Transform, Load) jobs, is crucial for the efficiency, reliability, and timeliness of a real-world data pipeline. Here's how it helps:

   *   **Consistency and Reliability:** Automated ETL processes run consistently according to a predefined schedule (e.g., nightly, hourly). This eliminates the variability and potential for human error associated with manual execution, ensuring that the data warehouse is updated regularly and reliably.
   *   **Timeliness of Data:** Scheduled jobs ensure that fresh data from the OLTP system is regularly moved to the OLAP system. This provides business users and analysts with up-to-date information for decision-making. The frequency of scheduling can be adjusted based on business needs (e.g., near real-time updates for critical dashboards vs. nightly updates for general reporting).
   *   **Reduced Manual Effort and Cost:** Automating the ETL process significantly reduces the manual effort required to extract, transform, and load data. This frees up data engineers and IT staff to focus on more strategic tasks, such as developing new data products, optimizing queries, or improving data quality, rather than repetitive manual data handling. This also translates to cost savings.
   *   **Scalability:** As data volumes grow, automated ETL pipelines can be more easily scaled to handle the increased load. Automation tools often provide features for parallel processing and resource management that are difficult to achieve with manual processes.
   *   **Improved Data Quality:** Automated ETL jobs can incorporate data validation and cleansing steps. This helps in identifying and handling data quality issues (e.g., missing values, incorrect formats) systematically before the data is loaded into the data warehouse, leading to more trustworthy analytical results.
   *   **Error Handling and Monitoring:** Automated ETL tools usually come with robust logging, monitoring, and alerting capabilities. If a job fails or encounters an issue, notifications can be sent out immediately, allowing for quick troubleshooting and resolution. This proactive approach minimizes data pipeline downtime.
   *   **Off-Peak Processing:** ETL jobs are often resource-intensive. Scheduling them to run during off-peak hours (e.g., overnight) minimizes their impact on the source OLTP systems and network resources, ensuring that operational systems remain performant during business hours.
   *   **Process Standardization:** Automation enforces a standardized approach to data integration. The ETL logic is defined once and executed repeatedly, ensuring that the same business rules and transformations are applied consistently every time.