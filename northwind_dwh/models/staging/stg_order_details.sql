SELECT
    order_id, 
    product_id, 
    unit_price, 
    quantity,
    discount, 
    unit_price * quantity * (1 - discount) AS sous_total
FROM {{ source('northwind', 'order_details') }};