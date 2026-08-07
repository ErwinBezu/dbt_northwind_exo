WITH order_details_aggregated AS (
    SELECT
        order_id,
        COUNT(*) AS nb_articles,
        SUM(quantity) AS quantite_totale,
        ROUND(SUM(sous_total), 2) AS montant_total
    FROM {{ ref('stg_order_details') }}
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    o.employee_id,
    o.ship_via,
    o.order_date,
    o.required_date,
    o.shipped_date,
    o.ship_city,
    o.ship_country,
    o.freight,
    o.is_shipped,
    CASE
        WHEN o.shipped_date IS NULL
          OR o.required_date IS NULL
        THEN NULL
        ELSE o.shipped_date <= o.required_date
    END AS is_on_time,
    o.shipped_date - o.order_date AS delai_livraison_jours,
    COALESCE(od.nb_articles, 0)::SMALLINT AS nb_articles,
    COALESCE(od.quantite_totale, 0)::SMALLINT AS quantite_totale,
    COALESCE(od.montant_total, 0) AS montant_total
FROM {{ ref('stg_orders') }} o
LEFT JOIN order_details_aggregated od
    ON o.order_id = od.order_id