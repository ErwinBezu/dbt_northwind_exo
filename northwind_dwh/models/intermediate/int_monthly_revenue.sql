WITH stats_mensuelles AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS mois,
        COUNT(*) AS nb_commandes,
        ROUND(SUM(montant_total), 2) AS ca_mensuel,
        ROUND(AVG(montant_total), 2) AS panier_moyen
    FROM {{ ref('int_orders_enriched')}}
    GROUP BY mois
)
SELECT
    mois,
    nb_commandes, 
    ca_mensuel, 
    panier_moyen,
    LAG(ca_mensuel, 1, 0) OVER (ORDER BY mois) as ca_mois_precedent,
    ROUND((ca_mensuel - LAG(ca_mensuel, 1, ca_mensuel) OVER(ORDER BY mois))
        / NULLIF(LAG(ca_mensuel, 1, ca_mensuel)OVER(ORDER BY mois), 0)* 100 , 1) AS variation_pct 
FROM stats_mensuelles
ORDER BY mois