select

    athlete_id,

    sport,

    sessions_per_week,

    target_hours_per_week

from {{ ref('training_targets') }}