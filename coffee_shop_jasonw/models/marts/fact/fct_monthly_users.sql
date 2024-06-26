{{ config(materialized='table') }}

select
    date_trunc(first_order_at, month) as signup_month,
    count(*) as new_customers
 
from {{ ref('dim_customers') }}
 
group by 1