SELECT
    order_id, 
    product_id, 
    unit_price, 
    quantity,
    discount, 
    ROUND((unit_price * quantity * (1 - discount))::NUMERIC, 2) AS sous_total
FROM {{ source('northwind', 'order_details') }}