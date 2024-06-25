with
    pull_request as (
        select * from {{ ref('stg_github__pull_request') }}
    ),

    repositories as (
        select * from {{ ref('stg_github__repositories') }}
    ),

    issue as (
        select * from {{ ref('stg_github__issue') }}
    ),

    issues_merged as (
        select * from {{ ref('stg_github__issues_merged') }}
    ),


final as (

select
    pull_request.pull_request_id,
    repositories.name as repo_name,
    issue.number as pull_request_number,

    --TO DO: Find out how to label this
    cast(null as string) as type, --(bug, eng, features)
    --TO DO: Find out how to label this
    case
        when pull_request.is_draft then 'draft'
        when issues_merged.merged_at is not null then 'merged'
        when issue.closed_at is not null then 'closed_without_merge'
        else 'open'
    end as state,

    issue.created_at as opened_at,
    issues_merged.merged_at,
    round(date_diff(issues_merged.merged_at, issue.created_at, hour) / 24.0, 2) as days_open_to_merge

from pull_request
left join repositories
    on pull_request.head_repo_id = repositories.repo_id
left join issue
    on pull_request.issue_id = issue.issue_id
left join issues_merged
    on pull_request.issue_id = issues_merged.issue_id

)

select * from final