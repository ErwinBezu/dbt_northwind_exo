SELECT
    employee_id,
    CONCAT(TRIM(first_name), ' ', TRIM(last_name)) AS full_name,
    TRIM(title) AS title, 
    TRIM(title_of_courtesy) AS title_of_courtesy,
    birth_date, 
    hire_date,
    TRIM(city) AS cit
    TRIM(region) AS region, 
    TRIM(postal_code) AS postal_code,
    TRIM(country) AS country,
FROM {{ source('northwind', 'employees')}};