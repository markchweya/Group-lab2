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
