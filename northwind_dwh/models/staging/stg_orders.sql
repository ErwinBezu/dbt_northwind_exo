SELECT
    order_id,
    customer_id,
    employee_id,
    ship_via,
    order_date,
    required_date,
    shipped_date,
    ship_city,
    ship_country,
    freight,
    shipped_date IS NOT NULL AS is_shipped
FROM {{ source('northwind', 'orders') }}