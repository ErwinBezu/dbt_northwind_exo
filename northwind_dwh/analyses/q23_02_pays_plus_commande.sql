WITH commandes_par_pays AS (
    SELECT
        c.country,
        COUNT(f.order_id) AS nb_commandes
    FROM {{ ref('fact_orders') }} f
    JOIN {{ ref('dim_customers') }} c
        ON f.customer_id = c.customer_id
    GROUP BY c.country
)
SELECT
    country,
    nb_commandes
FROM commandes_par_pays
WHERE nb_commandes = (SELECT MAX(nb_commandes)FROM commandes_par_pays)