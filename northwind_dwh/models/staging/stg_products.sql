SELECT
    product_id,
    product_name,
    supplier_id, 
    category_id,
    unit_price,
    units_in_stock,
    units_on_order,
    discontinued, 
    units_in_stock > 0 AS en_stock
FROM {{ source('northwind', 'products')}}