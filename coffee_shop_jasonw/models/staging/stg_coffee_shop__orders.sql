{{ config(materialized='table') }}

with source as (

    select * from {{ source('coffee_shop', 'orders') }}

),

renamed as (

    select
        id as order_id,
        customer_id,
        total as sales,
        address,
        state,
        zip,

        --timestamp
        created_at

    from source

)

select * from renamed