select *
from {{ ref('stg_activities') }}
where activity_type = 'Running'
and avg_pace_seconds_per_km is null