select *
from {{ ref('stg_activities') }}
where distance_km < 0