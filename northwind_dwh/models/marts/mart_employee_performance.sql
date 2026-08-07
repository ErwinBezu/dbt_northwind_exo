WITH agregats_employes AS (
    SELECT
        e.employee_id,
        e.full_name,
        e.title,
        e.country,
        COALESCE(ROUND(SUM(f.montant_total_avec_frais)::NUMERIC, 2), 0) AS ca_total,
        COUNT(f.order_id)::SMALLINT AS nb_commandes,
        COALESCE(ROUND(AVG(f.montant_total_avec_frais)::NUMERIC, 2), 0) AS panier_moyen,
        ROUND( 100.0 * COUNT(f.order_id) FILTER (WHERE f.shipped_date <= f.required_date)
            / NULLIF(COUNT(f.order_id) FILTER (WHERE f.shipped_date IS NOT NULL), 0), 2) AS taux_livraison_a_temps,
        ROUND(AVG(f.shipped_date- f.order_date), 2) AS delai_moyen_jours
    FROM {{ ref('dim_employees') }} e
    LEFT JOIN {{ ref('fact_orders') }} f
        ON e.employee_id = f.employee_id
    GROUP BY
        e.employee_id,
        e.full_name,
        e.title,
        e.country
)
SELECT
    employee_id,
    full_name,
    title,
    country,
    ca_total,
    nb_commandes,
    panier_moyen,
    taux_livraison_a_temps,
    delai_moyen_jours,
    RANK() OVER (ORDER BY ca_total DESC)::SMALLINT AS rang,
    ROUND(100.0 * ca_total / NULLIF(SUM(ca_total) OVER (), 0), 2) AS pct_ca_total
FROM agregats_employes