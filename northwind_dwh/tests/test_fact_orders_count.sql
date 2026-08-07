WITH nb_lignes_fact_orders AS (
    SELECT COUNT(*) AS nb_lignes FROM {{ ref('fact_orders') }}
),
nb_lignes_source_orders AS (
    SELECT COUNT(*) AS nb_lignes FROM {{ source('northwind', 'orders') }}
)
SELECT
    f.nb_lignes AS nb_fact_orders,
    s.nb_lignes AS nb_source_orders
FROM nb_lignes_fact_orders f, nb_lignes_source_orders s
WHERE f.nb_lignes != s.nb_lignes