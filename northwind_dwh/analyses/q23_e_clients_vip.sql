WITH client_ca AS (
    SELECT
        f.customer_id,
        d.company_name,
        SUM(f.montant_total_avec_frais) OVER(PARTITION BY f.customer_id) AS ca_client,
        ROUND((SUM(f.montant_total_avec_frais) OVER(PARTITION BY f.customer_id) 
            / SUM(f.montant_total_avec_frais) OVER() * 100)::NUMERIC, 1) as pct_ca
    FROM {{ ref('fact_orders') }} f
    JOIN {{ ref('dim_customers') }} d ON f.customer_id = d.customer_id
)
SELECT DISTINCT
    customer_id, 
    company_name,
    ca_client,
    pct_ca
FROM client_ca 
WHERE pct_ca > 2 ORDER BY pct_ca DESC