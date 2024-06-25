{{ config(materialized='table') }}

with
    order_items as (
        select * from {{ ref('stg_coffee_shop__order_items') }}
    ),

    orders as (
        select * from {{ ref('stg_coffee_shop__orders') }}
    ),

    products as (
        select * from {{ ref('stg_coffee_shop__products') }}
    ),
    
    customers as (
        select * from {{ ref('stg_coffee_shop__customers') }}
    ),

final as (

select
    order_items.order_item_id,
    order_items.order_id,
    dense_rank() over(order by orders.created_at) as order_no,
    orders.created_at,
    orders.customer_id,
    customers.customer_name,
    orders.sales,
    order_items.product_id,
    products.product_name,
    products.category
from order_items
left join orders on order_items.order_id = orders.order_id
left join products on order_items.product_id = products.product_id
left join customers on orders.customer_id = customers.customer_id

)

select * from final
order by order_no desc