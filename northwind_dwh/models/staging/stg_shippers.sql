SELECT
    shipper_id,
    TRIM(company_name)::VARCHAR(40) AS company_name,
    TRIM(phone)::VARCHAR(24) AS phone
FROM {{ source('northwind', 'shippers') }}