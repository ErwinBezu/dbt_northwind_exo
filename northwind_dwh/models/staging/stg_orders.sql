-- J'ai fait le choix de tout retyper même si le type ne change pas. 

SELECT
    CAST(order_id AS SMALLINT) AS order_id,
    CAST(customer_id AS VARCHAR(5)) AS customer_id,
    CAST(employee_id AS SMALLINT) AS employee_id,
    CAST(order_date AS DATE) AS order_date,
    CAST(required_date AS DATE) AS required_date,
    CAST(shipped_date AS DATE) AS shipped_date,
    CAST(ship_via AS SMALLINT) AS ship_via,
    CAST(freight AS REAL) AS freight,
    CAST(ship_name AS VARCHAR(40)) AS ship_name,
    CAST(ship_address AS VARCHAR(40)) AS ship_adresse, 
    CAST(ship_city AS VARCHAR(15)) AS ship_city,
    CAST(ship_region AS VARCHAR(15)) AS ship_region,
    CAST(ship_postal_code AS VARCHAR(10)) AS ship_postal_code,
    CAST(ship_country AS VARCHAR(15)) AS ship_country,
    shipped_date IS NOT NULL AS is_shipped
FROM {{ source('northwind', 'orders') }};