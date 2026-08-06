select

    athlete_id,

    day_of_week,

    available,

    preferred_sport,

    max_duration_minutes

from {{ ref('training_schedule') }}