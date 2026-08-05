select *
from {{ ref('stg_activities') }}
where activity_date > current_date