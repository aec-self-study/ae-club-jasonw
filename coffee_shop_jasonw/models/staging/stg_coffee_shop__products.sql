{{ config(materialized='table') }}

with source as (

    select * from {{ source('coffee_shop', 'products') }}

),

renamed as (

    select
        id as product_id,
        name as product_name,
        category,

        --timestamp
        created_at

    from source

)

select * from renamed