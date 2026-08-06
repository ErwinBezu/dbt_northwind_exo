SELECT DISTINCT
    order_date AS date_id,
    EXTRACT(DAY FROM order_date) AS jour, 
    EXTRACT(MONTH FROM order_date) AS mois, 
    EXTRACT(YEAR FROM order_date) AS annee,
    EXTRACT(QUARTER FROM order_date) AS trimestre,
    TO_CHAR(order_date, 'YYYY-MM') AS annee_mois, 
    (EXTRACT(DOW FROM order_date) = 0 OR EXTRACT(DOW FROM order_date) = 6) AS est_weekend
FROM {{ ref('stg_orders')}}     