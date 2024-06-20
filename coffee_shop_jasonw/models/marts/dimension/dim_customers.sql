{{ config(materialized='table') }}

with customer_orders as (
  
  select * 
  from {{ ref('stg_coffee_shop__customer_orders') }}
)

select 
  customers.id as customer_id
  , customers.name
  , customers.email
  , coalesce(customer_orders.n_orders, 0) as n_orders
  , customer_orders.first_order_at
from {{ source('coffee_shop', 'customers') }} as customers --`analytics-engineers-club.coffee_shop.customers` as customers
left join  customer_orders
  on  customers.id = customer_orders.customer_id 

order by 5