SELECT *,
    (montant_total + freight) AS montant_total_avec_frais
FROM {{ ref('int_orders_enriched')}}