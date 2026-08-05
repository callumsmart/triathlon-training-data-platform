select *
from {{ ref('stg_activities') }}
where activity_type in ('Pool Swim', 'Open Water Swimming')
and avg_pace_seconds_per_100m is null