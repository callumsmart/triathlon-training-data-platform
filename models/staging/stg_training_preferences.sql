select

    athlete_id,

    easy_percent,

    hard_percent

from {{ ref('training_preferences') }}