SELECT
    shipper_id,
    TRIM(company_name) AS company_name,
    TRIM(phone) AS phone
FROM {{ source('northwind', 'shippers') }};