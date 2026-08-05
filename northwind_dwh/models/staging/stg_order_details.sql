SELECT
    order_id, 
    product_id, 
    unit_price, 
    quantity,
    discount, 
    CAST(unit_price * quantity * (1 - discount) AS DECIMAL(10,2)) AS sous_total
FROM {{ source('northwind', 'order_details') }}