SELECT
    supplier_id,
    TRIM(company_name) AS company_name,
    INITCAP(TRIM(contact_name)) AS contact_name,
    INITCAP(TRIM(contact_title)) AS contact_title,
    TRIM(address) AS address,
    INITCAP(TRIM(city)) AS city,
    TRIM(region) AS region, 
    TRIM(postal_code) AS postal_code,
    TRIM(country) AS country,
FROM {{ source('northwind', 'suppliers')}};
