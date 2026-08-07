SELECT
    f.order_date
FROM {{ ref('fact_orders') }} f
LEFT JOIN {{ ref('dim_temps') }} d ON f.order_date = d.date_id
WHERE d.date_id IS NULL