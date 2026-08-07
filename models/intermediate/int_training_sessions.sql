SELECT

    activity_id,
    activity_date,
    'running' AS sport,
    title,

    distance_km,
    duration_seconds,
    moving_time_seconds,
    elapsed_time_seconds,

    avg_heart_rate,
    max_heart_rate,
    aerobic_training_effect,

    -- Running metrics
    avg_pace_seconds_per_km,
    avg_gap_seconds_per_km,

    -- Cycling metrics
    NULL AS avg_power,
    NULL AS normalized_power,
    NULL AS training_stress_score,

    -- Swimming metrics
    NULL AS avg_pace_seconds_per_100m,
    NULL AS total_strokes,
    NULL AS avg_swolf,
    NULL AS avg_stroke_rate,
    NULL AS number_of_laps,

    -- Elevation
    total_ascent,
    total_descent


FROM {{ ref('fct_running_activities') }}


UNION ALL


SELECT

    activity_id,
    activity_date,
    'cycling' AS sport,
    title,

    distance_km,
    duration_seconds,
    moving_time_seconds,
    elapsed_time_seconds,

    avg_heart_rate,
    max_heart_rate,
    aerobic_training_effect,

    -- Running metrics
    NULL AS avg_pace_seconds_per_km,
    NULL AS avg_gap_seconds_per_km,

    -- Cycling metrics
    avg_power,
    normalized_power,
    training_stress_score,

    -- Swimming metrics
    NULL AS avg_pace_seconds_per_100m,
    NULL AS total_strokes,
    NULL AS avg_swolf,
    NULL AS avg_stroke_rate,
    NULL AS number_of_laps,

    total_ascent,
    total_descent


FROM {{ ref('fct_cycling_activities') }}


UNION ALL


SELECT

    activity_id,
    activity_date,
    'swimming' AS sport,
    title,

    distance_km,
    duration_seconds,
    moving_time_seconds,
    elapsed_time_seconds,

    avg_heart_rate,
    max_heart_rate,
    aerobic_training_effect,

    -- Running metrics
    NULL AS avg_pace_seconds_per_km,
    NULL AS avg_gap_seconds_per_km,

    -- Cycling metrics
    NULL AS avg_power,
    NULL AS normalized_power,
    NULL AS training_stress_score,

    -- Swimming metrics
    avg_pace_seconds_per_100m,
    total_strokes,
    avg_swolf,
    avg_stroke_rate,
    number_of_laps,

    NULL AS total_ascent,
    NULL AS total_descent


FROM {{ ref('fct_swimming_activities') }}