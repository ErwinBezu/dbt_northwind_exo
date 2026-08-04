-- Le choix à été fait de ne pas mettre la colonne picture qui n'apporte rien aux analyses
SELECT
    category_id,
    category_name,
    description
FROM {{ source('northwind', 'categories') }}