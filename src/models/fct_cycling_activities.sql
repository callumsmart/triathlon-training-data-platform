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

    avg_power,
    max_power,
    normalized_power,
    training_stress_score,

    total_ascent,
    total_descent

FROM stg_activities

WHERE sport_category = 'cycling'