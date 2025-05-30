SELECT d.month, SUM(fs.revenue) AS total_revenue
FROM fact_sales fs
JOIN dim_date d ON fs.date_id = d.date_id
GROUP BY d.month
ORDER BY d.month;
