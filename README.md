# Northwind Data Warehouse avec dbt

Projet réalisé dans le cadre d'un exercice de Data Engineering visant à construire un Data Warehouse analytique à partir de la base de données **Northwind** à l'aide de **dbt** et **PostgreSQL**.

## Objectifs

L'objectif est de transformer une base OLTP en un Data Warehouse organisé selon une architecture analytique.

Le projet couvre notamment :

- Création des modèles **staging**
- Création des modèles **intermediate**
- Construction d'un modèle en étoile (dimensions + tables de faits)
- Création d'un mart analytique
- Création de requêtes analytiques avec des fonctions fenêtre (`LAG`, `DENSE_RANK`, `ROW_NUMBER`, `SUM OVER`)
- Mise en place de tests de qualité des données
- Génération de la documentation dbt

---

## Technologies utilisées

- dbt Core
- dbt-postgres
- PostgreSQL
- SQL
- Git / GitHub
- Power BI (visualisation)

---

## Architecture du projet

```
northwind_dwh/
│
├── models/
│   ├── staging/
│   │   ├── schema.yml
│   │   ├── sources.yml
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_order_details.sql
│   │   ├── stg_products.sql
│   │   ├── stg_categories.sql
│   │   ├── stg_suppliers.sql
│   │   ├── stg_employees.sql
│   │   └── stg_shippers.sql
│   │
│   ├── intermediate/
│   │   ├── schema.yml
│   │   ├── int_orders_enriched.sql
│   │   ├── int_products_enriched.sql
│   │   ├── int_customers_stats.sql
│   │   ├── int_employee_stats.sql
│   │   ├── int_monthly_revenue.sql
│   │   └── int_product_sales.sql
│   │
│   └── marts/
│       ├── schema.yml
│       ├── dim_customers.sql
│       ├── dim_products.sql
│       ├── dim_employees.sql
│       ├── dim_shippers.sql
│       ├── dim_temps.sql
│       ├── fact_order_lines.sql
│       ├── fact_orders.sql
│       └── mart_employee_performance.sql
│
├── analyses/
│   ├── q23_01_employe_meilleur_ca.sql
│   ├── q23_02_pays_plus_commande.sql
│   ├── q23_03_transporteur_meilleur_delai.sql
│   ├── q23_04_categorie_plus_rentable.sql
│   ├── q23_05_clients_inactif_90j.sql
│   ├── q23_b_top5_produits_vendus.sql
│   ├── q23_c_ca_variations.sql
│   ├── q23_d_ca_par_pays.sql
│   ├── q23_e_clients_vip.sql
│   └── q23_f_top3_mois_ca_employes.sql
│
├── tests/
│   ├── test_fact_orders_ca_matches_order_details.sql
│   ├── test_fact_orders_count.sql
│   ├── test_fact_orders_customer_exists.sql
│   ├── test_fact_orders_employee_exists.sql
│   ├── test_fact_orders_exists_in_dim_temps.sql
│   ├── test_fact_orders_shippers_exists.sql
│   ├── test_montant_total_avec_frais.sql
│   └── test_order_date_dim_temps.sql
│
└──dbt_project.yml
```

---

## Structure des modèles

### Staging

Les modèles de staging nettoient et standardisent les données provenant des tables sources.

Principales transformations :

- nettoyage des chaînes de caractères (`TRIM`)
- standardisation de la casse
- typage des colonnes
- renommage des champs
- création de colonnes calculées (`is_shipped`, `sous_total`, `en_stock`, `full_name`, ...)

---

### Intermediate

Les modèles intermédiaires enrichissent les données métier.

Ils permettent notamment de calculer :

- le montant total des commandes
- les délais de livraison
- les statistiques clients
- les statistiques employés
- le chiffre d'affaires mensuel
- les ventes par produit

---

### Marts

Les marts constituent la couche de restitution.

Dimensions :

- `dim_customers`
- `dim_products`
- `dim_employees`
- `dim_shippers`
- `dim_temps`

Tables de faits :

- `fact_orders` : une ligne par commande, utilisée pour l'analyse du chiffre
  d'affaires, des clients, des employés et des livraisons.
