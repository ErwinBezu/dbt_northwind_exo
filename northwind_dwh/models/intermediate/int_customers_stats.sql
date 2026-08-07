WITH stats_clients AS (
    SELECT
        customer_id, 
        COUNT(*) AS nb_commandes,
        ROUND(SUM(montant_total), 2) AS ca_total, 
        MIN(order_date) AS date_premiere_commande, 
        MAX(order_date) AS date_derniere_commande, 
        ROUND((MAX(order_date) - MIN(order_date))
            / NULLIF(COUNT(*) - 1, 0), 2) AS delai_moyen_entre_commandes
    FROM {{ ref('int_orders_enriched') }}
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