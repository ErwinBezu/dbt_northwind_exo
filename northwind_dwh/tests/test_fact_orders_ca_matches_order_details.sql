WITH ca_source_par_commande AS (
    SELECT
        order_id,
        ROUND(SUM(ROUND((unit_price * quantity * (1 - discount))::NUMERIC, 2)), 2) AS montant_total
    FROM {{ source('northwind', 'order_details') }}
    GROUP BY order_id
),
ca_source AS (
    SELECT ROUND(SUM(montant_total), 2) AS ca_total FROM ca_source_par_commande
),
ca_fact AS (
    SELECT ROUND(SUM(montant_total), 2) AS ca_total FROM {{ ref('fact_orders') }}
)
SELECT
    cs.ca_total AS ca_source,
    cf.ca_total AS ca_fact
FROM ca_source cs, ca_fact cf
WHERE cs.ca_total != cf.ca_total