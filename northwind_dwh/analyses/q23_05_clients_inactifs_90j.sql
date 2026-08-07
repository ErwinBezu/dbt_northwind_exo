SELECT
    c.company_name,
    cs.date_derniere_commande
FROM {{ ref('dim_customers') }} c
JOIN {{ ref('int_customers_stats') }} cs
    ON c.customer_id = cs.customer_id
WHERE cs.date_derniere_commande IS NULL
   OR cs.date_derniere_commande < (SELECT MAX(order_date)FROM {{ ref('fact_orders') }}) - INTERVAL '90 days'
ORDER BY cs.date_derniere_commande