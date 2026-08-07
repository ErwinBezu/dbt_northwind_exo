WITH delai_par_transporteur AS (
    SELECT
        s.shipper_id,
        s.company_name,
        ROUND(AVG(f.delai_livraison_jours), 2) AS delai_moyen_jours
    FROM {{ ref('fact_orders') }} f
    JOIN {{ ref('stg_shippers') }} s
        ON f.ship_via = s.shipper_id
    WHERE f.delai_livraison_jours IS NOT NULL
    GROUP BY
        s.shipper_id,
        s.company_name
)
SELECT
    company_name,
    delai_moyen_jours
FROM delai_par_transporteur
WHERE delai_moyen_jours = (SELECT MIN(delai_moyen_jours)FROM delai_par_transporteur)