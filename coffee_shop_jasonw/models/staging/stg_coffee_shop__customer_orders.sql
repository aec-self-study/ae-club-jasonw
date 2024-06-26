{{ config(materialized='table') }}

select
     customer_id
     , count(*) as n_orders
     , min(created_at) as first_order_at
     , max(created_at) as latest_order_at
     ,sum(total) as total_spend
from {{ source('coffee_shop', 'orders') }} --`analytics-engineers-club.coffee_shop.orders` 
group by 1