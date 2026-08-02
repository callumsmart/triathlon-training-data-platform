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

    avg_pace_seconds_per_km,
    avg_gap_seconds_per_km,

    avg_stride_length_m,
    avg_vertical_ratio,
    avg_vertical_oscillation,
    avg_ground_contact_time_ms,

    total_ascent,
    total_descent

FROM {{ ref('stg_activities') }}

WHERE sport_category = 'running'