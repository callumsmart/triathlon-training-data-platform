with readiness as (

    select *

    from {{ ref('mart_training_readiness') }}

)

select

    athlete_id,

    race_name,

    race_date,

    weeks_to_race,

    current_phase,


    /*
    Swimming risk
    */

    case
        when swimming_missing = true
        then 'Swimming volume missing'
        else null
    end as swimming_risk,


    /*
    Cycling risk
    */

    case
        when cycling_missing = true
        then 'Cycling volume missing'
        else null
    end as cycling_risk,


    /*
    Overall volume trend
    */

    case

        when total_training_hours >
             avg_hours_last_4_weeks * 1.3

        then 'Training volume increased quickly'

        else null

    end as volume_risk,


    /*
    Race preparation
    */

    case

        when weeks_to_race <= 8
             and swimming_missing = true

        then 'Swimming consistency is important before race'

        else null

    end as race_preparation_risk,


    /*
    Positive signals
    */

    case

        when total_training_hours >= avg_hours_last_4_weeks

        then 'Training volume is stable or increasing'

        else null

    end as positive_progress_signal


from readiness