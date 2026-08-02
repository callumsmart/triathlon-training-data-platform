SELECT
    activity_id,
    activity_date,
    activity_type,
    title,

    distance_km,
    duration_seconds,
    moving_time_seconds,
    elapsed_time_seconds,

    avg_heart_rate,
    max_heart_rate,
    aerobic_training_effect,

    avg_pace_seconds_per_100m,

    total_strokes,
    avg_swolf,
    avg_stroke_rate,
    number_of_laps

FROM {{ ref('stg_activities') }}

WHERE sport_category = 'swimming'