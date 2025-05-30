SELECT dp.name, SUM(fs.quantity_sold) AS total_units
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
GROUP BY dp.name
ORDER BY total_units DESC
LIMIT 5;
