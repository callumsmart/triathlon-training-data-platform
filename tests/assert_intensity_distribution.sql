select *
from {{ ref('stg_training_preferences') }}

where easy_percent + hard_percent <> 100