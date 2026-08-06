select

    athlete_id,

    race_name,

    cast(race_date as date) as race_date,

    swim_distance_km,
    bike_distance_km,
    run_distance_km,

    target_finish_time_minutes,

    current_phase

from {{ ref('athlete_profile') }}