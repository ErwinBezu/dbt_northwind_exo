SELECT 
    customer_id, 
    TRIM(company_name)::VARCHAR(40) AS company_name,
    INITCAP(TRIM(contact_name))::VARCHAR(30) AS contact_name,
    INITCAP(TRIM(contact_title))::VARCHAR(30) AS contact_title,
    INITCAP(TRIM(city))::VARCHAR(15) AS city,
    TRIM(country)::VARCHAR(15) AS country, 
    TRIM(phone)::VARCHAR(24) AS phone
FROM {{ source('northwind', 'customers') }}