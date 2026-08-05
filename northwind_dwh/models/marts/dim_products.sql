SELECT
    *,
    CASE
        WHEN unit_price < 20 THEN 'Entrée de gamme'
        WHEN unit_price < 80 THEN 'Milieu de gamme'
        ELSE 'Premium'
    END AS gamme
FROM {{ ref('int_products_enriched') }}

-- Pour le moment c'est juste un découpage subjectif de cette manière.
-- J'attends la fin de la partie 3 pour revenir dessus. 
