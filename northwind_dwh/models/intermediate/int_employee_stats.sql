SELECT
    employee_id,
    COUNT(*) AS nb_commandes_traitees, 
    ROUND(SUM(montant_total), 2) AS ca_total, 
-- Taux calculé seulement sur les commandes expédiées
    ROUND(
        SUM(is_on_time::int)::numeric / COUNT(is_on_time) * 100, 2
    ) as taux_livraison_a_temps,
    ROUND(AVG(delai_livraison_jours), 2) AS delai_moyen_livraison_jours
FROM {{ ref('int_orders_enriched') }}
GROUP BY employee_id