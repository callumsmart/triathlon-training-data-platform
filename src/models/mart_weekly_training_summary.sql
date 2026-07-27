SELECT
    DATE_TRUNC('week', activity_date) AS training_week,

    COUNT(*) AS total_sessions,

    -- Running
    COUNT(*) FILTER (
        WHERE sport = 'running'
    ) AS running_sessions,

    ROUND(
        SUM(distance_km) FILTER (
            WHERE sport = 'running'
        ),
        2
    ) AS running_distance_km,

    -- Cycling
    COUNT(*) FILTER (
        WHERE sport = 'cycling'
    ) AS cycling_sessions,

    ROUND(
        SUM(distance_km) FILTER (
            WHERE sport = 'cycling'
        ),
        2
    ) AS cycling_distance_km,

    -- Swimming
    COUNT(*) FILTER (
        WHERE sport = 'swimming'
    ) AS swimming_sessions,

    ROUND(
        SUM(distance_km) FILTER (
            WHERE sport = 'swimming'
        ),
        2
    ) AS swimming_distance_km,

    -- Overall training volume
    ROUND(
        SUM(duration_seconds) / 3600,
        2
    ) AS total_training_hours,

    ROUND(
        SUM(distance_km),
        2
    ) AS total_distance_km,

    ROUND(
        AVG(TRY_CAST(avg_heart_rate AS DOUBLE)),
        0
    ) AS average_heart_rate,

    ROUND(
        SUM(
            TRY_CAST(
                aerobic_training_effect AS DOUBLE
            )
        ),
        2
    ) AS total_aerobic_training_effect

FROM int_training_sessions

GROUP BY
    DATE_TRUNC('week', activity_date)

ORDER BY
    training_week DESC