SELECT
    shipper_id,
    CAST(TRIM(company_name) AS VARCHAR(40)) AS company_name,
    CAST(TRIM(phone) AS VARCHAR(24)) AS phone
FROM {{ source('northwind', 'shippers') }}