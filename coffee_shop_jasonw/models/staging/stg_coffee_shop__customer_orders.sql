select
     customer_id
     , count(*) as n_orders
     , min(created_at) as first_order_at
from `analytics-engineers-club.coffee_shop.orders` 
group by 1