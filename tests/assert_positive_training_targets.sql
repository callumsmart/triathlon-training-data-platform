select *
from {{ ref('stg_training_targets') }}

where sessions_per_week <= 0
   or target_hours_per_week <= 0