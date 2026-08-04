SELECT
    order_id,
    customer_id,
    employee_id,
    order_date,
    required_date,
    shipped_date,
    ship_via,
    freight,
    ship_name,
    ship_adresse, 
    ship_city,
    ship_region,
    ship_postal_code,
    ship_country,
    shipped_date IS NOT NULL AS is_shipped
FROM {{ source('northwind', 'orders') }};