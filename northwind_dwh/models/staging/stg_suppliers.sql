SELECT
    supplier_id,
    CAST(TRIM(company_name) AS VARCHAR(40)) AS company_name,
    CAST(INITCAP(TRIM(contact_name)) AS VARCHAR(30)) AS contact_name,
    CAST(INITCAP(TRIM(city)) AS VARCHAR(15)) AS city,
    CAST(TRIM(country) AS VARCHAR(15)) AS country,
    CAST(TRIM(phone) AS VARCHAR(24)) AS phone
FROM {{ source('northwind', 'suppliers')}}
