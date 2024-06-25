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
    
    product_prices as (
        select * from {{ ref('stg_coffee_shop__product_prices') }}
    ),

final as (

select
    order_items.order_item_id,
    order_items.order_id,
    orders.customer_id,
    order_items.product_id,
    dense_rank() over(order by orders.created_at) as order_no,
    customers.customer_name,
    rank() over(partition by orders.customer_id order by orders.created_at) as no_cust_orders,
    case
        when rank() over(partition by orders.customer_id order by orders.created_at) = 1 then "New" else "Returning"
    end as new_vs_returning,
    products.product_name,
    products.category,
    product_prices.price,
    orders.sales,
    orders.created_at
from order_items
left join orders on order_items.order_id = orders.order_id
left join products on order_items.product_id = products.product_id
left join customers on orders.customer_id = customers.customer_id
left join product_prices on order_items.product_id = product_prices.product_id
    and orders.created_at between product_prices.created_at and product_prices.ended_at

)

select * from final
order by order_no desc