SELECT
    employee_id,
    CONCAT(TRIM(first_name), ' ', TRIM(last_name))::VARCHAR(32) AS full_name,
    TRIM(title)::VARCHAR(30) AS title, 
    hire_date,
    TRIM(city)::VARCHAR(15) AS city,
    TRIM(country)::VARCHAR(15) AS country
FROM {{ source('northwind', 'employees')}}