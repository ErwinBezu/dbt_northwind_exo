WITH stats_mensuelles AS (
    SELECT 
        d.annee_mois AS mois,
        ROUND(SUM(montant_total_avec_frais)::NUMERIC, 2) AS ca_mensuel
    FROM {{ ref('fact_orders') }} f
    JOIN {{ ref('dim_temps') }} d ON d.date_id = f.order_date
    GROUP BY d.annee_mois
),
comparaisons AS (
    SELECT *,
        LAG(ca_mensuel, 1) OVER (ORDER BY mois) AS ca_mois_precedent,
        LAG(ca_mensuel, 12) OVER (ORDER BY mois) AS ca_mois_annee_precedente
    FROM stats_mensuelles
)
SELECT *,
    ROUND((ca_mensuel - ca_mois_precedent)
        / NULLIF(ca_mois_precedent, 0) * 100, 1) AS variation_mois_precedent_pct,
    ROUND((ca_mensuel - ca_mois_annee_precedente)
        / NULLIF(ca_mois_annee_precedente, 0) * 100, 1) AS variation_annee_precedente_pct
FROM comparaisons ORDER BY mois