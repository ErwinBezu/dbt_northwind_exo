SELECT
    f.employee_id
FROM {{ ref('fact_orders') }} f
LEFT JOIN {{ ref('dim_employees') }} d ON f.employee_id = d.employee_id
WHERE d.employee_id IS NULL