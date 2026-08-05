WITH commandes_avec_precedente AS (
    SELECT
        customer_id,
        order_date, 
        montant_total,
        LAG(order_date) OVER(
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS date_commande_precedente
    FROM {{ ref('int_orders_enriched') }}
),
stats_clients AS (
    SELECT
        customer_id, 
        COUNT(*) AS nb_commandes,
        ROUND(SUM(montant_total), 2) AS ca_total, 
        MIN(order_date) AS date_premiere_commande, 
        MAX(order_date) AS date_derniere_commande, 
        ROUND(AVG(order_date - date_commande_precedente), 2) AS delai_moyen_entre_commandes 
    FROM commandes_avec_precedente
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    COALESCE(sc.nb_commandes, 0) AS nb_commandes,
    COALESCE(sc.ca_total, 0) AS ca_total,
    sc.date_premiere_commande,
    sc.date_derniere_commande,
    sc.delai_moyen_entre_commandes
FROM {{ ref('stg_customers') }} c
LEFT JOIN stats_clients sc
    ON c.customer_id = sc.customer_id