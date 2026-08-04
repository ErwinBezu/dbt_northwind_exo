WITH commandes_clients AS (
    SELECT
        customer_id, 
        order_id, 
        order_date, 
        montant_total,
        LAG(order_date) OVER(
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS date_commande_precedente
    FROM {{ ref('int_orders_enriched') }}
)
SELECT
    customer_id,
    COUNT(*) AS nb_commandes, 
    ROUND(SUM(montant_total), 2) AS ca_total, 
    MIN(order_date) AS date_premiere_commande, 
    MAX(order_date) AS date_derniere_commande, 
    ROUND(AVG(order_date - date_commande_precedente), 2) AS delai_moyen_entre_commandes
FROM commandes_clients
GROUP BY customer_id