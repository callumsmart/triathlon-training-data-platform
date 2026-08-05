select *
from {{ ref('stg_activities') }}
where aerobic_training_effect < 0
or aerobic_training_effect > 5