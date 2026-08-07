WITH classement_produits AS (
    SELECT 
        f.product_id,
        d.product_name,
        SUM(f.quantity) AS quantite_totale_vendue,
        ROUND(SUM(f.sous_total), 2) AS ca_total,
        d.category_name,
        DENSE_RANK() OVER( ORDER BY SUM(f.quantity) DESC) AS rang
    FROM {{ ref('fact_order_lines') }} f
    JOIN {{ ref('dim_products') }} d ON d.product_id = f.product_id
    GROUP BY 
        f.product_id,
        d.product_name,
        d.category_name
)
SELECT *
FROM classement_produits
WHERE rang <= 5
ORDER BY rang, product_name