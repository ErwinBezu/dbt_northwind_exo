WITH classement AS (
    SELECT
        f.employee_id,
        d.full_name,
        t.annee_mois AS mois,
        ROUND(SUM(montant_total_avec_frais)::NUMERIC, 2) AS ca_mensuel,
        ROW_NUMBER() OVER(PARTITION BY f.employee_id ORDER BY SUM(f.montant_total_avec_frais) DESC) AS rang
    FROM {{ ref('fact_orders') }} f
    JOIN {{ ref('dim_employees') }} d ON f.employee_id = d.employee_id
    JOIN {{ ref('dim_temps')}} t ON  f.order_date = t.date_id
    GROUP BY 
        f.employee_id,
        d.full_name,
        t.annee_mois
)
SELECT * FROM classement WHERE rang <= 3 ORDER BY employee_id, rang