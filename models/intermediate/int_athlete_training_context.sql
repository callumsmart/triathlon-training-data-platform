WITH athlete AS (

    SELECT *

    FROM {{ ref('stg_athlete_profile') }}

),


training_preferences AS (

    SELECT *

    FROM {{ ref('stg_training_preferences') }}

),


training_targets AS (

    SELECT

        athlete_id,


        MAX(
            CASE 
                WHEN sport = 'run'
                THEN sessions_per_week
            END
        ) AS run_target_sessions,


        MAX(
            CASE 
                WHEN sport = 'bike'
                THEN sessions_per_week
            END
        ) AS bike_target_sessions,


        MAX(
            CASE 
                WHEN sport = 'swim'
                THEN sessions_per_week
            END
        ) AS swim_target_sessions,


        MAX(
            CASE 
                WHEN sport = 'run'
                THEN target_hours_per_week
            END
        ) AS run_target_hours,


        MAX(
            CASE 
                WHEN sport = 'bike'
                THEN target_hours_per_week
            END
        ) AS bike_target_hours,


        MAX(
            CASE 
                WHEN sport = 'swim'
                THEN target_hours_per_week
            END
        ) AS swim_target_hours


    FROM {{ ref('stg_training_targets') }}


    GROUP BY

        athlete_id

),


latest_week AS (

    SELECT *

    FROM {{ ref('mart_weekly_training_summary') }}


    QUALIFY ROW_NUMBER() OVER (

        ORDER BY training_week DESC

    ) = 1

)


SELECT


    athlete.athlete_id,


    -- Race information

    athlete.race_name,

    athlete.race_date,


    DATEDIFF(
        'week',
        CURRENT_DATE,
        athlete.race_date
    ) AS weeks_to_race,


    athlete.current_phase,


    -- Training targets

    training_targets.run_target_sessions,

    training_targets.bike_target_sessions,

    training_targets.swim_target_sessions,


    training_targets.run_target_hours,

    training_targets.bike_target_hours,

    training_targets.swim_target_hours,


    -- Training preferences

    training_preferences.easy_percent,

    training_preferences.hard_percent,


    -- Latest completed week

    latest_week.training_week,


    latest_week.total_sessions,

    latest_week.total_training_hours,


    latest_week.running_distance_km,

    latest_week.cycling_distance_km,

    latest_week.swimming_distance_km,


    latest_week.running_hours,

    latest_week.cycling_hours,

    latest_week.swimming_hours,


    latest_week.average_heart_rate,

    latest_week.total_aerobic_training_effect


FROM athlete


LEFT JOIN training_targets

    USING (athlete_id)


LEFT JOIN training_preferences

    USING (athlete_id)


CROSS JOIN latest_week