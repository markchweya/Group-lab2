# DSA 2040A US 2025 LAB 2: OLTP + OLAP Integration

## Project Overview

This project simulates a real-world retail data management system by implementing both Online Transaction Processing (OLTP) and Online Analytical Processing (OLAP) databases. The integration demonstrates how businesses handle day-to-day operations while also supporting data analytics.

## Objectives

- Design a normalized OLTP database schema for daily retail operations
- Build a denormalized OLAP star schema optimized for analytical queries
- Develop ETL (Extract, Transform, Load) processes to migrate data from OLTP to OLAP
- Run analytical queries to generate business insights

## System Architecture

### 1. OLTP System (Operational Database)

The OLTP database handles day-to-day business transactions and is designed for:
- Fast and reliable transaction processing
- Data consistency and integrity
- Normalized structure to minimize redundancy

**Tables:**
- `customers` - Customer information
- `products` - Product catalog
- `stores` - Store locations and regions
- `transactions` - Sales transactions

### 2. OLAP System (Data Warehouse)

The OLAP star schema is optimized for complex analytical queries and reporting:
- Denormalized structure for query performance
- Dimensional modeling (star schema)
- Pre-calculated aggregates

**Tables:**
- `dim_date` - Date dimension
- `dim_product` - Product dimension
- `dim_store` - Store dimension
- `fact_sales` - Sales facts

### 3. ETL Process

The ETL process connects the OLTP and OLAP systems by:
- Extracting transaction data from the OLTP database
- Transforming it to fit the dimensional model
- Loading it into the OLAP star schema
- Calculating derived values like revenue

## Project Structure

```
/oltp_schema/       -- Contains OLTP creation scripts
/olap_schema/       -- Contains star schema SQL
/etl_scripts/       -- SQL to perform ETL
/sample_data/       -- Optional CSVs for seeding
/queries/           -- Analytical queries
README.md           -- This document
```

## Implementation Steps

1. **Set up OLTP Database**: Create normalized tables for customers, products, stores, and transactions
2. **Insert Sample Data**: Populate OLTP tables with test data
3. **Create OLAP Star Schema**: Build dimension and fact tables
4. **Implement ETL Process**: Transfer and transform data from OLTP to OLAP
5. **Run Analytical Queries**: Generate insights from the data warehouse

## Key Concepts

- **Database Normalization vs. Denormalization**: OLTP uses normalization for data integrity, while OLAP uses denormalization for query performance.
- **Dimensional Modeling**: Using facts and dimensions to structure data for analysis.
- **ETL Processing**: The pipeline that moves data between operational and analytical systems.
- **Business Intelligence**: Generating actionable insights from structured data.

## Technologies Used

- PostgreSQL (Supabase)
- SQL for database operations and ETL
- Git for version control

## Analysis Examples

The project includes analytical queries that demonstrate:
- Monthly sales trends
- Top-selling products
- Regional performance analysis
- Customer purchase patterns
