{{ config(materialized='table') }}

select
    cast(date_trunc(created_at, week) as date) as date_week,
    category,
    new_vs_returning,
    sum(price) as sales
from {{ ref('int_weekly_sales') }}
group by 1, 2, 3
order by 1 desc, 2, 3
