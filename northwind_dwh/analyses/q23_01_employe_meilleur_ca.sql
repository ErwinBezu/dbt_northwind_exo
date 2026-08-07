SELECT
    full_name,
    ca_total
FROM {{ ref('mart_employee_performance') }}
WHERE ca_total = (SELECT MAX(ca_total)FROM {{ ref('mart_employee_performance') }})