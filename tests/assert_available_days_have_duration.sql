select *
from {{ ref('stg_training_schedule') }}

where available = true
  and max_duration_minutes <= 0