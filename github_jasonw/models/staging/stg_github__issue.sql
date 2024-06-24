{{ config(materialized='table') }}

with source as (

    select * from {{ source('github', 'issue') }}

),

renamed as (

    select
        id as issue_id,
        user_id,
        body,
        locked as is_locked,
        milestone_id,
        number,
        pull_request as is_pull_request,
        repository_id,
        state,
        title,
        --timestamp columns
        created_at,
        closed_at,
        updated_at
        
        --excluded columns
        --_fivetran_synced

    from source

)

select * from renamed