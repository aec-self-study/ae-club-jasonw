select
    order_items.id,
    order_items.order_id,
    order_items.product_id,
    products.name,
    products.category,
    product_prices.price
from {{ source('coffee_shop', 'order_items') }} as order_items
left join {{ source('coffee_shop', 'products') }} as products on order_items.product_id = products.id
left join {{ source('coffee_shop', 'productprices') }} as product_prices on order_items.product_id = product_prices.product_id
