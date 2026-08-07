with context as (

    select *

    from {{ ref('int_athlete_training_context') }}

),

weekly as (

    select *

    from {{ ref('mart_weekly_training_summary') }}

),

recent_training as (

    select

        avg(total_training_hours) as avg_hours_last_4_weeks,

        avg(running_distance_km) as avg_running_distance_last_4_weeks,

        avg(cycling_distance_km) as avg_cycling_distance_last_4_weeks,

        avg(swimming_distance_km) as avg_swimming_distance_last_4_weeks

    from weekly

    where training_week >= current_date - interval '28 days'

),

last_week as (

    select *

    from weekly

    qualify row_number() over (
        order by training_week desc
    ) = 1

)

select

    context.athlete_id,

    context.race_name,

    context.race_date,

    context.weeks_to_race,

    context.current_phase,


    -- Latest training week

    last_week.training_week,

    last_week.total_sessions,

    last_week.total_training_hours,

    last_week.running_distance_km,

    last_week.cycling_distance_km,

    last_week.swimming_distance_km,


    -- Targets

    context.run_target_sessions,
    context.bike_target_sessions,
    context.swim_target_sessions,

    context.run_target_hours,
    context.bike_target_hours,
    context.swim_target_hours,


    -- Recent trends

    recent_training.avg_hours_last_4_weeks,

    recent_training.avg_running_distance_last_4_weeks,

    recent_training.avg_cycling_distance_last_4_weeks,

    recent_training.avg_swimming_distance_last_4_weeks,


    -- Simple readiness flags

    case
        when last_week.swimming_distance_km is null
             or last_week.swimming_distance_km = 0
        then true
        else false
    end as swimming_missing,


    case
        when last_week.cycling_distance_km is null
             or last_week.cycling_distance_km = 0
        then true
        else false
    end as cycling_missing


from context

cross join last_week

cross join recent_training