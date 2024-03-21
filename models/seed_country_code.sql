{{ config(
  materialized='table'
)}}

WITH country AS (
  SELECT * FROM {{ ref('stg_country_code') }}
)

SELECT
  country_code,
  country_name
FROM country
