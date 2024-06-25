with source as (
    select * from {{ source('github', 'issue_merged') }}
),

renamed as (
    select
        issue_id,
        actor_id as merge_user_id,
        
        commit_sha,

        --timestamps
        merged_at

        --_fivetran_synced (excluded column)
    from source
)

select * from renamed