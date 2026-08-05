select *
from {{ ref('stg_activities') }}
where duration_seconds <= 0