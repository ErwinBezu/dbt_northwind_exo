WITH ca_par_categorie AS (
    SELECT
        p.category_name,
        ROUND(SUM(ps.ca_genere), 2) AS ca_total
    FROM {{ ref('fact_order_lines') }} ps
    JOIN {{ ref('dim_products') }} p
        ON ps.product_id = p.product_id
    GROUP BY p.category_name
)
SELECT
    category_name,
    ca_total
FROM ca_par_categorie
WHERE ca_total = (SELECT MAX(ca_total)FROM ca_par_categorie)