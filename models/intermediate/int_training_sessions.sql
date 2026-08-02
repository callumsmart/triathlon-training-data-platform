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
    aerobic_training_effect

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
    aerobic_training_effect

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
    aerobic_training_effect

FROM {{ ref('fct_swimming_activities') }}