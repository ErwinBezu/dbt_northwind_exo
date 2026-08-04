SELECT
    employee_id,
    CAST(CONCAT(TRIM(first_name), ' ', TRIM(last_name))AS VARCHAR(32)) AS full_name,
    CAST(TRIM(title) AS VARCHAR(30)) AS title, 
    hire_date,
    CAST(TRIM(city) AS VARCHAR(15)) AS city,
    CAST(TRIM(country) AS VARCHAR(15)) AS country
FROM {{ source('northwind', 'employees')}}