- `fact_order_lines` : une ligne par produit et par commande, utilisée pour
  l'analyse détaillée des ventes, des quantités et du chiffre d'affaires
  par produit ou catégorie.

Mart analytique :

- `mart_employee_performance`

---

## Analyses SQL

Le dossier `analyses/` contient plusieurs requêtes permettant de valider
et d'exploiter le Data Warehouse.

Les analyses réalisées portent notamment sur :

- l'employé générant le plus de chiffre d'affaires
- les pays générant le plus de commandes
- les performances des transporteurs
- le chiffre d'affaires par catégorie de produits
- les clients inactifs depuis plus de 90 jours
- le Top 5 des produits vendus avec `DENSE_RANK`
- l'évolution mensuelle du CA avec `LAG`
- la comparaison avec le même mois de l'année précédente
- le classement des pays et leur part du CA mondial
- l'identification des clients VIP
- les trois meilleurs mois de chaque employé avec `ROW_NUMBER`

---

## Tests de qualité

Le projet contient plusieurs types de tests dbt afin de vérifier la fiabilité des données.

### Tests sur les modèles staging

- `not_null` sur les clés primaires
- `unique` sur les clés primaires
- test spécifique pour la clé composée de `stg_order_details`

### Tests sur les marts

- `relationships` entre `fact_orders` et :
  - `dim_customers`
  - `dim_employees`
  - `dim_shippers`
- `accepted_values` sur la colonne `gamme` de `dim_products`
- `not_null` sur `montant_total` et `freight` dans `fact_orders`
- `not_null` sur `is_on_time`, uniquement pour les commandes livrées grâce à une configuration `where`

### Tests singuliers

Des tests SQL personnalisés sont également présents dans le dossier `tests/` afin de vérifier :

- que le nombre de commandes de `fact_orders` correspond à celui de la source `orders`
- qu'aucune commande ne référence un client absent de `dim_customers`
- qu'aucune date de commande n'est absente de `dim_temps`
- que le chiffre d'affaires de `fact_orders` est cohérent avec celui calculé depuis `order_details`
- qu'aucune commande ne référence un employé absent de `dim_employees`
- qu'aucune commande ne référence un transporteur absent de `dim_shippers`
- que `montant_total_avec_frais` n'est jamais inférieur à `montant_total`

---

## Gestion des droits PostgreSQL

Le projet utilise un utilisateur dédié `dbt_user` disposant des droits nécessaires
pour lire les données sources et créer les modèles dbt dans le schéma de développement.

### Vérification des droits sur le schéma public

Une tentative d'insertion dans une table du schéma `public` avec `dbt_user` a été effectuée :

```sql
INSERT INTO public.categories (category_name)
VALUES ('TEST');
```
---

## Data Lineage

Le lineage généré par dbt permet de visualiser les dépendances entre les
sources, les modèles de staging, les modèles intermédiaires et les marts.

![Data Lineage](docs/lineage_graph.png)

---

## Exécution

Installer les dépendances :

```bash
pip install -r requirements.txt
```

Lancer les modèles :

```bash
dbt run
```

Exécuter les tests :

```bash
dbt test
```

Construire entièrement le projet :

```bash
dbt build
```

Générer la documentation :

```bash
dbt docs generate
dbt docs serve
```
Commandes dbt/sélection des modèles (question 24c)
```bash
dbt build --select fact_orders+
```
Le + placé après `fact_orders` permet de sélectionner fact_orders ainsi que tous les modèles qui en dépendent (ses descendants). La commande dbt build exécute également les tests associés aux modèles sélectionnés.

---

## Schéma du projet

Le projet suit une architecture classique en couches :

```
Sources PostgreSQL (Northwind)
            │
            ▼
         Staging
            │
            ▼
       Intermediate
            │
            ▼
    ┌───────────────────┐
    │ Dimensions        │
    │ Tables de faits   │
    └───────────────────┘
            │
            ▼
    Mart analytique
            │
            ▼
        Power BI

Analyses SQL => interrogation et validation du DWH
```

---