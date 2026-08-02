select
    md5(cast(row_number() over () as varchar)) as activity_id,

    try_cast("Date" as date) as activity_date,
    "Activity Type" as activity_type,
    "Title" as title,
    "Favorite" as favorite,

    case
        when "Activity Type" = 'Running' then 'running'
        when "Activity Type" in ('Pool Swim', 'Open Water Swimming') then 'swimming'
        when "Activity Type" = 'Cycling' then 'cycling'
        else 'other'
    end as sport_category,

    case
        when "Activity Type" in ('Pool Swim', 'Open Water Swimming')
            then "Distance" / 1000
        else "Distance"
    end as distance_km,

    
    (
        split_part("Time", ':', 1)::INTEGER * 3600 +
        split_part("Time", ':', 2)::INTEGER * 60 +
        split_part("Time", ':', 3)::INTEGER
    ) as duration_seconds,

    (
        split_part("Moving Time", ':', 1)::INTEGER * 3600 +
        split_part("Moving Time", ':', 2)::INTEGER * 60 +
        split_part("Moving Time", ':', 3)::INTEGER
    ) as moving_time_seconds,

    (
        split_part("Elapsed Time", ':', 1)::INTEGER * 3600 +
        split_part("Elapsed Time", ':', 2)::INTEGER * 60 +
        split_part("Elapsed Time", ':', 3)::INTEGER
    ) as elapsed_time_seconds,
    
    "Avg HR" as avg_heart_rate,
    "Max HR" as max_heart_rate,
    "Aerobic TE" as aerobic_training_effect,

    "Avg Pace" as avg_pace_seconds_per_km,
    "Avg GAP" as avg_gap_seconds_per_km,

    "Avg Stride Length" as avg_stride_length_m,
    "Avg Vertical Ratio" as avg_vertical_ratio,
    "Avg Vertical Oscillation" as avg_vertical_oscillation,
    "Avg Ground Contact Time" as avg_ground_contact_time_ms,

    "Total Ascent" as total_ascent,
    "Total Descent" as total_descent,

    "Avg Power" as avg_power,
    "Max Power" as max_power,
    "Normalized Power® (NP®)" as normalized_power,
    "Training Stress Score®" as training_stress_score,

    "Avg Swim Cadence" as avg_swim_cadence,
    "Max Swim Cadence" as max_swim_cadence,
    "Total Strokes" as total_strokes,
    "Avg. Swolf" as avg_swolf,
    "Avg Stroke Rate" as avg_stroke_rate,
    "Number of Laps" as number_of_laps,
    "Best Lap Time" as best_lap_time,

    "Avg Pace" as avg_pace_seconds_per_100m,

    *

from raw_garmin_activities