SELECT DISTINCT
    order_date AS date_id,
    EXTRACT(DAY FROM order_date)::SMALLINT AS jour, 
    EXTRACT(MONTH FROM order_date)::SMALLINT AS mois, 
    EXTRACT(YEAR FROM order_date)::SMALLINT AS annee,
    EXTRACT(QUARTER FROM order_date)::SMALLINT AS trimestre,
    TO_CHAR(order_date, 'YYYY-MM')::VARCHAR(7) AS annee_mois, 
    (EXTRACT(DOW FROM order_date) = 0 OR EXTRACT(DOW FROM order_date) = 6) AS est_weekend
FROM {{ ref('stg_orders')}}     