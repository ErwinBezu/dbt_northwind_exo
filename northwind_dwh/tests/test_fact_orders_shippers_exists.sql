SELECT
    f.ship_via
FROM {{ ref('fact_orders') }} f
LEFT JOIN {{ ref('dim_shippers') }} d ON f.ship_via = d.shipper_id
WHERE d.shipper_id IS NULL