WITH stats_categories AS (
    SELECT
        *,
        AVG(unit_price) OVER (
            PARTITION BY category_name
        ) AS prix_moyen_categorie
    FROM {{ ref('int_products_enriched') }}
)
SELECT
    product_id,
    product_name,
    unit_price,
    units_in_stock,
    units_on_order,
    discontinued,
    en_stock,
    category_name,
    category_description,
    supplier_name,
    supplier_country,
    CASE
        WHEN unit_price < prix_moyen_categorie * 0.75
            THEN 'Entrée de gamme'
        WHEN unit_price <= prix_moyen_categorie * 1.25
            THEN 'Milieu de gamme'
        ELSE 'Premium'
    END AS gamme
FROM stats_categories

-- La gamme est définie par rapport au prix moyen de chaque catégorie.
-- < 75 % : Entrée de gamme | 75-125 % : Milieu de gamme | > 125 % : Premium.
-- Cela évite d'appliquer les mêmes seuils à des catégories ayant des niveaux de prix très différents.