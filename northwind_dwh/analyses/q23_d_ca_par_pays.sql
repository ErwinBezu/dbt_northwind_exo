SELECT
    d.country,
    COUNT(*) AS nb_commande,
    ROUND(SUM(f.montant_total_avec_frais)::NUMERIC, 2) AS ca_global,
    ROUND(AVG(montant_total)::NUMERIC, 2) AS panier_moyen,
    ROUND(
        (100.0 * SUM(f.montant_total_avec_frais)
            / NULLIF(SUM(SUM(f.montant_total_avec_frais)) OVER (), 0))::NUMERIC, 2) AS pct_ca_total,
    DENSE_RANK() OVER ( ORDER BY SUM(f.montant_total_avec_frais) DESC) AS rang
FROM {{ ref('fact_orders') }} f
JOIN {{ ref('dim_customers') }} d
    ON f.customer_id = d.customer_id
GROUP BY d.country
ORDER BY rang

